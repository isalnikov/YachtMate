import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import '../../core/theme/cw_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_chip.dart';
import '../toolbox/maritime_toolbox_screen.dart';
import 'widgets/assistant_bubble.dart';

class _ChatMessage {
  const _ChatMessage({required this.text, required this.fromUser});

  final String text;
  final bool fromUser;
}

/// Offline FAQ chat with canned intents (step 54).
class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final _inputCtrl = TextEditingController();
  final _messages = <_ChatMessage>[];
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _messages.add(_ChatMessage(text: l10n.assistantWelcome, fromUser: false));
      });
    });
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  String _replyFor(String query, AppLocalizations l10n) {
    final q = query.toLowerCase();
    if (q.contains('weather') ||
        q.contains('wind') ||
        q.contains('погод') ||
        q.contains('ветер')) {
      return l10n.assistantReplyWeather;
    }
    if (q.contains('sos') || q.contains('distress') || q.contains('спас')) {
      return l10n.assistantReplySos;
    }
    if (q.contains('colreg') || q.contains('rule') || q.contains('правил')) {
      return l10n.assistantReplyColreg;
    }
    return l10n.assistantReplyFallback;
  }

  void _send(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _messages.add(_ChatMessage(text: trimmed, fromUser: true));
      _messages.add(
        _ChatMessage(text: _replyFor(trimmed, l10n), fromUser: false),
      );
    });
    _inputCtrl.clear();
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 100), () {
        if (_scrollCtrl.hasClients) {
          _scrollCtrl.animateTo(
            _scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(CwSpacing.m),
          child: Text(l10n.assistantLead),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: CwSpacing.m),
          child: Wrap(
            spacing: CwSpacing.s,
            runSpacing: CwSpacing.s,
            children: [
              CwChip(
                label: l10n.assistantIntentWeather,
                selected: false,
                onSelected: (_) => _send(l10n.assistantIntentWeather),
              ),
              CwChip(
                label: l10n.assistantIntentSos,
                selected: false,
                onSelected: (_) => _send(l10n.assistantIntentSos),
              ),
              CwChip(
                label: l10n.assistantIntentColreg,
                selected: false,
                onSelected: (_) => _send(l10n.assistantIntentColreg),
              ),
            ],
          ),
        ),
        const SizedBox(height: CwSpacing.s),
        Expanded(
          child: ListView.builder(
            controller: _scrollCtrl,
            padding: const EdgeInsets.symmetric(horizontal: CwSpacing.m),
            itemCount: _messages.length,
            itemBuilder: (context, i) {
              final m = _messages[i];
              return AssistantBubble(text: m.text, fromUser: m.fromUser);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(CwSpacing.m),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inputCtrl,
                  decoration: InputDecoration(hintText: l10n.assistantHint),
                  onSubmitted: _send,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send_outlined),
                onPressed: () => _send(_inputCtrl.text),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: Text(l10n.toolboxTitle)),
                  body: const MaritimeToolboxScreen(),
                ),
              ),
            );
          },
          child: Text(l10n.assistantHelpLink),
        ),
      ],
    );
  }
}
