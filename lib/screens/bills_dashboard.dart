import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/cards.dart';
import '../widgets/charts.dart';
import '../widgets/common.dart';

class BillsDashboard extends StatefulWidget {
  const BillsDashboard({
    super.key,
    required this.bills,
    this.onPayBill,
    this.onToggleAutoPay,
  });

  final List<BillItem> bills;
  final ValueChanged<BillItem>? onPayBill;
  final ValueChanged<BillItem>? onToggleAutoPay;

  @override
  State<BillsDashboard> createState() => _BillsDashboardState();
}

class _BillsDashboardState extends State<BillsDashboard> {
  int _filter = 0;
  bool _paying = false;

  BillItem get _rent =>
      widget.bills.firstWhere((bill) => bill.id == 'luxury-rent');

  BillItem _byId(String id) =>
      widget.bills.firstWhere((bill) => bill.id == id);

  double get _paidTotal => 1682 + (_rent.paid ? 1650 : 0);
  double get _pendingTotal => 1747.50 - (_rent.paid ? 1650 : 0);
  double get _progress => _paidTotal / 3429.50;
  int get _settled => _rent.paid ? 6 : 5;

  List<BillItem> get _dueBills {
    final base = [
      _rent,
      _byId('clean-energy'),
      _byId('cloud'),
      ...widget.bills.where(
        (bill) => bill.id.startsWith('manual-') && !bill.paid,
      ),
    ];
    switch (_filter) {
      case 1:
        return base.where((b) => b.id != 'cloud').toList();
      case 2:
        return base.where((b) => b.category == 'Subscriptions').toList();
      case 3:
        return base.where((b) => b.category == 'Utilities').toList();
      default:
        return base;
    }
  }

  Future<void> _payRent() async {
    if (_paying || _rent.paid) return;
    setState(() => _paying = true);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    final paid = _rent.copyWith(paid: true);
    setState(() => _paying = false);
    widget.onPayBill?.call(paid);
  }

