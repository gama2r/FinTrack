import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/common.dart';

class IncomeDashboard extends StatelessWidget {
  const IncomeDashboard({
    super.key,
    required this.entries,
    required this.month,
    required this.onLogIncome,
    required this.onInvoiceClient,
    required this.onExportTax,
  });

  final List<TransactionEntry> entries;
  final String month;
  final VoidCallback onLogIncome;
  final VoidCallback onInvoiceClient;
  final VoidCallback onExportTax;

  double get _total => entries.fold(0.0, (sum, entry) => sum + entry.amount);

  Map<String, double> get _streams {
    final totals = <String, double>{};
    for (final entry in entries) {
      final label = entry.subtitle.split(' • ').first;
      totals.update(
        label,
        (value) => value + entry.amount,
        ifAbsent: () => entry.amount,
      );
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final streams = _streams;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _statusRow(streams.length),
          const SizedBox(height: 10),
          _heroCard(),
          const SizedBox(height: 14),
          _quickActions(),
          const SizedBox(height: 18),
          _incomeStreams(streams),
          const SizedBox(height: 16),
          _incomeTrajectory(context),
        ],
      ),
    );
  }

  Widget _statusRow(int streamCount) {
    return Row(
      children: [
        const GlowDot(),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'INFLOW TRACKER ACTIVE',
            style: AppText.labelSm.copyWith(
              fontSize: 9.5,
              letterSpacing: 1,
              color: AppColors.primary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.verified_outlined,
                size: 13,
                color: AppColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                streamCount == 1 ? '1 Stream' : '$streamCount Streams',
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
      color: AppColors.surface,
      glowColor: AppColors.primary,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'TOTAL RECEIVED • ${month.split(' ').first.toUpperCase()}',
                  style: AppText.labelSm.copyWith(
                    fontSize: 9,
                    letterSpacing: 0.9,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  entries.length == 1 ? '1 entry' : '${entries.length} entries',
                  style: AppText.labelSm.copyWith(
                    fontSize: 9,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '\$',
                  style: AppText.headlineSm.copyWith(
                    fontSize: 19,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  formatCurrency(_total).substring(1),
                  style: AppText.displayLgMobile.copyWith(
                    fontSize: 33,
                    letterSpacing: -1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            entries.isEmpty
                ? 'Nothing received yet. Log your first income entry.'
                : 'Average of ${formatCurrency(_total / entries.length)} per entry.',
            style: AppText.bodySm.copyWith(fontSize: 10.5),
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
            label: 'Log Income',
            icon: Icons.add_circle_outline,
            primary: true,
            onTap: onLogIncome,
          ),
          const SizedBox(width: 8),
          PrimaryActionPill(
            label: 'Invoice Client',
            icon: Icons.send_rounded,
            iconColor: AppColors.tertiary,
            onTap: onInvoiceClient,
          ),
          const SizedBox(width: 8),
          PrimaryActionPill(
            label: 'Export Tax',
            icon: Icons.receipt_outlined,
            iconColor: AppColors.onSurfaceVariant,
            onTap: onExportTax,
          ),
        ],
      ),
    );
  }

  Widget _incomeStreams(Map<String, double> streams) {
    final entriesList = streams.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final colors = [
      AppColors.primary,
      AppColors.tertiaryContainer,
      AppColors.secondary,
      AppColors.tertiary,
      AppColors.primaryFixed,
    ];
    return AppCard(
      color: AppColors.surface,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Income Streams',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.headlineSm.copyWith(fontSize: 17),
                    ),
                    Text(
                      'Diversification & proportion',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySm.copyWith(fontSize: 10.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${entriesList.length} Active',
                  style: AppText.labelSm.copyWith(
                    fontSize: 8.5,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (entriesList.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Income streams appear once you log an entry.',
                textAlign: TextAlign.center,
                style: AppText.bodySm.copyWith(fontSize: 11),
              ),
            )
          else ...[
            AllocationBar(
              segments: [
                for (var i = 0; i < entriesList.length; i++)
                  SegmentSpec(
                    (_total <= 0 ? 0 : entriesList[i].value / _total * 100)
                        .round(),
                    colors[i % colors.length],
                  ),
              ],
              remainingFlex: 0,
              height: 12,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                for (var i = 0; i < entriesList.length; i++)
                  _LegendDot(
                    color: colors[i % colors.length],
                    label:
                        '${entriesList[i].key} '
                        '(${(_total <= 0 ? 0 : entriesList[i].value / _total * 100).round()}%)',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < entriesList.length; i++) ...[
              _StreamTile(
                label: entriesList[i].key,
                amount: entriesList[i].value,
                color: colors[i % colors.length],
                share: _total <= 0
                    ? 0
                    : (entriesList[i].value / _total * 100).round(),
                count: entries
                    .where((e) => e.subtitle.startsWith(entriesList[i].key))
                    .length,
              ),
              if (i != entriesList.length - 1) const SizedBox(height: 8),
            ],
          ],
        ],
      ),
    );
  }

  Widget _incomeTrajectory(BuildContext context) {
    return AppCard(
      color: AppColors.surface,
      padding: const EdgeInsets.all(14),
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
                      'Income Trajectory',
                      style: AppText.headlineSm.copyWith(fontSize: 17),
                    ),
                    Text(
                      'Monthly history',
                      style: AppText.bodySm.copyWith(fontSize: 10.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
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
                  'No history yet',
                  style: AppText.bodyMd.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Your trajectory builds as you log income over time.',
                  textAlign: TextAlign.center,
                  style: AppText.bodySm.copyWith(fontSize: 10.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppText.labelSm.copyWith(
            fontSize: 8,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _StreamTile extends StatelessWidget {
  const _StreamTile({
    required this.label,
    required this.amount,
    required this.color,
    required this.share,
    required this.count,
  });

  final String label;
  final double amount;
  final Color color;
  final int share;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.payments_outlined, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyMd.copyWith(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  count == 1 ? '1 entry • $share%' : '$count entries • $share%',
                  style: AppText.bodySm.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            formatCurrency(amount),
            style: AppText.headlineSm.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
