import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';

enum _NotifCategory { bills, income, security }

class _NotifData {
  const _NotifData({
    required this.category,
    required this.title,
    required this.time,
    required this.icon,
    required this.accent,
    required this.body,
    this.unread = false,
    this.footer,
  });

  final _NotifCategory category;
  final String title;
  final String time;
  final IconData icon;
  final Color accent;
  final Widget body;
  final bool unread;
  final Widget? footer;
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _filter = 0;
  bool _allRead = false;

  static const _filters = [
    'All (8)',
    'Bills & Due (3)',
    'Income (2)',
    'Security & System (3)',
  ];

  bool _matches(_NotifCategory category) {
    return switch (_filter) {
      1 => category == _NotifCategory.bills,
      2 => category == _NotifCategory.income,
      3 => category == _NotifCategory.security,
      _ => true,
    };
  }

  void _markAllRead() {
    setState(() => _allRead = true);
  }

  @override
  Widget build(BuildContext context) {
    final today = _todayCards(context).where((c) => _matches(c.category));
    final earlier = _earlierCards(context).where((c) => _matches(c.category));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(
              allRead: _allRead,
              onMarkAllRead: _markAllRead,
              onAvatar: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SummaryCard(allRead: _allRead),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var i = 0; i < _filters.length; i++) ...[
                            if (i > 0) const SizedBox(width: 6),
                            AppPill(
                              label: _filters[i],
                              background: _filter == i
                                  ? AppColors.primary
                                  : AppColors.surfaceHigh,
                              foreground: _filter == i
                                  ? AppColors.onPrimary
                                  : AppColors.onSurfaceVariant,
                              textStyle: AppText.labelMd.copyWith(fontSize: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 9,
                              ),
                              onTap: () => setState(() => _filter = i),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (today.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Text('Today', style: AppText.headlineSm),
                          const Spacer(),
                          if (!_allRead)
                            Text(
                              '3 unread',
                              style: AppText.labelSm.copyWith(
                                fontSize: 9,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      for (final card in today) ...[
                        _NotificationCard(data: card, allRead: _allRead),
                        const SizedBox(height: 10),
                      ],
                    ],
                    if (earlier.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('Yesterday & Earlier', style: AppText.headlineSm),
                      const SizedBox(height: 10),
                      for (final card in earlier) ...[
                        _NotificationCard(data: card, allRead: _allRead),
                        const SizedBox(height: 10),
                      ],
                    ],
                    const SizedBox(height: 6),
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

  List<_NotifData> _todayCards(BuildContext context) {
    return [
      _NotifData(
        category: _NotifCategory.bills,
        title: 'Upcoming Due Date',
        time: '10m ago',
        icon: Icons.calendar_month_outlined,
        accent: AppColors.secondary,
        unread: true,
        body: _richBody(
          const TextSpan(text: 'Luxury Apartment Rent: '),
          const TextSpan(
            text: '\$1,650.00',
            style: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(
            text: ' is due in 3 days (Oct 27). Auto-pay is currently OFF.',
          ),
        ),
        footer: Row(
          children: [
            AppPill(
              label: 'Pay Now',
              background: AppColors.primary,
              foreground: AppColors.onPrimary,
              textStyle: AppText.labelMd.copyWith(fontSize: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              trailing: const Icon(
                Icons.arrow_forward,
                size: 14,
                color: AppColors.onPrimary,
              ),
              onTap: () => _toast(context, 'Rent payment scheduled for today.'),
            ),
            const SizedBox(width: 8),
            AppPill(
              label: 'Remind Later',
              background: AppColors.surfaceHigh,
              foreground: AppColors.onSurfaceVariant,
              textStyle: AppText.labelMd.copyWith(fontSize: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              onTap: () => _toast(context, 'We will remind you tomorrow.'),
            ),
          ],
        ),
      ),
      _NotifData(
        category: _NotifCategory.income,
        title: 'Deposit Cleared: TechCorp',
        time: '2h ago',
        icon: Icons.account_balance_outlined,
        accent: AppColors.primary,
        unread: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _richBody(
              const TextSpan(
                text: '+\$3,425.00',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(
                text: ' has settled into your Vault Operating account.',
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Cleared',
                    style: AppText.labelSm.copyWith(
                      fontSize: 8.5,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Ref: #TX-90241',
                  style: AppText.labelSm.copyWith(
                    fontSize: 8.5,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      _NotifData(
        category: _NotifCategory.security,
        title: 'Safe-to-Spend Alert',
        time: '5h ago',
        icon: Icons.pie_chart_outline,
        accent: AppColors.tertiary,
        unread: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _richBody(
              const TextSpan(
                text: 'You have utilized 50% of your October cap. ',
              ),
              const TextSpan(
                text: '\$3,420.50',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: ' remaining.'),
            ),
            const SizedBox(height: 8),
            const AppProgressBar(value: 0.5, height: 6, glow: false),
          ],
        ),
      ),
    ];
  }

  List<_NotifData> _earlierCards(BuildContext context) {
    return [
      const _NotifData(
        category: _NotifCategory.bills,
        title: 'Auto-Pay: Clean Energy',
        time: 'Yesterday, 8:00 AM',
        icon: Icons.bolt_outlined,
        accent: AppColors.onSurfaceVariant,
        body: _PlainBody(
          '\$84.20 automatically paid to Pacific Grid Co. Receipt archived.',
        ),
      ),
      _NotifData(
        category: _NotifCategory.income,
        title: 'New Inflow: Freelance UI',
        time: 'Oct 22',
        icon: Icons.payments_outlined,
        accent: AppColors.primary,
        body: _richBody(
          const TextSpan(
            text: '+\$950.00',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' received via Wire Transfer from Apex Studio.'),
        ),
      ),
      const _NotifData(
        category: _NotifCategory.security,
        title: 'Biometric Login Enabled',
        time: 'Oct 20',
        icon: Icons.fingerprint,
        accent: AppColors.onSurfaceVariant,
        body: _PlainBody(
          'Face ID verified on your primary mobile device (iPhone 15 Pro).',
        ),
      ),
    ];
  }

  Widget _richBody(TextSpan first, [TextSpan? second, TextSpan? third]) {
    return Text.rich(
      TextSpan(children: [first, ?second, ?third]),
      style: AppText.bodyMd.copyWith(
        fontSize: 12.5,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _PlainBody extends StatelessWidget {
  const _PlainBody(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.bodyMd.copyWith(
        fontSize: 12.5,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.allRead,
    required this.onMarkAllRead,
    required this.onAvatar,
  });

  final bool allRead;
  final VoidCallback onMarkAllRead;
  final VoidCallback onAvatar;

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
          IconButton(
            tooltip: 'Mark all as read',
            onPressed: allRead ? null : onMarkAllRead,
            icon: Icon(
              Icons.done_all,
              size: 20,
              color: allRead ? AppColors.muted : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 2),
          InkWell(
            onTap: onAvatar,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/profile.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.person,
                  size: 18,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.allRead});

  final bool allRead;

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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!allRead) ...[
                  const GlowDot(size: 6),
                  const SizedBox(width: 6),
                ],
                Text(
                  allRead ? '0 New alerts' : '3 New alerts',
                  style: AppText.labelSm.copyWith(
                    fontSize: 8.5,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.data, required this.allRead});

  final _NotifData data;
  final bool allRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBadge(
                icon: data.icon,
                color: data.accent,
                background: data.accent.withValues(alpha: 0.16),
                size: 40,
                radius: 12,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            data.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.headlineSm.copyWith(fontSize: 16),
                          ),
                        ),
                        if (data.unread && !allRead) ...[
                          const SizedBox(width: 6),
                          GlowDot(size: 7, color: data.accent),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    data.body,
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                data.time,
                style: AppText.labelSm.copyWith(
                  fontSize: 8.5,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (data.footer != null) ...[
            const SizedBox(height: 10),
            data.footer!,
          ],
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
                  'Customize push triggers, daily digests & alerts',
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