  void _toggleAutoPay(BillItem bill) {
    widget.onToggleAutoPay?.call(bill.copyWith(autoPay: !bill.autoPay));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _statusRow(),
          const SizedBox(height: 10),
          _heroCard(),
          const SizedBox(height: 10),
          _reminderBanner(),
          const SizedBox(height: 12),
          FilterChipRow(
            options: const [
              FilterOption('All', count: 9),
              FilterOption('Due This Week', count: 2, accent: AppColors.secondary),
              FilterOption('Subscriptions', count: 4),
              FilterOption('Utilities', count: 3),
            ],
            selectedIndex: _filter,
            onSelected: (index) => setState(() => _filter = index),
          ),
          const SizedBox(height: 14),
          _allocationCard(),
          const SizedBox(height: 18),
          _dueSoonSection(),
          const SizedBox(height: 18),
          _recentlyPaidSection(),
          const SizedBox(height: 14),
          _subscriptionAudit(),
        ],
      ),
    );
  }

  Widget _statusRow() {
    return Row(
      children: [
        const GlowDot(),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'RECURRING & OBLIGATIONS',
            style: AppText.labelMd.copyWith(
              fontSize: 9.5,
              letterSpacing: 1,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 5),
              Text(
                'Cycle: Oct 01 - 31',
                style: AppText.labelSm.copyWith(fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heroCard() {
    return AppCard(
      color: AppColors.surfaceHigh,
      glowColor: AppColors.primary,
      padding: const EdgeInsets.all(16),
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
                      'Total Bills for October',
                      style: AppText.bodySm.copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: 1),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '\$',
                            style: AppText.labelMd.copyWith(
                              fontSize: 13,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '3,429.50',
                            style: AppText.displayLgMobile.copyWith(
                              fontSize: 33,
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              CircularProgressRing(
                value: _progress,
                label: '${(_progress * 100).round()}%',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Budget clearance status',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.labelSm.copyWith(fontSize: 9),
                ),
              ),
              const SizedBox(width: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$_settled of 9 settled',
                  style: AppText.labelSm.copyWith(
                    fontSize: 9,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          AppProgressBar(value: _progress),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: BillStatTile(
                  label: 'Paid',
                  amount: formatCurrency(_paidTotal),
                  caption: '$_settled bills completed',
                  icon: Icons.check_circle,
                  accent: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: BillStatTile(
                  label: 'Pending',
                  amount: formatCurrency(_pendingTotal),
                  caption: '${9 - _settled} bills awaiting',
                  icon: Icons.pending_actions,
                  accent: AppColors.secondary,
                  captionColor: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reminderBanner() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryContainer.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
            spreadRadius: -6,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.onSecondaryContainer.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notification_important_outlined,
              size: 19,
              color: AppColors.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _rent.paid
                      ? 'Luxury Apartment settled'
                      : 'Next Bill: Luxury Apartment',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.labelMd.copyWith(
                    fontSize: 10.5,
                    color: AppColors.onSecondaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _rent.paid
                      ? 'Paid today • \$1,650.00 cleared'
                      : 'Due in 3 days • \$1,650.00',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySm.copyWith(
                    fontSize: 10.5,
                    color: AppColors.onSecondaryContainer.withValues(
                      alpha: 0.9,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppPill(
            label: 'View',
            background: AppColors.surfaceLowest,
            foreground: AppColors.secondary,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            textStyle: AppText.labelSm.copyWith(fontSize: 9),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${_rent.name} details opened.')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _allocationCard() {
    return AppCard(
      color: AppColors.surface,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.donut_small_outlined,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Category Allocation',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.headlineSm.copyWith(fontSize: 17),
                ),
              ),
              const SizedBox(width: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '4 categories',
                  style: AppText.labelSm.copyWith(
                    fontSize: 9,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
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
          Row(
            children: [
              Expanded(child: CategoryTile(category: MockData.categories[0])),
              const SizedBox(width: 8),
              Expanded(child: CategoryTile(category: MockData.categories[1])),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: CategoryTile(category: MockData.categories[2])),
              const SizedBox(width: 8),
              Expanded(child: CategoryTile(category: MockData.categories[3])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dueSoonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Due Soon & Urgent',
          icon: Icons.crisis_alert,
          iconColor: AppColors.secondary,
          trailing:
              '${_dueBills.where((bill) => !bill.paid).length} '
              'Action Required',
          trailingColor: AppColors.secondary,
        ),
        const SizedBox(height: 10),
        for (final bill in _dueBills) ...[
          if (bill.urgent)
            _UrgentBillCard(
              bill: bill,
              paying: _paying,
              onPay: _payRent,
              onAutoPay: () => _toggleAutoPay(bill),
            )
          else
            _CompactBillCard(
              bill: bill,
              onAutoPay: () => _toggleAutoPay(bill),
            ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _recentlyPaidSection() {
    final paid = <BillItem>[
      if (_rent.paid) _rent,
      ...widget.bills.where(
        (bill) => bill.paid && bill.id != 'luxury-rent',
      ),
    ].take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Recently Paid',
          icon: Icons.task_alt,
          iconColor: AppColors.primary,
          trailing: 'Past 30 Days',
          trailingColor: AppColors.onSurfaceVariant,
        ),
        const SizedBox(height: 10),
        AppCard(
          color: AppColors.surface,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              for (var i = 0; i < paid.length; i++) ...[
                _PaidRow(bill: paid[i]),
                if (i != paid.length - 1)
                  const Padding(
                    padding: EdgeInsets.only(left: 52, right: 10),
                    child: DashedDivider(),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _subscriptionAudit() {
    return AppCard(
      color: AppColors.surfaceLow,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const IconBadge(
            icon: Icons.auto_graph,
            color: AppColors.tertiary,
            background: Color(0x339699FF),
            size: 40,
            circle: true,
            iconSize: 20,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subscription Audit',
                  style: AppText.bodyMd.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'You have 4 active digital subscriptions.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySm.copyWith(fontSize: 10.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppPill(
            label: 'Optimize',
            background: AppColors.surfaceHighest,
            foreground: AppColors.onSurface,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            textStyle: AppText.labelSm.copyWith(fontSize: 9),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Subscription audit opened.')),
            ),
          ),
        ],
      ),
    );
  }
}

class _UrgentBillCard extends StatelessWidget {
  const _UrgentBillCard({
    required this.bill,
    required this.paying,
    required this.onPay,
    required this.onAutoPay,
  });

  final BillItem bill;
  final bool paying;
  final VoidCallback onPay;
  final VoidCallback onAutoPay;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.surface,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBadge(
                icon: bill.icon,
                color: bill.paid ? AppColors.primary : AppColors.primary,
                size: 44,
                radius: 10,
                background: AppColors.surfaceHighest,
                iconSize: 23,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodyLg.copyWith(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 5,
                      runSpacing: 4,
                      children: [
                        _MiniBadge(
                          text: bill.paid
                              ? 'Paid today'
                              : bill.dueLabel.replaceAll(' in', ' in'),
                          color: bill.paid
                              ? AppColors.primary
                              : AppColors.secondary,
                        ),
                        _MiniBadge(
                          text: bill.autoPay ? 'Auto-Pay ON' : 'Auto-Pay OFF',
                          color: bill.autoPay
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCurrency(bill.amount),
                    style: AppText.headlineSm.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Recurring',
                    style: AppText.bodySm.copyWith(fontSize: 10.5),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              AppPill(
                label: bill.autoPay ? 'Auto-Pay ON' : 'Set Auto-Pay',
                icon: Icons.tune,
                background: AppColors.surfaceHighest,
                foreground: bill.autoPay
                    ? AppColors.primary
                    : AppColors.onSurface,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                textStyle: AppText.labelSm.copyWith(fontSize: 8.5),
                onTap: onAutoPay,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: bill.paid || paying ? null : onPay,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bill.paid
                            ? AppColors.surfaceHighest
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: bill.paid
                            ? null
                            : [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.25,
                                  ),
                                  blurRadius: 16,
                                  spreadRadius: -2,
                                ),
                              ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            bill.paid
                                ? Icons.check_circle
                                : paying
                                    ? Icons.sync
                                    : Icons.bolt,
                            size: 17,
                            color: bill.paid
                                ? AppColors.primary
                                : AppColors.onPrimary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            bill.paid
                                ? 'Paid'
                                : paying
                                    ? 'Processing...'
                                    : 'Pay Now',
                            style: AppText.labelMd.copyWith(
                              fontSize: 10.5,
                              color: bill.paid
                                  ? AppColors.primary
                                  : AppColors.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactBillCard extends StatelessWidget {
  const _CompactBillCard({required this.bill, required this.onAutoPay});

  final BillItem bill;
  final VoidCallback onAutoPay;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.surface,
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          IconBadge(
            icon: bill.icon,
            color: bill.accent,
            size: 44,
            radius: 10,
            background: AppColors.surfaceHighest,
            iconSize: 22,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bill.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyMd.copyWith(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Wrap(
                  spacing: 5,
                  runSpacing: 3,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      bill.dueLabel,
                      style: AppText.bodySm.copyWith(fontSize: 10.5),
                    ),
                    InkWell(
                      onTap: onAutoPay,
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: bill.autoPay
                              ? AppColors.primary.withValues(alpha: 0.10)
                              : AppColors.surfaceHighest,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (bill.autoPay)
                              const Icon(
                                Icons.check,
                                size: 10,
                                color: AppColors.primary,
                              ),
                            Text(
                              bill.autoPay ? 'Auto-Pay ON' : 'Auto-Pay OFF',
                              style: AppText.labelSm.copyWith(
                                fontSize: 7.5,
                                color: bill.autoPay
                                    ? AppColors.primary
                                    : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatCurrency(bill.amount),
                style: AppText.headlineSm.copyWith(fontSize: 16),
              ),
              InkWell(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${bill.name} details opened.')),
                ),
                child: Text(
                  'Details',
                  style: AppText.labelSm.copyWith(
                    fontSize: 9,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: AppText.labelSm.copyWith(
          fontSize: 8,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PaidRow extends StatelessWidget {
  const _PaidRow({required this.bill});

  final BillItem bill;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const IconBadge(
            icon: Icons.check,
            color: AppColors.primary,
            size: 38,
            circle: true,
            iconSize: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bill.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyMd.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  bill.id == 'luxury-rent'
                      ? 'Paid just now • Bank Transfer'
                      : bill.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySm.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatCurrency(bill.amount),
                style: AppText.headlineSm.copyWith(
                  fontSize: 14.5,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.onSurfaceVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
              Text(
                'Cleared',
                style: AppText.labelSm.copyWith(
                  fontSize: 8.5,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
