import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class CircularProgressRing extends StatelessWidget {
  const CircularProgressRing({
    super.key,
    required this.value,
    this.size = 56,
    this.strokeWidth = 4.5,
    this.color = AppColors.primary,
    this.trackColor = AppColors.surfaceHighest,
    this.label,
    this.caption = 'PAID',
  });

  final double value;
  final double size;
  final double strokeWidth;
  final Color color;
  final Color trackColor;
  final String? label;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0, 1)),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, animated, _) {
          return CustomPaint(
            painter: _RingPainter(
              value: animated,
              strokeWidth: strokeWidth,
              color: color,
              trackColor: trackColor,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label ?? '${(animated * 100).round()}%',
                    style: AppText.labelSm.copyWith(
                      fontSize: 10,
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    caption,
                    style: AppText.labelSm.copyWith(
                      fontSize: 7,
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.value,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
  });

  final double value;
  final double strokeWidth;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final progress = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * value,
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor;
}

class IncomeBarChart extends StatelessWidget {
  const IncomeBarChart({
    super.key,
    required this.months,
    required this.values,
    this.onBarTap,
  });

  final List<String> months;
  final List<double> values;
  final ValueChanged<int>? onBarTap;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce(math.max) * 1.12;
    return SizedBox(
      height: 158,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < months.length; i++)
            Expanded(
              child: _Bar(
                month: months[i],
                value: values[i],
                ratio: values[i] / maxValue,
                highlighted: i == months.length - 1,
                onTap: onBarTap == null ? null : () => onBarTap!(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.month,
    required this.value,
    required this.ratio,
    required this.highlighted,
    this.onTap,
  });

  final String month;
  final double value;
  final double ratio;
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final barHeight = 104 * ratio;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              formatCompact(value),
              style: AppText.labelSm.copyWith(
                fontSize: 8,
                color: highlighted
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
                fontWeight: highlighted ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: 26,
              height: barHeight,
              decoration: BoxDecoration(
                color: highlighted
                    ? AppColors.primary
                    : AppColors.surfaceHigh,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
                boxShadow: highlighted
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.28),
                          blurRadius: 14,
                          spreadRadius: -2,
                        ),
                      ]
                    : null,
              ),
              child: highlighted
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.42),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 7),
            Text(
              month,
              style: AppText.labelSm.copyWith(
                fontSize: 9,
                color: highlighted
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
                fontWeight: highlighted ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
