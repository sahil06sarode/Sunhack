import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:conflictsense/core/config/app_config.dart';
import 'package:conflictsense/core/models/article.dart';
import 'package:conflictsense/core/models/conflict_report.dart';
import 'package:conflictsense/core/models/risk_snapshot.dart';
import 'package:conflictsense/features/shared/data/conflict_repository.dart';

final selectedRegionProvider = StateProvider<String>((ref) => AppConfig.defaultRegion);

final conflictRepositoryProvider = Provider<ConflictRepository>((ref) {
  return FirestoreConflictRepository(FirebaseFirestore.instance);
});

final articlesProvider = StreamProvider<List<Article>>((ref) {
  final region = ref.watch(selectedRegionProvider);
  final repo = ref.watch(conflictRepositoryProvider);
  return repo.watchLiveArticles(region);
});

final riskSnapshotProvider = StreamProvider<RiskSnapshot>((ref) {
  final region = ref.watch(selectedRegionProvider);
  final repo = ref.watch(conflictRepositoryProvider);
  return repo.watchRiskSnapshot(region);
});

final reportProvider = StreamProvider<ConflictReport?>((ref) {
  final region = ref.watch(selectedRegionProvider);
  final repo = ref.watch(conflictRepositoryProvider);
  return repo.watchLatestReport(region);
});
