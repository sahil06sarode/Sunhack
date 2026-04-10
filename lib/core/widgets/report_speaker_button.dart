import 'package:flutter/material.dart';

import 'package:conflictsense/core/services/report_tts_service.dart';

class ReportSpeakerButton extends StatefulWidget {
  const ReportSpeakerButton({
    required this.speechText,
    this.iconColor = Colors.white,
    this.backgroundColor = const Color(0x59000000),
    super.key,
  });

  final String speechText;
  final Color iconColor;
  final Color backgroundColor;

  @override
  State<ReportSpeakerButton> createState() => _ReportSpeakerButtonState();
}

class _ReportSpeakerButtonState extends State<ReportSpeakerButton> {
  bool _isSpeaking = false;

  @override
  void dispose() {
    if (_isSpeaking) {
      ReportTtsService.instance.stop();
    }
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_isSpeaking) {
      await ReportTtsService.instance.stop();
      if (!mounted) {
        return;
      }

      setState(() {
        _isSpeaking = false;
      });
      return;
    }

    final text = widget.speechText.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No report content available to read aloud.'),
          duration: Duration(milliseconds: 1000),
        ),
      );
      return;
    }

    setState(() {
      _isSpeaking = true;
    });

    try {
      await ReportTtsService.instance.speak(text);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text-to-speech is unavailable on this device.'),
          duration: Duration(milliseconds: 1200),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _isSpeaking ? 'Stop narration' : 'Speak report',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: _handleTap,
          icon: Icon(
            _isSpeaking ? Icons.stop_rounded : Icons.volume_up_rounded,
            color: widget.iconColor,
          ),
        ),
      ),
    );
  }
}
