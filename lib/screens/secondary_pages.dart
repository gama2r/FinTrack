import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/cards.dart';
import '../widgets/common.dart';
import 'edit_profile_page.dart';
import 'vault_pages.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key, required this.transactions});

  final List<TransactionEntry> transactions;

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  int _filter = 0;

  double get _inflow => widget.transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get _outflow => widget.transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount.abs());

  int get _inflowCount => widget.transactions.where((t) => t.isIncome).length;

  int get _outflowCount => widget.transactions.where((t) => !t.isIncome).length;

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
                    value: formatCurrency(_inflow, signed: true),
                    color: AppColors.primary,
                    caption: _inflowCount == 1
                        ? '1 entry'
                        : '$_inflowCount entries',
                    captionIcon: Icons.north_east,
                  ),
                ),
                Container(width: 1, height: 40, color: AppColors.divider),
                Expanded(
                  child: _Summary(
                    label: 'OUTFLOW',
                    value: '-${formatCurrency(_outflow)}',
                    color: AppColors.secondary,
                    caption: _outflowCount == 1
                        ? '1 entry'
                        : '$_outflowCount entries',
                    captionIcon: Icons.south_east,
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
          if (_filtered.isEmpty)
            AppCard(
              color: AppColors.surfaceLow,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
              child: Column(
                children: [
                  const IconBadge(
                    icon: Icons.receipt_long_outlined,
                    color: AppColors.onSurfaceVariant,
                    background: AppColors.surfaceHigh,
                    size: 44,
                    circle: true,
                    iconSize: 22,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No transactions yet',
                    style: AppText.headlineSm.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.transactions.isEmpty
                        ? 'Add a bill or log income to start your ledger.'
                        : 'Nothing matches this filter.',
                    textAlign: TextAlign.center,
                    style: AppText.bodySm.copyWith(fontSize: 11),
                  ),
                ],
              ),
            )
          else
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
                  icon: Icons.lock_outline,
                  color: AppColors.tertiary,
                  circle: true,
                  size: 40,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    'Entries are stored locally on this device. Nothing is '
                    'uploaded.',
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
    this.caption,
    this.captionIcon,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final Color color;
  final String? caption;
  final IconData? captionIcon;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
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
        if (caption != null) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: alignEnd
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (captionIcon != null) ...[
                Icon(captionIcon, size: 11, color: color),
                const SizedBox(width: 3),
              ],
              Flexible(
                child: Text(
                  caption!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.labelSm.copyWith(fontSize: 8.5, color: color),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({
    super.key,
    required this.transactions,
    required this.bills,
  });

  final List<TransactionEntry> transactions;
  final List<BillItem> bills;

  double get _income => transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get _outflow => transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount.abs());

  double get _net => _income - _outflow;

  double get _savingsRate => _income <= 0 ? 0 : _net / _income * 100;

  List<CategorySlice> get _categories {
    const palette = [
      AppColors.primary,
      AppColors.tertiaryContainer,
      AppColors.tertiary,
      AppColors.secondary,
      AppColors.primaryFixed,
    ];
    final totals = <String, double>{};
    for (final bill in bills) {
      totals.update(
        bill.category,
        (value) => value + bill.amount,
        ifAbsent: () => bill.amount,
      );
    }
    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final max = entries.isEmpty ? 0.0 : entries.first.value;
    return [
      for (var i = 0; i < entries.length; i++)
        CategorySlice(
          label: entries[i].key,
          subtitle:
              '${bills.where((b) => b.category == entries[i].key).length} bills',
          amount: entries[i].value,
          color: palette[i % palette.length],
          flex: max <= 0 ? 1 : (entries[i].value / max * 100).round(),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categories;
    final hasData = transactions.isNotEmpty || bills.isNotEmpty;
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
                child: _AnalyticsMetric(
                  label: 'Net cash flow',
                  amount: formatCurrency(_net, signed: true),
                  caption: 'All logged entries',
                  icon: Icons.north_east,
                  accent: AppColors.primary,
                  amountColor: _net < 0
                      ? AppColors.secondary
                      : AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _AnalyticsMetric(
                  label: 'Savings rate',
                  amount: '${_savingsRate.toStringAsFixed(1)}%',
                  caption: _income <= 0
                      ? 'Log income to calculate'
                      : 'Of total income',
                  icon: Icons.savings_outlined,
                  accent: AppColors.tertiary,
                  amountColor: AppColors.onSurface,
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
                  trailing: hasData ? 'This period' : null,
                ),
                const SizedBox(height: 4),
                Text(
                  'Monthly earnings history.',
                  style: AppText.bodySm.copyWith(fontSize: 10.5),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLowest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.show_chart,
                        size: 26,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hasData ? 'Not enough history yet' : 'No data yet',
                        style: AppText.bodyMd.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'A monthly trend appears once you have entries across '
                        'multiple months.',
                        textAlign: TextAlign.center,
                        style: AppText.bodySm.copyWith(fontSize: 10.5),
                      ),
                    ],
                  ),
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
                  trailing: categories.isEmpty
                      ? null
                      : '${categories.length} categories',
                  trailingColor: AppColors.onSurfaceVariant,
                ),
                const SizedBox(height: 12),
                if (categories.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Category totals appear after you add bills.',
                      textAlign: TextAlign.center,
                      style: AppText.bodySm.copyWith(fontSize: 11),
                    ),
                  )
                else ...[
                  Row(
                    children: [
                      Text(
                        'Total committed spend',
                        style: AppText.bodySm.copyWith(fontSize: 10.5),
                      ),
                      const Spacer(),
                      Text(
                        formatCurrency(
                          categories.fold<double>(
                            0,
                            (sum, category) => sum + category.amount,
                          ),
                        ),
                        style: AppText.labelMd.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AllocationBar(
                    height: 12,
                    segments: [
                      for (final category in categories)
                        SegmentSpec(category.flex, category.color),
                    ],
                    remainingFlex: 0,
                  ),
                  const SizedBox(height: 12),
                  _AllocationLegend(categories: categories),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsMetric extends StatelessWidget {
  const _AnalyticsMetric({
    required this.label,
    required this.amount,
    required this.caption,
    required this.icon,
    required this.accent,
    this.amountColor,
  });

  final String label;
  final String amount;
  final String caption;
  final IconData icon;
  final Color accent;
  final Color? amountColor;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.labelMd.copyWith(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: accent),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: AppText.headlineMd.copyWith(
                fontSize: 22,
                color: amountColor ?? accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySm.copyWith(fontSize: 10.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationLegend extends StatelessWidget {
  const _AllocationLegend({required this.categories});

  final List<CategorySlice> categories;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 48,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.surfaceLow,
            borderRadius: BorderRadius.circular(10),
          ),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySm.copyWith(fontSize: 10.5),
                    ),
                    Text(
                      formatCurrency(category.amount),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.labelMd.copyWith(fontSize: 10.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.tertiaryContainer,
                            AppColors.primary,
                          ],
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: const Icon(
                        Icons.person_outline,
                        color: AppColors.onPrimary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your profile',
                        style: AppText.headlineSm.copyWith(fontSize: 16),
                      ),
                      Text(
                        'Tap Edit to add your details',
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
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const EditProfilePage(),
                    ),
                  ),
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
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const UnlockVaultPage(),
                  ),
                ),
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
                  Text(caption, style: AppText.bodySm.copyWith(fontSize: 10)),
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
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool last;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
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
        ),
      ),
    );
  }
}
