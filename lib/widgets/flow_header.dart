import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FlowHeader extends StatelessWidget {
  const FlowHeader({
    super.key,
    required this.selectedDashboard,
    required this.onDashboardChanged,
    required this.month,
    required this.months,
    required this.onMonthChanged,
    this.onNotifications,
    this.onProfile,
  });

  final int selectedDashboard;
  final ValueChanged<int> onDashboardChanged;
  final String month;
  final List<String> months;
  final ValueChanged<String> onMonthChanged;
  final VoidCallback? onNotifications;
  final VoidCallback? onProfile;

  static const _tabs = ['General', 'Bills', 'Income'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xF20F131C),
        border: Border(bottom: BorderSide(color: AppColors.borderSoft)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
        child: Column(
          children: [
            SizedBox(
              height: 44,
              child: Row(
                children: [
                  const _LogoMark(),
                  const SizedBox(width: 10),
                  PopupMenuButton<String>(
                    tooltip: 'Change month',
                    color: AppColors.surfaceHigh,
                    position: PopupMenuPosition.under,
                    offset: const Offset(0, 6),
                    initialValue: month,
                    onSelected: onMonthChanged,
                    itemBuilder: (context) => [
                      for (final item in months)
                        PopupMenuItem(
                          value: item,
                          child: Row(
                            children: [
                              Icon(
                                item == month
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                size: 16,
                                color: item == month
                                    ? AppColors.primary
                                    : AppColors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                item,
                                style: AppText.bodyMd.copyWith(
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                    child: Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHigh,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.borderSoft),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            month,
                            style: AppText.labelMd.copyWith(fontSize: 11),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.expand_more,
                            size: 15,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  _IconButton(
                    icon: Icons.notifications_none_rounded,
                    label: 'Notifications',
                    onTap: onNotifications,
                    showDot: true,
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: onProfile,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.tertiaryContainer,
                            AppColors.primary,
                          ],
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: const ColoredBox(
                        color: AppColors.surfaceHigh,
                        child: Icon(
                          Icons.person_outline,
                          size: 19,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 40,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  for (var i = 0; i < _tabs.length; i++)
                    Expanded(
                      child: _Segment(
                        label: _tabs[i],
                        selected: selectedDashboard == i,
                        onTap: () => onDashboardChanged(i),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.surfaceHigh : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x4D000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppText.labelMd.copyWith(
            fontSize: 11,
            color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surfaceHigh, AppColors.surfaceLowest],
        ),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'FF',
        style: AppText.headlineSm.copyWith(
          fontFamily: AppText.manrope,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.showDot = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 23, color: AppColors.onSurfaceVariant),
              if (showDot)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.background,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
