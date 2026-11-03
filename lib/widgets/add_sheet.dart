import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

Future<NewEntry?> showAddEntrySheet(
  BuildContext context, {
  EntryKind initialKind = EntryKind.bill,
  EntryKind? fixedKind,
}) {
  return showModalBottomSheet<NewEntry>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) =>
        AddEntrySheet(initialKind: initialKind, fixedKind: fixedKind),
  );
}

class AddEntrySheet extends StatefulWidget {
  const AddEntrySheet({
    super.key,
    this.initialKind = EntryKind.bill,
    this.fixedKind,
  });

  final EntryKind initialKind;

  /// When set, the sheet only accepts this kind and hides the kind toggle.
  final EntryKind? fixedKind;

  @override
  State<AddEntrySheet> createState() => _AddEntrySheetState();
}

class _AddEntrySheetState extends State<AddEntrySheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  late EntryKind _kind = widget.fixedKind ?? widget.initialKind;
  late String _category = _categories.first;
  String? _error;

  static const _billCategories = [
    'Housing',
    'Utilities',
    'Subscriptions',
    'Insurance',
    'Other',
  ];
  static const _incomeCategories = [
    'Salary',
    'Freelance',
    'Investments',
    'Products',
    'Other',
  ];

  List<String> get _categories =>
      _kind == EntryKind.bill ? _billCategories : _incomeCategories;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _setKind(EntryKind kind) {
    setState(() {
      _kind = kind;
      _category = _categories.first;
      _error = null;
    });
  }

  void _submit() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.replaceAll(',', ''));
    if (title.isEmpty || amount == null || amount <= 0) {
      setState(() => _error = 'Add a title and an amount greater than zero.');
      return;
    }
    Navigator.of(context).pop(
      NewEntry(kind: _kind, title: title, amount: amount, category: _category),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceLow,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHighest,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Log a transaction',
                  style: AppText.headlineMd.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 3),
                Text(
                  'Keep your cash flow current.',
                  style: AppText.bodySm.copyWith(fontSize: 11.5),
                ),
                const SizedBox(height: 16),
                if (widget.fixedKind == null)
                  Container(
                    height: 42,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLowest,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        _KindButton(
                          label: 'Bill',
                          selected: _kind == EntryKind.bill,
                          onTap: () => _setKind(EntryKind.bill),
                        ),
                        _KindButton(
                          label: 'Income',
                          selected: _kind == EntryKind.income,
                          onTap: () => _setKind(EntryKind.income),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                _Label('Description'),
                const SizedBox(height: 6),
                _Field(
                  controller: _titleController,
                  hint: _kind == EntryKind.bill
                      ? 'e.g. Apartment rent'
                      : 'e.g. Freelance retainer',
                  icon: _kind == EntryKind.bill
                      ? Icons.receipt_outlined
                      : Icons.payments_outlined,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 14),
                _Label('Amount'),
                const SizedBox(height: 6),
                _Field(
                  controller: _amountController,
                  hint: '0.00',
                  icon: Icons.attach_money,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                ),
                const SizedBox(height: 14),
                _Label('Category'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    for (final category in _categories)
                      AppPill(
                        label: category,
                        background: _category == category
                            ? AppColors.primary
                            : AppColors.surfaceHigh,
                        foreground: _category == category
                            ? AppColors.onPrimary
                            : AppColors.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        textStyle: AppText.labelSm.copyWith(fontSize: 9),
                        onTap: () => setState(() => _category = category),
                      ),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: AppText.bodySm.copyWith(
                      fontSize: 11,
                      color: AppColors.error,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: AppText.labelMd.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: Text(
                      _kind == EntryKind.bill ? 'Save Bill' : 'Save Income',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KindButton extends StatelessWidget {
  const _KindButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.surfaceHigh : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: AppText.labelMd.copyWith(
              fontSize: 11,
              color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppText.labelSm.copyWith(
        fontSize: 8.5,
        letterSpacing: 0.8,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      style: AppText.bodyMd.copyWith(color: AppColors.onSurface),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppText.bodyMd.copyWith(color: AppColors.muted),
        prefixIcon: Icon(icon, size: 19, color: AppColors.onSurfaceVariant),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
