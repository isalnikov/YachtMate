import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../core/providers.dart';
import '../../data/local/app_database.dart';
import '../../domain/training/colreg_quiz.dart';
import '../../io_compat/io_compat.dart';
import '../../l10n/app_localizations.dart';

final _colregQuestionsProvider =
    FutureProvider<List<ColregQuestion>>((ref) async {
  final raw =
      await rootBundle.loadString('assets/training/colreg_quiz_demo.json');
  return ColregQuestion.parseJson(raw);
});

final vhfRecordingsListProvider =
    FutureProvider<List<VhfRecordingRow>>((ref) {
  return ref.watch(vhfRecordingRepositoryProvider).allDescending();
});

/// УКВ-тренажёр: COLREG + записи + скорость + диктовка в текст (F12).
class VhfTrainingScreen extends StatelessWidget {
  const VhfTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: l10n.vhfTabQuiz),
              Tab(text: l10n.vhfTabSessions),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                _ColregQuizTab(),
                _VhfSessionsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColregQuizTab extends ConsumerStatefulWidget {
  const _ColregQuizTab();

  @override
  ConsumerState<_ColregQuizTab> createState() => _ColregQuizTabState();
}

class _ColregQuizTabState extends ConsumerState<_ColregQuizTab> {
  int _qi = 0;
  String? _picked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeControllerProvider).languageCode;
    final async = ref.watch(_colregQuestionsProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, st) => Center(child: Text(l10n.vhfQuizLoadError)),
      data: (qs) {
        if (qs.isEmpty) return Center(child: Text(l10n.vhfQuizEmpty));
        final q = qs[_qi.clamp(0, qs.length - 1)];
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                q.promptFor(lang),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              for (final c in q.choices)
                ListTile(
                  title: Text(c.labelFor(lang)),
                  selected: _picked == c.key,
                  onTap: () => setState(() => _picked = c.key),
                ),
              const Spacer(),
              Row(
                children: [
                  TextButton(
                    onPressed: _qi > 0
                        ? () => setState(() {
                              _qi--;
                              _picked = null;
                            })
                        : null,
                    child: Text(l10n.vhfQuizPrev),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () {
                      if (_picked == null) return;
                      if (_picked != q.correctKey) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.vhfQuizWrong)),
                        );
                        return;
                      }
                      if (_qi < qs.length - 1) {
                        setState(() {
                          _qi++;
                          _picked = null;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.vhfQuizComplete)),
                        );
                      }
                    },
                    child: Text(
                      _qi >= qs.length - 1 ? l10n.vhfQuizDone : l10n.vhfQuizNext,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VhfSessionsTab extends ConsumerStatefulWidget {
  const _VhfSessionsTab();

  @override
  ConsumerState<_VhfSessionsTab> createState() => _VhfSessionsTabState();
}

class _VhfSessionsTabState extends ConsumerState<_VhfSessionsTab> {
  final AudioPlayer _player = AudioPlayer();
  final AudioRecorder _recorder = AudioRecorder();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _recording = false;
  double _speed = 1;
  bool _listening = false;

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
    final async = ref.watch(vhfRecordingsListProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
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
          ],
        ),
        FilledButton.icon(
          onPressed: () => _toggleRecord(l10n),
          icon: Icon(_recording ? Icons.stop : Icons.fiber_manual_record),
          label: Text(_recording ? l10n.vhfRecordStop : l10n.vhfRecordStart),
        ),
        Expanded(
          child: async.when(
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (e, st) => Center(child: Text(l10n.vhfSessionsLoadError)),
            data: (rows) {
              if (rows.isEmpty) {
                return Center(child: Text(l10n.vhfSessionsEmpty));
              }
              return ListView.builder(
                itemCount: rows.length,
                itemBuilder: (ctx, i) {
                  final r = rows[i];
                  return ExpansionTile(
                    title: Text(
                      DateTime.fromMillisecondsSinceEpoch(r.t).toLocal().toString(),
                    ),
                    subtitle:
                        r.transcript != null ? Text(r.transcript!) : null,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () => _play(r.path),
                          ),
                          IconButton(
                            icon: _listening
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.mic_none),
                            onPressed:
                                _listening ? null : () => _transcribe(l10n, r.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              await deleteFileIfExists(r.path);
                              await ref
                                  .read(vhfRecordingRepositoryProvider)
                                  .deleteRecording(r.id);
                              ref.invalidate(vhfRecordingsListProvider);
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
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
  }
}
