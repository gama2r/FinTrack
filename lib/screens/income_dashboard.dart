import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/cards.dart';
import '../widgets/charts.dart';
import '../widgets/common.dart';

class IncomeDashboard extends StatelessWidget {
  const IncomeDashboard({
    super.key,
    required this.onLogIncome,
    required this.onInvoiceClient,
    required this.onExportTax,
    this.additionalIncome = 0,
  });

  final VoidCallback onLogIncome;
  final VoidCallback onInvoiceClient;
  final VoidCallback onExportTax;
  final double additionalIncome;

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
          const SizedBox(height: 14),
          _quickActions(),
          const SizedBox(height: 18),
          _incomeStreams(),
          const SizedBox(height: 16),
          _expectedInflows(),
          const SizedBox(height: 16),
          _incomeTrajectory(context),
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
                '4 Streams Synced',
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
                  'TOTAL RECEIVED • OCTOBER',
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      size: 11,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '+8.5%',
                      style: AppText.labelSm.copyWith(
                        fontSize: 9,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
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
                  formatCurrency(6850 + additionalIncome).substring(1),
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
          Text.rich(
            TextSpan(
              text: 'Target surpassed by ',
              style: AppText.bodySm.copyWith(fontSize: 10.5),
              children: [
                TextSpan(
                  text: formatCurrency(
                    (6850 + additionalIncome) - 6500,
                  ),
                  style: AppText.bodySm.copyWith(
                    fontSize: 10.5,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: ' (Goal: \$6,500.00)'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
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
                    color: AppColors.tertiaryContainer.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.hourglass_top,
                    size: 17,
                    color: AppColors.tertiary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scheduled Incoming',
                        style: AppText.labelSm.copyWith(
                          fontSize: 8.5,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '\$1,400.00',
                        style: AppText.headlineSm.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Month End Est.',
                      style: AppText.labelSm.copyWith(
                        fontSize: 8.5,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      formatCurrency(8250 + additionalIncome),
                      style: AppText.headlineSm.copyWith(
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

  Widget _incomeStreams() {
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
                  '4 Active',
                  style: AppText.labelSm.copyWith(
                    fontSize: 8.5,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AllocationBar(
            segments: [
              for (final stream in MockData.incomeStreams)
                SegmentSpec(
                  stream.flex,
                  stream.flex == 76
                      ? AppColors.primary
                      : stream.flex == 18
                          ? AppColors.tertiaryContainer
                          : stream.flex == 5
                              ? AppColors.secondary
                              : AppColors.surfaceBright,
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
              _LegendDot(
                color: AppColors.primary,
                label: 'Tech Salary (76%)',
              ),
              _LegendDot(
                color: AppColors.tertiaryContainer,
                label: 'Freelance (18%)',
              ),
              _LegendDot(
                color: AppColors.secondary,
                label: 'Inv (5%)',
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < MockData.incomeStreams.length; i++) ...[
            IncomeStreamTile(stream: MockData.incomeStreams[i]),
            if (i != MockData.incomeStreams.length - 1)
              const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _expectedInflows() {
    return AppCard(
      color: AppColors.surface,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.event_outlined,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Expected Inflows',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.headlineSm.copyWith(fontSize: 17),
                ),
              ),
              const SizedBox(width: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Next 7 Days',
                  style: AppText.labelSm.copyWith(fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          for (var i = 0; i < MockData.expectedInflows.length; i++) ...[
            UpcomingInflowTile(inflow: MockData.expectedInflows[i]),
            if (i != MockData.expectedInflows.length - 1)
              const DashedDivider(),
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
                      '6-Month monthly performance',
                      style: AppText.bodySm.copyWith(fontSize: 10.5),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 12,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '+14.2% MoM',
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
          const SizedBox(height: 12),
          IncomeBarChart(
            months: MockData.chartMonths,
            values: MockData.chartValues,
            onBarTap: (index) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${MockData.chartMonths[index]} earnings: '
                    '\$${MockData.chartValues[index].toStringAsFixed(1)}k',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.tips_and_updates_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "You've reached your monthly earnings milestone 4 days "
                    'earlier than in September!',
                    style: AppText.bodySm.copyWith(
                      fontSize: 10.5,
                      height: 1.35,
                    ),
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
