import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/cards.dart';
import '../widgets/common.dart';

class GeneralDashboard extends StatefulWidget {
  const GeneralDashboard({
    super.key,
    required this.transactions,
    required this.bills,
    required this.onAddBill,
    required this.onLogIncome,
    required this.onViewAllBills,
    required this.onMarkBillPaid,
  });

  final List<TransactionEntry> transactions;
  final List<BillItem> bills;
  final VoidCallback onAddBill;
  final VoidCallback onLogIncome;
  final VoidCallback onViewAllBills;
  final ValueChanged<BillItem> onMarkBillPaid;

  @override
  State<GeneralDashboard> createState() => _GeneralDashboardState();
}

class _GeneralDashboardState extends State<GeneralDashboard> {
  int _filter = 0;

  double get _income => widget.transactions
      .where((entry) => entry.isIncome)
      .fold(0.0, (sum, entry) => sum + entry.amount);

  double get _outflow => widget.transactions
      .where((entry) => !entry.isIncome)
      .fold(0.0, (sum, entry) => sum + entry.amount.abs());

  double get _net => _income - _outflow;

  List<BillItem> get _openBills =>
      widget.bills.where((bill) => !bill.paid).toList();

  double get _scheduled =>
      _openBills.fold(0.0, (sum, bill) => sum + bill.amount);

  double get _safeToSpend => (_net - _scheduled).clamp(0, double.infinity);

  double get _capUsed => _income <= 0 ? 0 : (_outflow / _income).clamp(0, 1);

  int get _incomeCount => widget.transactions.where((t) => t.isIncome).length;

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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _heroCard(),
          const SizedBox(height: 16),
          _quickActions(),
          const SizedBox(height: 20),
          if (_openBills.isNotEmpty) ...[
            _upcomingBills(),
            const SizedBox(height: 22),
          ],
          _activity(),
          const SizedBox(height: 20),
          _localOnlyCard(),
        ],
      ),
    );
  }

  Widget _heroCard() {
    return AppCard(
      padding: const EdgeInsets.all(16),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surfaceHigh,
          AppColors.surface,
          AppColors.surfaceLow,
        ],
      ),
      glowColor: AppColors.primary,
      borderColor: AppColors.borderSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NET CASH FLOW',
                      style: AppText.labelMd.copyWith(
                        fontSize: 10,
                        letterSpacing: 1,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        formatCurrency(_net, signed: _net != 0),
                        style: AppText.displayLgMobile.copyWith(
                          fontSize: 33,
                          letterSpacing: -1.1,
                          color: _net < 0
                              ? AppColors.secondary
                              : AppColors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 13,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'On device',
                      style: AppText.labelSm.copyWith(
                        fontSize: 9.5,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MetricTile(
                  label: 'Income',
                  amount: formatCurrency(_income),
                  caption: _incomeCount == 1
                      ? '1 entry logged'
                      : '$_incomeCount entries logged',
                  icon: Icons.north_east,
                  accent: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MetricTile(
                  label: 'Bills & Outflow',
                  amount: formatCurrency(_outflow),
                  caption: _openBills.isEmpty
                      ? 'Nothing scheduled'
                      : '${_openBills.length} scheduled',
                  icon: Icons.south_east,
                  accent: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified_user_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Safe to Spend',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.labelMd.copyWith(
                          fontSize: 11,
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text.rich(
                    TextSpan(
                      text: formatCurrency(_safeToSpend),
                      style: AppText.labelMd.copyWith(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: ' remaining',
                          style: AppText.labelSm.copyWith(
                            fontSize: 9.5,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          AppProgressBar(value: _capUsed),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  _income <= 0
                      ? 'No income logged yet'
                      : '${(_capUsed * 100).round()}% of income spent',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySm.copyWith(fontSize: 10.5),
                ),
              ),
              const SizedBox(width: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Income: ${formatCurrency(_income)}',
                  style: AppText.labelSm.copyWith(
                    fontSize: 9,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          PrimaryActionPill(
            label: 'Add Bill',
            icon: Icons.add_circle_outline,
            primary: true,
            onTap: widget.onAddBill,
          ),
          const SizedBox(width: 8),
          PrimaryActionPill(
            label: 'Log Income',
            icon: Icons.payments_outlined,
            onTap: widget.onLogIncome,
          ),
          const SizedBox(width: 8),
          PrimaryActionPill(
            label: 'Scan Receipt',
            icon: Icons.document_scanner_outlined,
            iconColor: AppColors.tertiary,
            onTap: () => _notAvailable('Receipt scanner'),
          ),
          const SizedBox(width: 8),
          PrimaryActionPill(
            label: 'Split Expense',
            icon: Icons.call_split,
            iconColor: AppColors.onSurfaceVariant,
            onTap: () => _notAvailable('Split expense'),
          ),
        ],
      ),
    );
  }

  Widget _upcomingBills() {
    final bills = _openBills.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Upcoming Bills Alert',
          icon: Icons.notification_important_outlined,
          iconColor: AppColors.secondary,
          trailing: 'View All (${_openBills.length})',
          onTrailingTap: widget.onViewAllBills,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 176,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: bills.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final bill = bills[index];
              return UpcomingBillCard(
                bill: bill,
                onMarkPaid: () => widget.onMarkBillPaid(bill),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _activity() {
    final entries = _filtered;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Cash Flow Activity',
          trailing: 'Detailed',
          trailingColor: AppColors.onSurfaceVariant,
          trailingChevron: true,
          onTrailingTap: () => _notAvailable('Detailed activity'),
        ),
        const SizedBox(height: 10),
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
        if (entries.isEmpty)
          _emptyActivity()
        else
          AppCard(
            padding: const EdgeInsets.all(8),
            color: AppColors.surfaceLow,
            child: Column(
              children: [
                for (var i = 0; i < entries.length; i++) ...[
                  TransactionTile(entry: entries[i]),
                  if (i != entries.length - 1)
                    const Padding(
                      padding: EdgeInsets.only(left: 52, right: 12),
                      child: DashedDivider(),
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _emptyActivity() {
    return AppCard(
      color: AppColors.surfaceLow,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
            'No activity yet',
            style: AppText.headlineSm.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 3),
          Text(
            widget.transactions.isEmpty && _filter != 0
                ? 'Nothing matches this filter.'
                : 'Log your first bill or income to start the ledger.',
            textAlign: TextAlign.center,
            style: AppText.bodySm.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _localOnlyCard() {
    return AppCard(
      padding: const EdgeInsets.all(14),
      color: AppColors.surface,
      child: Row(
        children: [
          const IconBadge(
            icon: Icons.shield_outlined,
            color: AppColors.tertiary,
            background: Color(0x339699FF),
            size: 44,
            circle: true,
            iconSize: 23,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stored on this device',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.headlineSm.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 1),
                Text(
                  'Entries stay in local storage until you delete them.',
                  maxLines: 2,
                  style: AppText.bodySm.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _notAvailable(String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature is not available yet.')));
  }
}
