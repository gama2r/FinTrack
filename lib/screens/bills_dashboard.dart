import 'package:flutter/material.dart';

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
    required this.month,
    this.onPayBill,
    this.onToggleAutoPay,
  });

  final List<BillItem> bills;
  final String month;
  final ValueChanged<BillItem>? onPayBill;
  final ValueChanged<BillItem>? onToggleAutoPay;

  @override
  State<BillsDashboard> createState() => _BillsDashboardState();
}

class _BillsDashboardState extends State<BillsDashboard> {
  int _filter = 0;
  String? _payingId;

  List<BillItem> get _openBills =>
      widget.bills.where((bill) => !bill.paid).toList();

  List<BillItem> get _paidBills =>
      widget.bills.where((bill) => bill.paid).toList();

  double get _total => widget.bills.fold(0.0, (sum, bill) => sum + bill.amount);

  double get _paidTotal =>
      _paidBills.fold(0.0, (sum, bill) => sum + bill.amount);

  double get _pendingTotal =>
      _openBills.fold(0.0, (sum, bill) => sum + bill.amount);

  double get _progress => _total <= 0 ? 0 : _paidTotal / _total;

  int get _settled => _paidBills.length;

  List<BillItem> get _dueBills {
    final base = _openBills;
    return switch (_filter) {
      1 => base.where((bill) => bill.category != 'Subscriptions').toList(),
      2 => base.where((bill) => bill.category == 'Subscriptions').toList(),
      3 => base.where((bill) => bill.category == 'Utilities').toList(),
      _ => base,
    };
  }

  Future<void> _payBill(BillItem bill) async {
    if (_payingId != null || bill.paid) return;
    setState(() => _payingId = bill.id);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _payingId = null);
    widget.onPayBill?.call(bill.copyWith(paid: true));
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
          if (widget.bills.isEmpty) ...[
            const SizedBox(height: 14),
            _emptyState(),
          ] else ...[
            if (_openBills.isNotEmpty) ...[
              const SizedBox(height: 10),
              _reminderBanner(_openBills.first),
            ],
            const SizedBox(height: 12),
            FilterChipRow(
              options: [
                FilterOption('All', count: _openBills.length),
                FilterOption(
                  'Due This Week',
                  count: _openBills
                      .where((bill) => bill.category != 'Subscriptions')
                      .length,
                  accent: AppColors.secondary,
                ),
                FilterOption(
                  'Subscriptions',
                  count: _openBills
                      .where((bill) => bill.category == 'Subscriptions')
                      .length,
                ),
                FilterOption(
                  'Utilities',
                  count: _openBills
                      .where((bill) => bill.category == 'Utilities')
                      .length,
                ),
              ],
              selectedIndex: _filter,
              onSelected: (index) => setState(() => _filter = index),
            ),
            const SizedBox(height: 14),
            _allocationCard(),
            const SizedBox(height: 18),
            if (_dueBills.isNotEmpty) ...[
              _dueSoonSection(),
              const SizedBox(height: 18),
            ],
            if (_paidBills.isNotEmpty) ...[
              _recentlyPaidSection(),
              const SizedBox(height: 14),
            ],
            _subscriptionAudit(),
          ],
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
              Text('This cycle', style: AppText.labelSm.copyWith(fontSize: 9)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return AppCard(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      child: Column(
        children: [
          const IconBadge(
            icon: Icons.receipt_long_outlined,
            color: AppColors.onSurfaceVariant,
            background: AppColors.surfaceHigh,
            size: 46,
            circle: true,
            iconSize: 23,
          ),
          const SizedBox(height: 10),
          Text(
            'No bills yet',
            style: AppText.headlineSm.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 3),
          Text(
            'Use the + button to log your first bill. It will show up here.',
            textAlign: TextAlign.center,
            style: AppText.bodySm.copyWith(fontSize: 11),
          ),
        ],
      ),
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
                      'Total Bills for ${widget.month.split(' ').first}',
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
                            formatCurrency(_total).substring(1),
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
                caption: _total <= 0 ? 'BILLS' : 'PAID',
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
                  _total <= 0
                      ? 'Nothing scheduled'
                      : '$_settled of ${widget.bills.length} settled',
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
                  caption: '${_openBills.length} bills awaiting',
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

  Widget _reminderBanner(BillItem bill) {
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
                  'Next Bill: ${bill.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.labelMd.copyWith(
                    fontSize: 10.5,
                    color: AppColors.onSecondaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${bill.dueLabel} • ${formatCurrency(bill.amount)}',
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
            label: 'Pay',
            background: AppColors.surfaceLowest,
            foreground: AppColors.secondary,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            textStyle: AppText.labelSm.copyWith(fontSize: 9),
            onTap: () => _payBill(bill),
          ),
        ],
      ),
    );
  }

  Widget _allocationCard() {
    final slices = _categorySlices();
    final totalFlex = slices.fold<int>(0, (sum, slice) => sum + slice.flex);
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
                  '${slices.length} categories',
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
              for (final slice in slices) SegmentSpec(slice.flex, slice.color),
            ],
            remainingFlex: 0,
          ),
          const SizedBox(height: 12),
          for (var row = 0; row < slices.length; row += 2) ...[
            if (row > 0) const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: CategoryTile(category: slices[row])),
                const SizedBox(width: 8),
                if (row + 1 < slices.length)
                  Expanded(child: CategoryTile(category: slices[row + 1]))
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ],
          if (slices.isEmpty)
            Text(
              'Category totals appear as you add bills.',
              style: AppText.bodySm.copyWith(fontSize: 10.5),
            ),
          const SizedBox(height: 2),
          if (totalFlex == 0) const SizedBox.shrink(),
        ],
      ),
    );
  }

  List<CategorySlice> _categorySlices() {
    const palette = [
      AppColors.primary,
      AppColors.tertiaryContainer,
      AppColors.tertiary,
      AppColors.secondary,
      AppColors.primaryFixed,
    ];
    final totals = <String, double>{};
    for (final bill in widget.bills) {
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
              '${widget.bills.where((b) => b.category == entries[i].key).length} bills',
          amount: entries[i].value,
          color: palette[i % palette.length],
          flex: max <= 0 ? 1 : (entries[i].value / max * 100).round(),
        ),
    ];
  }

  Widget _dueSoonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Due Soon & Urgent',
          icon: Icons.crisis_alert,
          iconColor: AppColors.secondary,
          trailing: '${_dueBills.length} Action Required',
          trailingColor: AppColors.secondary,
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < _dueBills.length; i++) ...[
          if (i == 0)
            _UrgentBillCard(
              bill: _dueBills[i],
              paying: _payingId == _dueBills[i].id,
              onPay: () => _payBill(_dueBills[i]),
              onAutoPay: () => _toggleAutoPay(_dueBills[i]),
            )
          else
            _CompactBillCard(
              bill: _dueBills[i],
              onAutoPay: () => _toggleAutoPay(_dueBills[i]),
            ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _recentlyPaidSection() {
    final paid = _paidBills.take(4).toList();
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
    final subscriptions = widget.bills
        .where((bill) => bill.category == 'Subscriptions' && !bill.paid)
        .length;
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
                  subscriptions == 0
                      ? 'No recurring subscriptions tracked.'
                      : 'You have $subscriptions active digital subscriptions.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySm.copyWith(fontSize: 10.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppPill(
            label: 'Review',
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
                          text: bill.paid ? 'Paid today' : bill.dueLabel,
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
                  bill.subtitle,
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
