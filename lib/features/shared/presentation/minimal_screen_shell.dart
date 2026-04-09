import 'package:flutter/material.dart';

class MinimalScreenShell extends StatelessWidget {
  const MinimalScreenShell({
    required this.title,
    this.note,
    this.child,
    super.key,
  });

  final String title;
  final String? note;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (note != null) ...[
              const SizedBox(height: 8),
              Text(note!),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: child ?? const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
