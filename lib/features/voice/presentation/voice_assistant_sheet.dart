import 'dart:async';

import 'package:flutter/material.dart';

import 'package:conflictsense/core/config/app_config.dart';
import 'package:conflictsense/features/voice/data/gemini_live_service.dart';

class VoiceAssistantSheet extends StatefulWidget {
  const VoiceAssistantSheet({super.key});

  @override
  State<VoiceAssistantSheet> createState() => _VoiceAssistantSheetState();
}

class _VoiceAssistantSheetState extends State<VoiceAssistantSheet> {
  late final GeminiLiveService _service;
  final TextEditingController _promptController = TextEditingController();

  StreamSubscription<String>? _subscription;

  bool _busy = false;
  bool _connected = false;
  final List<String> _conversation = <String>[];

  @override
  void initState() {
    super.initState();
    _service = GeminiLiveService();
    _subscription = _service.transcriptStream.listen((message) {
      if (!mounted) return;
      setState(() {
        _conversation.add('Assistant: $message');
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _promptController.dispose();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: mq.viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gemini Live Voice Assistant',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            'Model: ${AppConfig.geminiLiveModel}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _busy
                      ? null
                      : () async {
                          setState(() => _busy = true);
                          try {
                            await _service.start();
                            if (!mounted) return;
                            setState(() {
                              _connected = true;
                              _conversation.add('System: Live session started.');
                            });
                          } catch (error) {
                            if (!mounted) return;
                            setState(() {
                              _conversation.add('System: $error');
                            });
                          } finally {
                            if (mounted) {
                              setState(() => _busy = false);
                            }
                          }
                        },
                  icon: const Icon(Icons.play_circle),
                  label: Text(_connected ? 'Connected' : 'Start Live'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: !_connected
                    ? null
                    : () async {
                        await _service.stop();
                        if (!mounted) return;
                        setState(() {
                          _connected = false;
                          _conversation.add('System: Session closed.');
                        });
                      },
                icon: const Icon(Icons.stop_circle_outlined),
                label: const Text('Stop'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Hackathon mode: text turns are already wired to Gemini Live. Replace with microphone PCM stream next for full duplex voice.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _promptController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Ask: Why is risk high in Sudan right now?',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: !_connected || _busy
                ? null
                : () async {
                    final text = _promptController.text.trim();
                    if (text.isEmpty) return;

                    setState(() {
                      _conversation.add('You: $text');
                      _promptController.clear();
                    });

                    try {
                      await _service.sendUserText(text);
                    } catch (error) {
                      if (!mounted) return;
                      setState(() {
                        _conversation.add('System: Failed to send prompt: $error');
                      });
                    }
                  },
            child: const Text('Send to Live Assistant'),
          ),
          const SizedBox(height: 12),
          Container(
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _conversation.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(_conversation[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
