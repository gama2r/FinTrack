import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _SummaryCard(),
                    const SizedBox(height: 14),
                    const _EmptyInboxCard(),
                    const SizedBox(height: 16),
                    _PreferencesCard(
                      onManage: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyInboxCard extends StatelessWidget {
  const _EmptyInboxCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        children: [
          const IconBadge(
            icon: Icons.notifications_none,
            color: AppColors.onSurfaceVariant,
            background: AppColors.surfaceHigh,
            size: 46,
            circle: true,
            iconSize: 23,
          ),
          const SizedBox(height: 10),
          Text(
            "You're all caught up",
            style: AppText.headlineSm.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 3),
          Text(
            'Bills and income you log will create alerts here.',
            textAlign: TextAlign.center,
            style: AppText.bodySm.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              size: 21,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(width: 2),
          Text('Notifications', style: AppText.headlineSm),
          const Spacer(),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: const Icon(
                Icons.person_outline,
                size: 18,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Stay updated on cash flow, due dates & alerts.',
              style: AppText.bodyMd.copyWith(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '0 New alerts',
              style: AppText.labelSm.copyWith(
                fontSize: 8.5,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferencesCard extends StatelessWidget {
  const _PreferencesCard({required this.onManage});

  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(
        children: [
          const IconBadge(
            icon: Icons.tune,
            color: AppColors.primary,
            background: AppColors.surfaceHighest,
            size: 40,
            radius: 12,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification Preferences',
                  style: AppText.headlineSm.copyWith(fontSize: 15),
                ),
                Text(
                  'Manage alerts from Settings',
                  style: AppText.bodySm.copyWith(fontSize: 10.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppPill(
            label: 'Manage',
            background: AppColors.surfaceHighest,
            foreground: AppColors.onSurface,
            textStyle: AppText.labelMd.copyWith(fontSize: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            trailing: const Icon(
              Icons.chevron_right,
              size: 15,
              color: AppColors.onSurface,
            ),
            onTap: onManage,
          ),
        ],
      ),
    );
  }
}
