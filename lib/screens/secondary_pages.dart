import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/cards.dart';
import '../widgets/charts.dart';
import '../widgets/common.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key, required this.transactions});

  final List<TransactionEntry> transactions;

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  int _filter = 0;

  List<TransactionEntry> get _filtered {
    switch (_filter) {
      case 1:
        return widget.transactions.where((t) => t.isIncome).toList();
      case 2:
        return widget.transactions.where((t) => !t.isIncome).toList();
      default:
        return widget.transactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Transactions', style: AppText.headlineLg),
          const SizedBox(height: 2),
          Text(
            'Every inflow and outflow in one ledger.',
            style: AppText.bodySm.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 16),
          AppCard(
            color: AppColors.surface,
            glowColor: AppColors.primary,
            child: Row(
              children: [
                Expanded(
                  child: _Summary(
                    label: 'INFLOW',
                    value: '+\$6,850.00',
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.divider,
                ),
                Expanded(
                  child: _Summary(
                    label: 'OUTFLOW',
                    value: '-\$3,429.50',
                    color: AppColors.secondary,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilterChipRow(
            options: const [
              FilterOption('All'),
              FilterOption('Inflow'),
              FilterOption('Outflow'),
            ],
            selectedIndex: _filter,
            onSelected: (index) => setState(() => _filter = index),
          ),
          const SizedBox(height: 10),
          AppCard(
            color: AppColors.surfaceLow,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                for (var i = 0; i < _filtered.length; i++) ...[
                  TransactionTile(entry: _filtered[i]),
                  if (i != _filtered.length - 1)
                    const Padding(
                      padding: EdgeInsets.only(left: 52, right: 12),
                      child: DashedDivider(),
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            color: AppColors.surface,
            child: Row(
              children: [
                const IconBadge(
                  icon: Icons.info_outline,
                  color: AppColors.tertiary,
                  circle: true,
                  size: 40,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    'Transactions sync automatically with your linked accounts.',
                    style: AppText.bodySm.copyWith(fontSize: 11),
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

class _Summary extends StatelessWidget {
  const _Summary({
    required this.label,
    required this.value,
    required this.color,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.labelSm.copyWith(
            fontSize: 8.5,
            letterSpacing: 0.8,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 3),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: AppText.headlineMd.copyWith(color: color, fontSize: 19),
          ),
        ),
      ],
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Analytics', style: AppText.headlineLg),
          const SizedBox(height: 2),
          Text(
            'A six-month view of your money momentum.',
            style: AppText.bodySm.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MetricTile(
                  label: 'Net cash flow',
                  amount: '+\$3,420.50',
                  caption: 'October to date',
                  icon: Icons.north_east,
                  accent: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MetricTile(
                  label: 'Savings rate',
                  amount: '40.6%',
                  caption: 'Budget target 35%',
                  icon: Icons.savings_outlined,
                  accent: AppColors.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppCard(
            color: AppColors.surface,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionHeader(
                  title: 'Income Trajectory',
                  trailing: '+14.2% MoM',
                ),
                const SizedBox(height: 4),
                Text(
                  'Monthly earnings, May through October.',
                  style: AppText.bodySm.copyWith(fontSize: 10.5),
                ),
                const SizedBox(height: 10),
                IncomeBarChart(
                  months: MockData.chartMonths,
                  values: MockData.chartValues,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            color: AppColors.surface,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionHeader(
                  title: 'Category Allocation',
                  trailing: 'October',
                  trailingColor: AppColors.onSurfaceVariant,
                ),
                const SizedBox(height: 12),
                AllocationBar(
                  height: 12,
                  segments: [
                    for (final category in MockData.categories)
                      SegmentSpec(category.flex, category.color),
                  ],
                  remainingFlex: 294,
                ),
                const SizedBox(height: 12),
                for (final category in MockData.categories) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: category.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            category.label,
                            style: AppText.bodyMd.copyWith(fontSize: 12.5),
                          ),
                        ),
                        Text(
                          formatCurrency(category.amount),
                          style: AppText.labelMd.copyWith(fontSize: 10.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  bool _autoPay = false;
  bool _biometrics = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Settings', style: AppText.headlineLg),
          const SizedBox(height: 2),
          Text(
            'Preferences for your financial workspace.',
            style: AppText.bodySm.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 16),
          AppCard(
            color: AppColors.surface,
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.tertiaryContainer, AppColors.primary],
                    ),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/profile.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.person_outline,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alex Morgan',
                        style: AppText.headlineSm.copyWith(fontSize: 16),
                      ),
                      Text(
                        'alex.morgan@finmail.com',
                        style: AppText.bodySm.copyWith(fontSize: 10.5),
                      ),
                    ],
                  ),
                ),
                AppPill(
                  label: 'Edit',
                  background: AppColors.surfaceHigh,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  textStyle: AppText.labelSm.copyWith(fontSize: 9),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Preferences',
            children: [
              _SettingsSwitch(
                icon: Icons.notifications_none,
                label: 'Notifications',
                caption: 'Bill reminders and inflow alerts',
                value: _notifications,
                onChanged: (value) => setState(() => _notifications = value),
              ),
              _SettingsSwitch(
                icon: Icons.bolt_outlined,
                label: 'Auto-pay by default',
                caption: 'Enable auto-pay on new recurring bills',
                value: _autoPay,
                onChanged: (value) => setState(() => _autoPay = value),
              ),
              _SettingsSwitch(
                icon: Icons.fingerprint,
                label: 'Biometric lock',
                caption: 'Require Face ID when opening FinTrack',
                value: _biometrics,
                onChanged: (value) => setState(() => _biometrics = value),
                last: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Account',
            children: [
              _SettingsRow(
                icon: Icons.attach_money,
                label: 'Currency',
                value: 'USD (\$)',
              ),
              _SettingsRow(
                icon: Icons.calendar_month_outlined,
                label: 'Billing cycle',
                value: 'Monthly',
              ),
              _SettingsRow(
                icon: Icons.shield_outlined,
                label: 'Privacy & security',
                value: '',
                last: true,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'FinTrack 1.0.0 • Luminescent Wealth',
              style: AppText.labelSm.copyWith(
                fontSize: 8.5,
                color: AppColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 7),
          child: Text(
            title.toUpperCase(),
            style: AppText.labelSm.copyWith(
              fontSize: 8.5,
              letterSpacing: 0.9,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        AppCard(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({
    required this.icon,
    required this.label,
    required this.caption,
    required this.value,
    required this.onChanged,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final String caption;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppText.bodyMd.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    caption,
                    style: AppText.bodySm.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.onPrimary,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: AppColors.onSurfaceVariant,
            inactiveTrackColor: AppColors.surfaceHighest,
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.value,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppText.bodyMd.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: AppText.labelSm.copyWith(
              fontSize: 9,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right,
            size: 17,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
