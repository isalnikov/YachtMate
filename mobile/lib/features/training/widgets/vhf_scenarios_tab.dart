import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../core/providers.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../data/local/app_database.dart';
import '../../../domain/training/vhf_scenario.dart';
import '../../../io_compat/io_compat.dart';
import '../../../l10n/app_localizations.dart';
import '../vhf_training_providers.dart';
import 'vhf_dialogue_bubble.dart';
import 'vhf_record_button.dart';
import 'vhf_scenario_card.dart';

final vhfRecordingsListProvider =
    FutureProvider<List<VhfRecordingRow>>((ref) {
  return ref.watch(vhfRecordingRepositoryProvider).allDescending();
});

/// Scenarios tab: picker, dialogue practice, recordings with STT.
class VhfScenariosTab extends ConsumerStatefulWidget {
  const VhfScenariosTab({super.key});

  @override
  ConsumerState<VhfScenariosTab> createState() => _VhfScenariosTabState();
}

class _VhfScenariosTabState extends ConsumerState<VhfScenariosTab> {
  final AudioPlayer _player = AudioPlayer();
  final AudioRecorder _recorder = AudioRecorder();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _recording = false;
  double _speed = 1;
  bool _listening = false;
  String? _selectedScenarioId;

  @override
  void dispose() {
    _player.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _toggleRecord(AppLocalizations l10n) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.vhfRecordWebUnsupported)),
      );
      return;
    }
    final mic = await Permission.microphone.request();
    if (!mic.isGranted) return;

    if (!_recording) {
      final dir = await getApplicationDocumentsDirectory();
      final folder = p.join(dir.path, 'vhf');
      await ensureDirectoryRecursive(folder);
      final path =
          p.join(folder, '${DateTime.now().millisecondsSinceEpoch}.m4a');
      await _recorder.start(
        const RecordConfig(),
        path: path,
      );
      setState(() => _recording = true);
    } else {
      final out = await _recorder.stop();
      setState(() => _recording = false);
      if (out != null) {
        await ref.read(vhfRecordingRepositoryProvider).insertMeta(path: out);
        ref.invalidate(vhfRecordingsListProvider);
        await ref.read(auditRepositoryProvider).record(
              sessionId: ref.read(sessionIdProvider),
              module: 'M8',
              action: 'vhf_record_stop',
              contextJson: '{"path":"$out"}',
            );
      }
    }
  }

  Future<void> _play(String audPath) async {
    await _player.setFilePath(audPath);
    await _player.setSpeed(_speed);
    await _player.play();
  }

  Future<void> _transcribe(AppLocalizations l10n, String id) async {
    final ok = await _speech.initialize();
    if (!ok) return;
    setState(() => _listening = true);
    var buf = '';
    await _speech.listen(
      onResult: (r) => buf = r.recognizedWords,
      listenFor: const Duration(seconds: 45),
      pauseFor: const Duration(seconds: 4),
      listenOptions: stt.SpeechListenOptions(
        listenMode: stt.ListenMode.dictation,
      ),
    );
    setState(() => _listening = false);
    await ref.read(vhfRecordingRepositoryProvider).setTranscript(id, buf);
    ref.invalidate(vhfRecordingsListProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.vhfTranscribeDone)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeControllerProvider).languageCode;
    final scenariosAsync = ref.watch(vhfScenariosProvider);
    final recordingsAsync = ref.watch(vhfRecordingsListProvider);

    return scenariosAsync.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, st) => Center(child: Text(l10n.vhfScenariosLoadError)),
      data: (scenarios) {
        if (scenarios.isEmpty) {
          return Center(child: Text(l10n.vhfScenariosEmpty));
        }
        VhfScenario? selected;
        if (_selectedScenarioId != null) {
          for (final s in scenarios) {
            if (s.id == _selectedScenarioId) {
              selected = s;
              break;
            }
          }
        }
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (selected == null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      CwSpacing.m,
                      CwSpacing.m,
                      CwSpacing.m,
                      0,
                    ),
                    child: Text(
                      l10n.vhfScenarioPickHint,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(CwSpacing.m),
                      itemCount: scenarios.length,
                      itemBuilder: (ctx, i) {
                        final s = scenarios[i];
                        return VhfScenarioCard(
                          key: Key('vhf_scenario_${s.id}'),
                          scenario: s,
                          lang: lang,
                          selected: false,
                          onTap: () =>
                              setState(() => _selectedScenarioId = s.id),
                        );
                      },
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final active = selected!;
                        return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: CwSpacing.s,
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  tooltip: l10n.vhfScenarioBack,
                                  onPressed: () => setState(
                                    () => _selectedScenarioId = null,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    active.titleFor(lang),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: CwSpacing.m,
                              ),
                              itemCount: active.lines.length,
                              itemBuilder: (ctx, i) => VhfDialogueBubble(
                                line: active.lines[i],
                                lang: lang,
                              ),
                            ),
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              CwSpacing.m,
                              CwSpacing.s,
                              CwSpacing.m,
                              0,
                            ),
                            child: Text(
                              l10n.vhfSessionsHint,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  min: 0.5,
                                  max: 2,
                                  divisions: 6,
                                  label: '${_speed.toStringAsFixed(1)}×',
                                  value: _speed.clamp(0.5, 2),
                                  onChanged: (v) => setState(() => _speed = v),
                                ),
                              ),
                              Text('${_speed.toStringAsFixed(1)}×'),
                              const SizedBox(width: CwSpacing.s),
                            ],
                          ),
                          Expanded(
                            child: recordingsAsync.when(
                              loading: () => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                              error: (e, st) => Center(
                                child: Text(l10n.vhfSessionsLoadError),
                              ),
                              data: (rows) {
                                if (rows.isEmpty) {
                                  return Center(
                                    child: Text(l10n.vhfSessionsEmpty),
                                  );
                                }
                                return ListView.builder(
                                  itemCount: rows.length,
                                  itemBuilder: (ctx, i) {
                                    final r = rows[i];
                                    return ExpansionTile(
                                      title: Text(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          r.t,
                                        ).toLocal().toString(),
                                      ),
                                      subtitle: r.transcript != null
                                          ? Text(r.transcript!)
                                          : null,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.play_arrow,
                                              ),
                                              onPressed: () => _play(r.path),
                                            ),
                                            IconButton(
                                              icon: _listening
                                                  ? const SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                    )
                                                  : const Icon(Icons.mic_none),
                                              onPressed: _listening
                                                  ? null
                                                  : () => _transcribe(
                                                        l10n,
                                                        r.id,
                                                      ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete_outline,
                                              ),
                                              onPressed: () async {
                                                await deleteFileIfExists(
                                                  r.path,
                                                );
                                                await ref
                                                    .read(
                                                      vhfRecordingRepositoryProvider,
                                                    )
                                                    .deleteRecording(r.id);
                                                ref.invalidate(
                                                  vhfRecordingsListProvider,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(
                                            CwSpacing.m,
                                          ),
                                          child: Text(l10n.vhfTranscribeHint),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    ),
                  ),
                ],
              ],
            ),
            if (selected != null)
              Positioned(
                right: CwSpacing.m,
                bottom: CwSpacing.m,
                child: VhfRecordButton(
                  recording: _recording,
                  onPressed: () => _toggleRecord(l10n),
                ),
              ),
          ],
        );
      },
    );
  }
}
