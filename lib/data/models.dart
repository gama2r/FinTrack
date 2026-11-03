import 'package:flutter/material.dart';

enum EntryKind { bill, income }

class TransactionEntry {
  const TransactionEntry({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.icon,
    required this.accent,
    required this.status,
  });

  final String title;
  final String subtitle;
  final double amount;
  final bool isIncome;
  final IconData icon;
  final Color accent;
  final String status;
}

class BillItem {
  const BillItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.amount,
    required this.dueLabel,
    required this.icon,
    required this.accent,
    required this.category,
    this.autoPay = false,
    this.recurring = true,
    this.urgent = false,
    this.paid = false,
  });

  final String id;
  final String name;
  final String subtitle;
  final double amount;
  final String dueLabel;
  final IconData icon;
  final Color accent;
  final String category;
  final bool autoPay;
  final bool recurring;
  final bool urgent;
  final bool paid;

  BillItem copyWith({bool? autoPay, bool? paid}) => BillItem(
    id: id,
    name: name,
    subtitle: subtitle,
    amount: amount,
    dueLabel: dueLabel,
    icon: icon,
    accent: accent,
    category: category,
    autoPay: autoPay ?? this.autoPay,
    recurring: recurring,
    urgent: urgent,
    paid: paid ?? this.paid,
  );
}

class IncomeStream {
  const IncomeStream({
    required this.name,
    required this.detail,
    required this.amount,
    required this.share,
    required this.icon,
    required this.accent,
    required this.flex,
    this.pending = false,
  });

  final String name;
  final String detail;
  final double amount;
  final int share;
  final IconData icon;
  final Color accent;
  final int flex;
  final bool pending;
}

class UpcomingInflow {
  const UpcomingInflow({
    required this.month,
    required this.day,
    required this.name,
    required this.source,
    required this.amount,
    required this.status,
    required this.confirmed,
  });

  final String month;
  final String day;
  final String name;
  final String source;
  final double amount;
  final String status;
  final bool confirmed;
}

class CategorySlice {
  const CategorySlice({
    required this.label,
    required this.subtitle,
    required this.amount,
    required this.color,
    required this.flex,
  });

  final String label;
  final String subtitle;
  final double amount;
  final Color color;
  final int flex;
}

class NewEntry {
  const NewEntry({
    required this.kind,
    required this.title,
    required this.amount,
    required this.category,
  });

  final EntryKind kind;
  final String title;
  final double amount;
  final String category;
}
