import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:conflictsense/app.dart';
import 'package:conflictsense/core/bootstrap.dart';

Future<void> main() async {
  await AppBootstrap.initialize();
  runApp(const ProviderScope(child: ConflictSenseApp()));
}
