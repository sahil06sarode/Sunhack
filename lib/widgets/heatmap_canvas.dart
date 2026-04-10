import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class HeatmapCanvas extends StatelessWidget {
  const HeatmapCanvas({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? SovereignPalette.heatmapDarkBackground : SovereignPalette.heatmapLightBackground,
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF222734),
                  Color(0xFF1F232B),
                  Color(0xFF1B202A),
                ],
              )
            : null,
      ),
      child: Stack(
        children: [
          if (!isDark) ...[
            Positioned.fill(
              child: CustomPaint(
                painter: _DotGridPainter(),
              ),
            ),
          ],
          Positioned.fill(
            child: isDark ? const _DarkHeatSpots() : const _LightHeatSpots(),
          ),
        ],
      ),
    );
  }
}

class _LightHeatSpots extends StatelessWidget {
  const _LightHeatSpots();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        _GlowSpot(color: SovereignPalette.heatmapRed, size: 86, opacity: 0.6, alignment: Alignment(0.2, -0.34)),
        _GlowSpot(color: SovereignPalette.heatmapRed, size: 64, opacity: 0.55, alignment: Alignment(0.3, -0.2)),
        _SolidSpot(color: SovereignPalette.heatmapRed, size: 176, opacity: 0.32, borderOpacity: 0.8, alignment: Alignment(-0.04, -0.08)),
        _GlowSpot(color: SovereignPalette.heatmapRed, size: 58, opacity: 0.55, alignment: Alignment(-0.2, -0.1)),
        _GlowSpot(color: SovereignPalette.heatmapRed, size: 70, opacity: 0.52, alignment: Alignment(0.14, -0.01)),
        _SolidSpot(color: SovereignPalette.heatmapOrange, size: 96, opacity: 0.36, borderOpacity: 0.86, alignment: Alignment(0.38, -0.16)),
        _SolidSpot(color: SovereignPalette.heatmapOrange, size: 104, opacity: 0.34, borderOpacity: 0.84, alignment: Alignment(0.52, -0.19)),
        _SolidSpot(color: SovereignPalette.heatmapOrange, size: 56, opacity: 0.36, borderOpacity: 0.86, alignment: Alignment(0.72, -0.13)),
        _GlowSpot(color: SovereignPalette.heatmapOrange, size: 42, opacity: 0.58, alignment: Alignment(0.53, -0.0)),
      ],
    );
  }
}

class _DarkHeatSpots extends StatelessWidget {
  const _DarkHeatSpots();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        _GlowSpot(color: SovereignPalette.heatmapRed, size: 260, opacity: 0.34, alignment: Alignment(-0.12, -0.1)),
        _GlowSpot(color: SovereignPalette.heatmapOrange, size: 188, opacity: 0.45, alignment: Alignment(0.25, -0.2)),
        _GlowSpot(color: SovereignPalette.heatmapYellow, size: 126, opacity: 0.5, alignment: Alignment(0.48, -0.17)),
        _GlowSpot(color: SovereignPalette.heatmapRed, size: 136, opacity: 0.32, alignment: Alignment(0.08, -0.34)),
        _GlowSpot(color: Color(0xFFFFF2BF), size: 72, opacity: 0.56, alignment: Alignment(0.38, -0.02)),
      ],
    );
  }
}

class _GlowSpot extends StatelessWidget {
  const _GlowSpot({
    required this.color,
    required this.size,
    required this.opacity,
    required this.alignment,
  });

  final Color color;
  final double size;
  final double opacity;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SolidSpot extends StatelessWidget {
  const _SolidSpot({
    required this.color,
    required this.size,
    required this.opacity,
    required this.borderOpacity,
    required this.alignment,
  });

  final Color color;
  final double size;
  final double opacity;
  final double borderOpacity;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: opacity),
            border: Border.all(
              color: color.withValues(alpha: borderOpacity),
            ),
          ),
        ),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = SovereignPalette.heatmapLightDot
      ..style = PaintingStyle.fill;

    const spacing = 20.0;
    const radius = 1.1;

    for (double y = 0; y <= size.height; y += spacing) {
      for (double x = 0; x <= size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
