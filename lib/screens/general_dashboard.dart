import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/cards.dart';
import '../widgets/common.dart';

class GeneralDashboard extends StatefulWidget {
  const GeneralDashboard({
    super.key,
    required this.transactions,
    required this.onAddBill,
    required this.onLogIncome,
    required this.onViewAllBills,
    required this.onMarkBillPaid,
  });

  final List<TransactionEntry> transactions;
  final VoidCallback onAddBill;
  final VoidCallback onLogIncome;
  final VoidCallback onViewAllBills;
  final ValueChanged<BillItem> onMarkBillPaid;

  @override
  State<GeneralDashboard> createState() => _GeneralDashboardState();
}

class _GeneralDashboardState extends State<GeneralDashboard> {
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _heroCard(),
          const SizedBox(height: 16),
          _quickActions(),
          const SizedBox(height: 20),
          _upcomingBills(),
          const SizedBox(height: 22),
          _activity(),
          const SizedBox(height: 20),
          _emergencyFund(),
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
                        '\$8,420.50',
                        style: AppText.displayLgMobile.copyWith(
                          fontSize: 33,
                          letterSpacing: -1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '+14.2%',
                      style: AppText.labelSm.copyWith(
                        fontSize: 9.5,
                        color: AppColors.primary,
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
                  amount: '+\$6,850.00',
                  caption: '2 inflows received',
                  icon: Icons.north_east,
                  accent: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MetricTile(
                  label: 'Bills & Outflow',
                  amount: '-\$3,429.50',
                  caption: '5 bills scheduled',
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
                      text: '\$3,420.50',
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
          const AppProgressBar(value: 0.50),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  '50% of monthly cap used',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySm.copyWith(fontSize: 10.5),
                ),
              ),
              const SizedBox(width: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Budget: \$6,841.00',
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
            onTap: () => _comingSoon('Receipt scanner'),
          ),
          const SizedBox(width: 8),
          PrimaryActionPill(
            label: 'Split Expense',
            icon: Icons.call_split,
            iconColor: AppColors.onSurfaceVariant,
            onTap: () => _comingSoon('Split expense'),
          ),
        ],
      ),
    );
  }

  Widget _upcomingBills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Upcoming Bills Alert',
          icon: Icons.notification_important_outlined,
          iconColor: AppColors.secondary,
          trailing: 'View All (5)',
          onTrailingTap: widget.onViewAllBills,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 176,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: MockData.upcomingBills.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final bill = MockData.upcomingBills[index];
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
          onTrailingTap: () => _comingSoon('Detailed activity'),
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

  Widget _emergencyFund() {
    return AppCard(
      padding: const EdgeInsets.all(14),
      color: AppColors.surface,
      child: Row(
        children: [
          const IconBadge(
            icon: Icons.savings_outlined,
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
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Emergency Fund',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.headlineSm.copyWith(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '82%',
                        style: AppText.labelSm.copyWith(
                          fontSize: 8.5,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  '\$8,200 of \$10,000 goal achieved',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySm.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppPill(
            label: 'Boost',
            background: AppColors.surfaceHighest,
            foreground: AppColors.onSurface,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            textStyle: AppText.labelSm.copyWith(fontSize: 9),
            onTap: () => _comingSoon('Savings boost'),
          ),
        ],
      ),
    );
  }

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is ready for your next contribution.')),
    );
  }
}
