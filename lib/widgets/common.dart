import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.surface,
    this.gradient,
    this.glowColor,
    this.borderColor = AppColors.borderSoft,
    this.radius = 16,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final Gradient? gradient;
  final Color? glowColor;
  final Color borderColor;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 24,
            offset: Offset(0, 8),
            spreadRadius: -6,
          ),
        ],
      ),
      child: Stack(
        children: [
          if (glowColor != null)
            Positioned(
              top: -70,
              right: -60,
              child: IgnorePointer(
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        glowColor!.withValues(alpha: 0.20),
                        glowColor!.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: borderRadius,
              child: Padding(padding: padding, child: child),
            ),
          ),
        ],
      ),
    );
  }
}

class GlowDot extends StatelessWidget {
  const GlowDot({super.key, this.color = AppColors.primary, this.size = 8});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.65), blurRadius: 8),
        ],
      ),
    );
  }
}

class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.background,
    this.size = 40,
    this.iconSize = 20,
    this.radius = 12,
    this.circle = false,
  });

  final IconData icon;
  final Color color;
  final Color? background;
  final double size;
  final double iconSize;
  final double radius;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: 0.14),
        borderRadius: circle ? null : BorderRadius.circular(radius),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: color),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    this.trailing,
    this.trailingColor = AppColors.primary,
    this.onTrailingTap,
    this.trailingChevron = false,
  });

  final String title;
  final IconData? icon;
  final Color? iconColor;
  final String? trailing;
  final Color trailingColor;
  final VoidCallback? onTrailingTap;
  final bool trailingChevron;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: iconColor ?? AppColors.onSurfaceVariant),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            title,
            style: AppText.headlineSm.copyWith(fontSize: 17),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailing != null)
          InkWell(
            onTap: onTrailingTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trailing!,
                    style: AppText.labelMd.copyWith(
                      color: trailingColor,
                      fontSize: 11,
                    ),
                  ),
                  if (trailingChevron)
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: trailingColor,
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class AppPill extends StatelessWidget {
  const AppPill({
    super.key,
    required this.label,
    this.icon,
    this.background = AppColors.surfaceHigh,
    this.foreground = AppColors.onSurface,
    this.iconColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
    this.onTap,
    this.borderColor,
    this.textStyle,
    this.height,
    this.trailing,
  });

  final String label;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final Color? iconColor;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? borderColor;
  final TextStyle? textStyle;
  final double? height;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(999),
            border: borderColor == null
                ? null
                : Border.all(color: borderColor!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 17, color: iconColor ?? foreground),
                const SizedBox(width: 7),
              ],
              Text(
                label,
                style: (textStyle ?? AppText.labelMd).copyWith(
                  color: foreground,
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 6), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryActionPill extends StatelessWidget {
  const PrimaryActionPill({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.primary = false,
    this.iconColor,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool primary;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: primary ? AppColors.primary : AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(999),
            border: primary ? null : Border.all(color: AppColors.borderSoft),
            boxShadow: primary
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.22),
                      blurRadius: 18,
                      spreadRadius: -2,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: iconColor ??
                    (primary ? AppColors.onPrimary : AppColors.primary),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppText.labelMd.copyWith(
                  fontSize: 11.5,
                  color: primary ? AppColors.onPrimary : AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.primary,
    this.trackColor = AppColors.surfaceHighest,
    this.height = 8,
    this.glow = true,
  });

  final double value;
  final Color color;
  final Color trackColor;
  final double height;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: Container(
        height: height,
        color: trackColor,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: value.clamp(0, 1),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(height),
              boxShadow: glow
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.55),
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class SegmentSpec {
  const SegmentSpec(this.flex, this.color);
  final int flex;
  final Color color;
}

class AllocationBar extends StatelessWidget {
  const AllocationBar({
    super.key,
    required this.segments,
    this.remainingFlex = 0,
    this.height = 10,
  });

  final List<SegmentSpec> segments;
  final int remainingFlex;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(height),
      ),
      child: Row(
        children: [
          for (var i = 0; i < segments.length; i++) ...[
            if (i > 0) const SizedBox(width: 2),
            Expanded(
              flex: segments[i].flex,
              child: Container(
                decoration: BoxDecoration(
                  color: segments[i].color,
                  borderRadius: BorderRadius.circular(height),
                ),
              ),
            ),
          ],
          if (remainingFlex > 0) ...[
            const SizedBox(width: 2),
            Expanded(
              flex: remainingFlex,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceHighest,
                  borderRadius: BorderRadius.circular(height),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class FilterOption {
  const FilterOption(this.label, {this.count, this.accent});
  final String label;
  final int? count;
  final Color? accent;
}

class FilterChipRow extends StatelessWidget {
  const FilterChipRow({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<FilterOption> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _FilterChip(
              option: options[i],
              selected: i == selectedIndex,
              onTap: () => onSelected(i),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final FilterOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.primary : AppColors.surfaceHigh;
    final fg = selected ? AppColors.onPrimary : AppColors.onSurfaceVariant;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: selected ? null : Border.all(color: AppColors.borderSoft),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                option.label,
                style: AppText.labelMd.copyWith(
                  fontSize: 11,
                  color: fg,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              if (option.count != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.onPrimary.withValues(alpha: 0.18)
                        : AppColors.surfaceHighest,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${option.count}',
                    style: AppText.labelSm.copyWith(
                      fontSize: 9,
                      color: selected
                          ? AppColors.onPrimary
                          : (option.accent ?? AppColors.onSurfaceVariant),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key, this.color = AppColors.divider});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: color);
  }
}
