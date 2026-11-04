import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/add_sheet.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/flow_header.dart';
import 'bills_dashboard.dart';
import 'general_dashboard.dart';
import 'income_dashboard.dart';
import 'notifications_page.dart';
import 'secondary_pages.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _dashboardIndex = 0;
  int _navIndex = 0;
  String _month = 'October 2024';
  final List<TransactionEntry> _transactions = [...MockData.transactions];
  final List<BillItem> _bills = [...MockData.bills];
  double _additionalIncome = 0;

  void _selectDashboard(int index) {
    setState(() {
      _navIndex = 0;
      _dashboardIndex = index;
    });
  }

  void _selectNav(int index) {
    setState(() => _navIndex = index);
  }

  Future<void> _openAddSheet({
    EntryKind initialKind = EntryKind.bill,
    EntryKind? fixedKind,
  }) async {
    final entry = await showAddEntrySheet(
      context,
      initialKind: initialKind,
      fixedKind: fixedKind,
    );
    if (entry == null || !mounted) return;

    final isIncome = entry.kind == EntryKind.income;
    setState(() {
      _transactions.insert(
        0,
        TransactionEntry(
          title: entry.title,
          subtitle: '${entry.category} • Just now',
          amount: isIncome ? entry.amount : -entry.amount,
          isIncome: isIncome,
          icon: isIncome
              ? Icons.payments_outlined
              : Icons.receipt_long_outlined,
          accent: isIncome ? AppColors.primary : AppColors.secondary,
          status: 'Manual entry',
        ),
      );
      if (isIncome) {
        _additionalIncome += entry.amount;
      } else {
        _bills.insert(
          0,
          BillItem(
            id: 'manual-${DateTime.now().microsecondsSinceEpoch}',
            name: entry.title,
            subtitle: '${entry.category} • Manual entry',
            amount: entry.amount,
            dueLabel: 'Due Oct 31',
            icon: Icons.receipt_long_outlined,
            accent: AppColors.secondary,
            category: entry.category,
          ),
        );
      }
      _navIndex = 0;
      _dashboardIndex = isIncome ? 2 : 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isIncome
              ? '${entry.title} logged as income.'
              : '${entry.title} added to bills.',
        ),
      ),
    );
  }

  void _notify(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openNotifications() async {
    final manage = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const NotificationsPage()));
    if (manage == true && mounted) {
      _selectNav(4);
    }
  }

  /// Bills and Income dashboards scope quick-add to their own kind.
  /// General and the secondary tabs keep the universal sheet.
  EntryKind? get _fabFixedKind {
    if (_navIndex != 0) return null;
    return switch (_dashboardIndex) {
      1 => EntryKind.bill,
      2 => EntryKind.income,
      _ => null,
    };
  }

  Widget _body() {
    if (_navIndex == 0) {
      return IndexedStack(
        index: _dashboardIndex,
        children: [
          GeneralDashboard(
            transactions: _transactions,
            onAddBill: () => _openAddSheet(),
            onLogIncome: () => _openAddSheet(initialKind: EntryKind.income),
            onViewAllBills: () => _selectDashboard(1),
            onMarkBillPaid: (bill) => _notify('${bill.name} marked as paid.'),
          ),
          BillsDashboard(
            bills: _bills,
            onPayBill: (bill) {
              final index = _bills.indexWhere((item) => item.id == bill.id);
              setState(() {
                if (index >= 0) {
                  _bills[index] = bill;
                } else {
                  _bills.add(bill);
                }
              });
              _notify('${bill.name} settled.');
            },
            onToggleAutoPay: (bill) {
              final index = _bills.indexWhere((item) => item.id == bill.id);
              if (index < 0) return;
              setState(() => _bills[index] = bill);
              _notify(
                'Auto-pay ${bill.autoPay ? 'enabled' : 'disabled'} '
                'for ${bill.name}.',
              );
            },
          ),
          IncomeDashboard(
            additionalIncome: _additionalIncome,
            onLogIncome: () => _openAddSheet(
              initialKind: EntryKind.income,
              fixedKind: EntryKind.income,
            ),
            onInvoiceClient: () =>
                _notify('Client invoice drafted for Studio Apex.'),
            onExportTax: () => _notify('Tax export prepared for October.'),
          ),
        ],
      );
    }

    final secondaryIndex = switch (_navIndex) {
      1 => 0,
      3 => 1,
      _ => 2,
    };
    return IndexedStack(
      index: secondaryIndex,
      children: [
        TransactionsPage(transactions: _transactions),
        const AnalyticsPage(),
        const SettingsPage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (_navIndex == 0)
              FlowHeader(
                selectedDashboard: _dashboardIndex,
                onDashboardChanged: _selectDashboard,
                month: _month,
                onMonthChanged: (value) => setState(() => _month = value),
                onNotifications: _openNotifications,
                onProfile: () => _selectNav(4),
              ),
            Expanded(child: _body()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        activeIndex: _navIndex,
        onSelect: _selectNav,
      ),
      floatingActionButton: _FloatingAddButton(
        onTap: () => _openAddSheet(fixedKind: _fabFixedKind),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _FloatingAddButton extends StatelessWidget {
  const _FloatingAddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Add transaction',
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryContainer],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.34),
              blurRadius: 24,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: const Center(
              child: Icon(Icons.add, size: 28, color: AppColors.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
