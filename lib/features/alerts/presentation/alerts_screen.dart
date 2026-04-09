import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:conflictsense/features/shared/providers/app_providers.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riskAsync = ref.watch(riskSnapshotProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Location Alerts',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Card(
          child: SizedBox(
            height: 220,
            child: kIsWeb
                ? const Center(child: Text('Map preview available on mobile builds.'))
                : GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(15.5007, 32.5599),
                      zoom: 3.2,
                    ),
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    markers: {
                      const Marker(
                        markerId: MarkerId('region-1'),
                        position: LatLng(15.5007, 32.5599),
                        infoWindow: InfoWindow(title: 'Risk Region'),
                      ),
                    },
                  ),
          ),
        ),
        const SizedBox(height: 12),
        riskAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text('Alert load failed: $error'),
          data: (risk) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Alert Level: ${risk.riskLevel}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Risk score ${risk.riskScore.toStringAsFixed(0)}'),
                    Text('Confidence ${risk.confidence.toStringAsFixed(0)}%'),
                    Text('Civilian impact ${risk.civilianImpact}'),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alert Timeline'),
                SizedBox(height: 8),
                Text('08:00 - Medium - Protest activity increased'),
                Text('10:00 - High - Clash events detected near central district'),
                Text('12:00 - High - Negative sentiment remains elevated'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
