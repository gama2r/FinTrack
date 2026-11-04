import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';

class CreateVaultPage extends StatefulWidget {
  const CreateVaultPage({super.key});

  @override
  State<CreateVaultPage> createState() => _CreateVaultPageState();
}

class _CreateVaultPageState extends State<CreateVaultPage> {
  static const _currencies = [
    ('USD', '\$', 'USD - US Dollar'),
    ('EUR', '€', 'EUR - Euro'),
    ('GBP', '£', 'GBP - British Pound'),
    ('JPY', '¥', 'JPY - Japanese Yen'),
    ('CHF', 'Fr', 'CHF - Swiss Franc'),
  ];

  final _vaultName = TextEditingController(text: 'Personal Finances');
  final _ownerName = TextEditingController(text: 'Alex Morgan');
  int _currency = 0;
  bool _pinAndBiometrics = true;

  @override
  void dispose() {
    _vaultName.dispose();
    _ownerName.dispose();
    super.dispose();
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final currency = _currencies[_currency];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Tooltip(
                    message: 'Back',
                    child: InkWell(
                      onTap: () => Navigator.of(context).maybePop(),
                      borderRadius: BorderRadius.circular(999),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'STEP 1 OF 3',
                    style: AppText.labelSm.copyWith(
                      fontSize: 9,
                      letterSpacing: 1,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Vault Setup',
                    style: AppText.labelSm.copyWith(
                      fontSize: 9,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _ProgressSegment(filled: true)),
                  const SizedBox(width: 6),
                  const Expanded(child: _ProgressSegment(filled: false)),
                  const SizedBox(width: 6),
                  const Expanded(child: _ProgressSegment(filled: false)),
                ],
              ),
              const SizedBox(height: 26),
              Center(
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.enhanced_encryption_outlined,
                    size: 28,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Create Local Vault',
                textAlign: TextAlign.center,
                style: AppText.displayLgMobile,
              ),
              const SizedBox(height: 8),
              Text(
                'No account required. All bills, income, and transactions '
                'are stored privately and encrypted on this device.',
                textAlign: TextAlign.center,
                style: AppText.bodyMd.copyWith(
                  fontSize: 13,
                  height: 1.45,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              _FieldLabel(
                'Vault Name',
                trailing: Text(
                  '• Primary Storage',
                  style: AppText.labelSm.copyWith(
                    fontSize: 8.5,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              _InputBox(
                controller: _vaultName,
                icon: Icons.folder_special_outlined,
                trailing: const Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Owner Profile Name'),
              const SizedBox(height: 6),
              _InputBox(controller: _ownerName, icon: Icons.person_outline),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Icon(
                    Icons.offline_pin_outlined,
                    size: 13,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Stored only locally in your device sandboxed storage',
                      style: AppText.bodySm.copyWith(
                        fontSize: 10.5,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _FieldLabel(
                'Base Ledger Currency',
                trailing: Text(
                  'ISO 4217',
                  style: AppText.labelSm.copyWith(
                    fontSize: 8.5,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHigh,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        currency.$2,
                        style: AppText.headlineSm.copyWith(fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currency.$3,
                            style: AppText.bodyMd.copyWith(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Default decimal precision (2)',
                            style: AppText.bodySm.copyWith(fontSize: 10.5),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.unfold_more,
                      size: 17,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (var i = 0; i < _currencies.length; i++) ...[
                    if (i > 0) const SizedBox(width: 6),
                    _CurrencyPill(
                      code: _currencies[i].$1,
                      symbol: _currencies[i].$2,
                      selected: _currency == i,
                      onTap: () => setState(() => _currency = i),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),
              const _FieldLabel('Access & Encryption Protocol'),
              const SizedBox(height: 8),
              _AccessOption(
                selected: _pinAndBiometrics,
                title: 'Device PIN & Biometrics',
                badge: 'RECOMMENDED',
                caption: 'Use Face ID / Fingerprint to open app and protect cryptographic key ring',
                icon: Icons.fingerprint,
                onTap: () => setState(() => _pinAndBiometrics = true),
              ),
              const SizedBox(height: 8),
              _AccessOption(
                selected: !_pinAndBiometrics,
                title: 'Unrestricted Offline Access',
                caption: 'Open immediately without lock prompts. Local DB still encrypted via hardware root.',
                icon: Icons.lock_open_outlined,
                onTap: () => setState(() => _pinAndBiometrics = false),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.18),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.verified_user_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Local-Only Guarantee',
                            style: AppText.bodyMd.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'FlowFinance does not collect emails, telemetry, or remote telemetry. Data is secured via ',
                                ),
                                TextSpan(
                                  text: 'AES-256-GCM',
                                  style: AppText.labelSm.copyWith(
                                    fontSize: 9.5,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' within zero-knowledge hardware storage.',
                                ),
                              ],
                            ),
                            style: AppText.bodySm.copyWith(
                              fontSize: 10.5,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CreateVaultStep2Page(),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: AppText.labelMd.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Initialize Local Vault'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 17),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'Already have an existing backup file?',
                  style: AppText.bodySm.copyWith(
                    fontSize: 10.5,
                    color: AppColors.muted,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: InkWell(
                  onTap: () =>
                      _toast('Restore picker is not wired up in this demo.'),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.settings_backup_restore,
                          size: 15,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Restore from local JSON / SQLite',
                          style: AppText.labelSm.copyWith(
                            fontSize: 9.5,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UnlockVaultPage extends StatefulWidget {
  const UnlockVaultPage({super.key});

  @override
  State<UnlockVaultPage> createState() => _UnlockVaultPageState();
}

class _UnlockVaultPageState extends State<UnlockVaultPage> {
  int _pinLength = 4;

  static const _keys = [
    ('1', ''),
    ('2', 'ABC'),
    ('3', 'DEF'),
    ('4', 'GHI'),
    ('5', 'JKL'),
    ('6', 'MNO'),
    ('7', 'PQRS'),
    ('8', 'TUV'),
    ('9', 'WXYZ'),
  ];

  void _append(String digit) {
    if (_pinLength >= 6) return;
    setState(() => _pinLength++);
    if (_pinLength == 6) {
      _toast('Vault unlocked.');
    }
  }

  void _backspace() {
    if (_pinLength == 0) return;
    setState(() => _pinLength--);
  }

  void _unlockWithFaceId() {
    setState(() => _pinLength = 6);
    _toast('Face ID verified. Vault unlocked.');
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 28,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'FlowFinance',
                  style: AppText.headlineMd.copyWith(fontSize: 20),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.borderSoft),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const GlowDot(size: 5),
                      const SizedBox(width: 6),
                      Text(
                        '100% OFFLINE & ON-DEVICE VAULT',
                        style: AppText.labelSm.copyWith(
                          fontSize: 8,
                          letterSpacing: 0.6,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'AM',
                        style: AppText.labelMd.copyWith(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Alex Morgan',
                                style: AppText.bodyMd.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified_user,
                                size: 12,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                          Text(
                            'Local Vault #1 (Encrypted SQLite)',
                            style: AppText.bodySm.copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.swap_horiz,
                      size: 19,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Center(
                child: Text(
                  'Unlock Vault',
                  style: AppText.headlineMd.copyWith(fontSize: 24),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Enter your 6-digit security PIN or authenticate '
                  'biometrically to decrypt your financial ledger.',
                  textAlign: TextAlign.center,
                  style: AppText.bodyMd.copyWith(
                    fontSize: 12,
                    height: 1.45,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 6; i++) ...[
                    if (i > 0) const SizedBox(width: 10),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: i < _pinLength
                            ? AppColors.primary
                            : AppColors.surfaceHighest,
                        shape: BoxShape.circle,
                        boxShadow: i < _pinLength
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.55,
                                  ),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _unlockWithFaceId,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderSoft),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.face_outlined,
                          size: 19,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Quick Unlock with Face ID',
                          style: AppText.labelMd.copyWith(
                            fontSize: 11,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          size: 15,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              for (var row = 0; row < 3; row++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      for (var col = 0; col < 3; col++) ...[
                        if (col > 0) const SizedBox(width: 8),
                        Expanded(
                          child: _KeypadKey(
                            digit: _keys[row * 3 + col].$1,
                            letters: _keys[row * 3 + col].$2,
                            onTap: () => _append(_keys[row * 3 + col].$1),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: _KeypadAction(
                      icon: Icons.fingerprint,
                      iconColor: AppColors.primary,
                      onTap: _unlockWithFaceId,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _KeypadKey(
                      digit: '0',
                      letters: '+',
                      onTap: () => _append('0'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _KeypadAction(
                      icon: Icons.backspace_outlined,
                      iconColor: AppColors.onSurface,
                      onTap: _backspace,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'Financial data never leaves this phone. '
                        'Zero servers, zero trackers.',
                        textAlign: TextAlign.center,
                        style: AppText.bodySm.copyWith(fontSize: 10.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const CreateVaultPage(),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Switch Local Vault',
                        style: AppText.labelSm.copyWith(
                          fontSize: 9.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '·',
                      style: AppText.labelSm.copyWith(
                        fontSize: 9.5,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        _toast('PIN reset is not available in this demo.'),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Forgot PIN? (Reset DB)',
                        style: AppText.labelSm.copyWith(
                          fontSize: 9.5,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressSegment extends StatelessWidget {
  const _ProgressSegment({required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: filled ? AppColors.primary : AppColors.surfaceHighest,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label, {this.trailing});

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppText.labelSm.copyWith(
            fontSize: 9,
            letterSpacing: 0.6,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 6),
        ?trailing,
      ],
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.controller,
    required this.icon,
    this.trailing,
  });

  final TextEditingController controller;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              style: AppText.bodyMd.copyWith(
                fontSize: 13.5,
                color: AppColors.onSurface,
              ),
              cursorColor: AppColors.primary,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _CurrencyPill extends StatelessWidget {
  const _CurrencyPill({
    required this.code,
    required this.symbol,
    required this.selected,
    required this.onTap,
  });

  final String code;
  final String symbol;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          height: 34,
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.12)
                : AppColors.surfaceLow,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderSoft,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                code,
                style: AppText.labelSm.copyWith(
                  fontSize: 9,
                  color: selected
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                symbol,
                style: AppText.labelSm.copyWith(
                  fontSize: 9,
                  color: selected
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccessOption extends StatelessWidget {
  const _AccessOption({
    required this.selected,
    required this.title,
    required this.caption,
    required this.icon,
    required this.onTap,
    this.badge,
  });

  final bool selected;
  final String title;
  final String caption;
  final IconData icon;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.35)
                : AppColors.borderSoft,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 20,
              color: selected ? AppColors.primary : AppColors.muted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: AppText.bodyMd.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge!,
                            style: AppText.labelSm.copyWith(
                              fontSize: 7.5,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    caption,
                    style: AppText.bodySm.copyWith(fontSize: 10.5, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 19,
              color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _KeypadKey extends StatelessWidget {
  const _KeypadKey({
    required this.digit,
    required this.letters,
    required this.onTap,
  });

  final String digit;
  final String letters;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(digit, style: AppText.headlineMd.copyWith(fontSize: 21)),
            if (letters.isNotEmpty)
              Text(
                letters,
                style: AppText.labelSm.copyWith(
                  fontSize: 7.5,
                  color: AppColors.muted,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _KeypadAction extends StatelessWidget {
  const _KeypadAction({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Icon(icon, size: 22, color: iconColor),
      ),
    );
  }
}

class CreateVaultStep2Page extends StatefulWidget {
  const CreateVaultStep2Page({super.key});

  @override
  State<CreateVaultStep2Page> createState() => _CreateVaultStep2PageState();
}

class _CreateVaultStep2PageState extends State<CreateVaultStep2Page> {
  static const _seedWords = [
    'velvet',
    'anchor',
    'cobalt',
    'orbit',
    'quartz',
    'timber',
    'glacier',
    'mystic',
    'beacon',
    'forge',
    'copper',
    'zenith',
  ];

  int _pinDigits = 4;
  bool _biometrics = true;
  bool _acknowledged = true;

  void _addPinDigit() {
    if (_pinDigits >= 6) return;
    setState(() => _pinDigits++);
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _VaultStepBar(step: 2, label: 'Vault Security', filled: 2),
              const SizedBox(height: 24),
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.enhanced_encryption_outlined,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_user,
                          size: 14,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Set Access & Security',
                textAlign: TextAlign.center,
                style: AppText.headlineLg,
              ),
              const SizedBox(height: 8),
              Text(
                'Because FlowFinance is 100% offline, your PIN and '
                'emergency recovery key are the only ways to access this vault.',
                textAlign: TextAlign.center,
                style: AppText.bodyMd.copyWith(
                  fontSize: 13,
                  height: 1.45,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSoft),
                ),
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
                                'Create 6-Digit Master PIN',
                                style: AppText.headlineSm.copyWith(
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Required each time you open FlowFinance',
                                style: AppText.bodySm.copyWith(fontSize: 10.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceHigh,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '123',
                            style: AppText.labelSm.copyWith(
                              fontSize: 8.5,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _addPinDigit,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLowest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < 6; i++) ...[
                              if (i > 0) const SizedBox(width: 11),
                              Container(
                                width: 11,
                                height: 11,
                                decoration: BoxDecoration(
                                  color: i < _pinDigits
                                      ? AppColors.primary
                                      : AppColors.surfaceHighest,
                                  shape: BoxShape.circle,
                                  boxShadow: i < _pinDigits
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.55,
                                            ),
                                            blurRadius: 8,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          size: 13,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'AES-256 GCM salt generated',
                            maxLines: 2,
                            style: AppText.labelSm.copyWith(
                              fontSize: 8,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Text(
                          '$_pinDigits / 6 digits entered',
                          textAlign: TextAlign.right,
                          style: AppText.labelSm.copyWith(
                            fontSize: 8.5,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Row(
                  children: [
                    const IconBadge(
                      icon: Icons.fingerprint,
                      color: AppColors.primary,
                      background: AppColors.surfaceHigh,
                      size: 40,
                      radius: 10,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enable Biometric Login',
                            style: AppText.bodyMd.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Hardware secure enclave biometric unlock',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.bodySm.copyWith(fontSize: 10.5),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _biometrics,
                      onChanged: (value) => setState(() => _biometrics = value),
                      activeThumbColor: AppColors.onPrimary,
                      activeTrackColor: AppColors.primary,
                      inactiveThumbColor: AppColors.onSurfaceVariant,
                      inactiveTrackColor: AppColors.surfaceHighest,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.vpn_key_outlined,
                          size: 19,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Offline Recovery Key',
                          style: AppText.headlineSm.copyWith(fontSize: 17),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceHigh,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Zero-Knowledge',
                            style: AppText.labelSm.copyWith(
                              fontSize: 7.5,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Write down these 12 cryptographic seed words in exact '
                      'order. Store them physically offline.',
                      style: AppText.bodySm.copyWith(
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLowest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          for (var row = 0; row < 4; row++) ...[
                            if (row > 0) const SizedBox(height: 6),
                            Row(
                              children: [
                                for (var col = 0; col < 3; col++) ...[
                                  if (col > 0) const SizedBox(width: 6),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceLow,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${row * 3 + col + 1}.',
                                            style: AppText.labelSm.copyWith(
                                              fontSize: 8,
                                              color: AppColors.muted,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              _seedWords[row * 3 + col],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppText.labelSm.copyWith(
                                                fontSize: 8.5,
                                                color: AppColors.onSurface,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_outlined,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'BIP-39 Standard 128-bit',
                          style: AppText.labelSm.copyWith(
                            fontSize: 8.5,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        AppPill(
                          label: 'Copy Key',
                          icon: Icons.content_copy,
                          background: AppColors.surfaceHigh,
                          foreground: AppColors.onSurface,
                          textStyle: AppText.labelSm.copyWith(fontSize: 8.5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          onTap: () => _toast('Recovery key copied.'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: () => setState(() => _acknowledged = !_acknowledged),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderSoft),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: _acknowledged
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _acknowledged
                                ? AppColors.primary
                                : AppColors.muted,
                          ),
                        ),
                        child: _acknowledged
                            ? const Icon(
                                Icons.check,
                                size: 15,
                                color: AppColors.onPrimary,
                              )
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'I understand that if I lose my PIN and recovery '
                          'key, no server, developer, or support team can '
                          'recover my vault.',
                          style: AppText.bodySm.copyWith(
                            fontSize: 11.5,
                            height: 1.45,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CreateVaultStep3Page(),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: AppText.labelMd.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue to Financial Setup'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 17),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: InkWell(
                  onTap: () => _toast('Encrypted key export is not wired up.'),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.download_outlined,
                          size: 14,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Export Key to Encrypted JSON',
                          style: AppText.labelSm.copyWith(
                            fontSize: 9,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateVaultStep3Page extends StatefulWidget {
  const CreateVaultStep3Page({super.key});

  @override
  State<CreateVaultStep3Page> createState() => _CreateVaultStep3PageState();
}

class _CreateVaultStep3PageState extends State<CreateVaultStep3Page> {
  int _amount = 1;
  int _frequency = 1;

  static const _amounts = ['\$3,500', '\$5,000', '\$7,500', 'Custom'];
  static const _frequencies = ['Bi-weekly', 'Monthly', 'Twice Monthly'];

  void _complete(String message) {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).popUntil((route) => route.isFirst);
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _VaultStepBar(
                step: 3,
                label: 'Starting Baseline',
                filled: 3,
              ),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 30,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Set Initial Balances',
                textAlign: TextAlign.center,
                style: AppText.headlineLg,
              ),
              const SizedBox(height: 8),
              Text(
                'Seed your local ledger with starting figures so your '
                'dashboards and cashflow projections are ready immediately.',
                textAlign: TextAlign.center,
                style: AppText.bodyMd.copyWith(
                  fontSize: 13,
                  height: 1.45,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_outlined,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Operating Account',
                          style: AppText.headlineSm.copyWith(fontSize: 17),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'PRIMARY',
                            style: AppText.labelSm.copyWith(
                              fontSize: 7.5,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'ACCOUNT LABEL',
                      style: AppText.labelSm.copyWith(
                        fontSize: 8,
                        letterSpacing: 0.7,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.credit_card,
                            size: 18,
                            color: AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 9),
                          Text(
                            'Vault Checking & Cash',
                            style: AppText.bodyMd.copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'STARTING BALANCE',
                      style: AppText.labelSm.copyWith(
                        fontSize: 8,
                        letterSpacing: 0.7,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLowest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            size: 24,
                            color: AppColors.primary,
                          ),
                          const Spacer(),
                          Text(
                            '5,000.00',
                            style: AppText.headlineMd.copyWith(fontSize: 26),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    Center(
                      child: Text(
                        'Available liquid capital to anchor balances',
                        style: AppText.bodySm.copyWith(
                          fontSize: 10.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          size: 19,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Expected Net Inflow',
                          style: AppText.headlineSm.copyWith(fontSize: 17),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'ESTIMATED MONTHLY NET INCOME',
                      style: AppText.labelSm.copyWith(
                        fontSize: 8,
                        letterSpacing: 0.7,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (var i = 0; i < _amounts.length; i++) ...[
                          if (i > 0) const SizedBox(width: 6),
                          Expanded(
                            child: _ChoicePill(
                              label: _amounts[i],
                              selected: _amount == i,
                              primary: true,
                              onTap: () => setState(() => _amount = i),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'DEPOSIT FREQUENCY',
                      style: AppText.labelSm.copyWith(
                        fontSize: 8,
                        letterSpacing: 0.7,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (var i = 0; i < _frequencies.length; i++) ...[
                          if (i > 0) const SizedBox(width: 6),
                          Expanded(
                            child: _ChoicePill(
                              label: _frequencies[i],
                              selected: _frequency == i,
                              onTap: () => setState(() => _frequency = i),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Major Recurring Outflow',
                          style: AppText.headlineSm.copyWith(fontSize: 17),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Anchor',
                            style: AppText.labelSm.copyWith(
                              fontSize: 7.5,
                              color: AppColors.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
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
                          const IconBadge(
                            icon: Icons.home_outlined,
                            color: AppColors.onSurfaceVariant,
                            background: AppColors.surfaceHigh,
                            size: 38,
                            radius: 10,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rent / Mortgage',
                                  style: AppText.bodyMd.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Due 1st of month',
                                  style: AppText.bodySm.copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$1,650.00',
                                style: AppText.labelMd.copyWith(fontSize: 11),
                              ),
                              Text(
                                'Fixed monthly',
                                style: AppText.labelSm.copyWith(
                                  fontSize: 8,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _toast('Fixed bill form is not wired up.'),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_circle_outline,
                              size: 15,
                              color: AppColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Add Another Fixed Bill',
                              style: AppText.labelSm.copyWith(
                                fontSize: 9,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'These values populate your offline SQLite database '
                        'directly. No cloud sync or transmission occurs.',
                        textAlign: TextAlign.center,
                        style: AppText.bodySm.copyWith(fontSize: 10.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: () =>
                      _complete('Vault ready. Welcome back, Alex.'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: AppText.labelMd.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Complete Setup & Open Vault'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 17),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: InkWell(
                  onTap: () => _complete('Starting with an empty ledger.'),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: Text(
                      'Skip for now, start with empty ledger',
                      style: AppText.labelSm.copyWith(
                        fontSize: 9,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VaultStepBar extends StatelessWidget {
  const _VaultStepBar({
    required this.step,
    required this.label,
    required this.filled,
  });

  final int step;
  final String label;
  final int filled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Material(
              color: AppColors.surfaceLow,
              shape: const CircleBorder(
                side: BorderSide(color: AppColors.borderSoft),
              ),
              child: InkWell(
                onTap: () => Navigator.of(context).maybePop(),
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 42,
                  height: 42,
                  child: Icon(
                    Icons.arrow_back,
                    size: 19,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              'STEP $step OF 3',
              style: AppText.labelSm.copyWith(
                fontSize: 9,
                letterSpacing: 1,
                color: AppColors.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Text(
                '•',
                style: AppText.labelSm.copyWith(
                  fontSize: 9,
                  color: AppColors.muted,
                ),
              ),
            ),
            Text(
              label.toUpperCase(),
              style: AppText.labelSm.copyWith(
                fontSize: 9,
                letterSpacing: 0.8,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(child: _ProgressSegment(filled: i < filled)),
            ],
          ],
        ),
      ],
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
    this.primary = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final background = selected
        ? (primary ? AppColors.primary : AppColors.surfaceHigh)
        : AppColors.surfaceLow;
    final foreground = selected
        ? (primary ? AppColors.onPrimary : AppColors.onSurface)
        : AppColors.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
          border: selected && !primary
              ? Border.all(color: AppColors.muted)
              : Border.all(color: AppColors.borderSoft),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppText.labelSm.copyWith(
            fontSize: 9,
            color: foreground,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
