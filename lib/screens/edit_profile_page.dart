import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _twoFactor = true;

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
        child: Column(
          children: [
            _TopBar(onSave: () => _save()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text('Edit Profile', style: AppText.headlineLg),
                        const Spacer(),
                        AppPill(
                          label: 'Save',
                          background: AppColors.primary,
                          foreground: AppColors.onPrimary,
                          textStyle: AppText.labelMd.copyWith(fontSize: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          onTap: _save,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _Avatar(
                      onTap: () =>
                          _toast('Photo picker is not wired up in this demo.'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Change Profile Photo',
                          style: AppText.labelMd.copyWith(
                            fontSize: 10.5,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.edit,
                          size: 12,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Center(
                      child: Text(
                        'JPG, PNG or WebP · Max 4MB',
                        style: AppText.labelSm.copyWith(
                          fontSize: 8.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    _SectionLabel(
                      title: 'Personal Credentials',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const GlowDot(size: 5),
                          const SizedBox(width: 5),
                          Text(
                            'Synchronized',
                            style: AppText.labelSm.copyWith(
                              fontSize: 8.5,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _CredentialCard(),
                    const SizedBox(height: 20),
                    const _SectionLabel(
                      title: 'Account Type & Settings',
                      trailing: Text(
                        'Tier: Ultra High Net',
                        style: TextStyle(
                          fontFamily: AppText.mono,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _AccountScopeCard(),
                    const SizedBox(height: 20),
                    const _SectionLabel(title: 'Security & Device Identity'),
                    const SizedBox(height: 8),
                    _SecurityCard(
                      twoFactor: _twoFactor,
                      onTwoFactorChanged: (value) =>
                          setState(() => _twoFactor = value),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: _save,
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
                            Icon(Icons.check, size: 18),
                            SizedBox(width: 8),
                            Text('Save Changes'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              'Cancel',
                              style: AppText.labelSm.copyWith(
                                fontSize: 9.5,
                                color: AppColors.muted,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => _toast(
                            'Account closure is disabled in this demo.',
                          ),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.delete_outline,
                                  size: 14,
                                  color: AppColors.secondary,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Close Account',
                                  style: AppText.labelSm.copyWith(
                                    fontSize: 9.5,
                                    color: AppColors.secondary,
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
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    _toast('Profile updated successfully!');
    Navigator.of(context).pop();
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              size: 21,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(width: 2),
          Text('Edit Profile', style: AppText.headlineSm),
          const Spacer(),
          AppPill(
            label: 'Save',
            background: AppColors.primary,
            foreground: AppColors.onPrimary,
            textStyle: AppText.labelMd.copyWith(fontSize: 9.5),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            onTap: onSave,
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 18,
                  spreadRadius: -2,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/images/profile.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(
                Icons.person_outline,
                size: 40,
                color: AppColors.onPrimary,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 3),
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  size: 15,
                  color: AppColors.background,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: AppText.labelSm.copyWith(
              fontSize: 8.5,
              letterSpacing: 0.9,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class _CredentialCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        children: [
          _CredentialField(
            label: 'LEGAL FULL NAME',
            icon: Icons.badge_outlined,
            value: 'Alex Morgan',
          ),
          const SizedBox(height: 14),
          _CredentialField(
            label: 'PRIMARY FINANCIAL EMAIL',
            icon: Icons.mail_outline,
            value: 'alex.morgan@finmail.com',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Verified',
                style: AppText.labelSm.copyWith(
                  fontSize: 8.5,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _CredentialField(
            label: 'SECURE MOBILE NUMBER',
            icon: Icons.stay_current_portrait,
            value: '+1 (555) 382-9014',
          ),
        ],
      ),
    );
  }
}

class _CredentialField extends StatelessWidget {
  const _CredentialField({
    required this.label,
    required this.icon,
    required this.value,
    this.trailing,
  });

  final String label;
  final IconData icon;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppText.labelSm.copyWith(
                  fontSize: 8,
                  letterSpacing: 0.7,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(icon, size: 17, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 9),
            Text(
              value,
              style: AppText.bodyMd.copyWith(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AccountScopeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                size: 16,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'PRIMARY VAULT / SCOPE',
                  style: AppText.labelSm.copyWith(
                    fontSize: 8,
                    letterSpacing: 0.7,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_up,
                size: 17,
                color: AppColors.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 17,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Wealth & Cashflow (Primary)',
                        style: AppText.bodyMd.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Liquid portfolios, recurring checking & reserves',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodySm.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.check_circle,
                  size: 17,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          _ScopeRow(
            icon: Icons.group_outlined,
            title: 'Joint Household Account',
            caption: 'Shared mortgage, family trust & joint expenses',
          ),
          _ScopeRow(
            icon: Icons.domain,
            title: 'Business & Freelance LLC',
            caption: 'Operating expense, vendor invoicing & tax escrow',
            last: true,
          ),
          const Divider(height: 18, color: AppColors.divider),
          _TradeRow(
            icon: Icons.monetization_on_outlined,
            label: 'REPORTING CURRENCY',
            value: 'Currency: USD (\$)',
          ),
          const SizedBox(height: 10),
          _TradeRow(
            icon: Icons.calendar_today_outlined,
            label: 'BILLING & TAX CYCLE',
            value: 'Monthly (Calendar Cycle)',
          ),
        ],
      ),
    );
  }
}

class _ScopeRow extends StatelessWidget {
  const _ScopeRow({
    required this.icon,
    required this.title,
    required this.caption,
    this.last = false,
  });

  final IconData icon;
  final String title;
  final String caption;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.bodyMd.copyWith(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySm.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeRow extends StatelessWidget {
  const _TradeRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppText.labelSm.copyWith(
                  fontSize: 7.5,
                  letterSpacing: 0.7,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: AppText.bodyMd.copyWith(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.unfold_more,
          size: 16,
          color: AppColors.onSurfaceVariant,
        ),
      ],
    );
  }
}

class _SecurityCard extends StatelessWidget {
  const _SecurityCard({
    required this.twoFactor,
    required this.onTwoFactorChanged,
  });

  final bool twoFactor;
  final ValueChanged<bool> onTwoFactorChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.security,
                size: 20,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Two-Factor Authentication',
                      style: AppText.bodyMd.copyWith(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Biometric + Hardware Key Active',
                      style: AppText.bodySm.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
              Switch(
                value: twoFactor,
                onChanged: onTwoFactorChanged,
                activeThumbColor: AppColors.onPrimary,
                activeTrackColor: AppColors.primary,
                inactiveThumbColor: AppColors.onSurfaceVariant,
                inactiveTrackColor: AppColors.surfaceHighest,
              ),
            ],
          ),
          const Divider(height: 16, color: AppColors.divider),
          Row(
            children: [
              const Icon(
                Icons.phonelink,
                size: 20,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Authorized Devices',
                      style: AppText.bodyMd.copyWith(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'iPhone 15 Pro Max · California, USA',
                      style: AppText.bodySm.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
              Text(
                'Current',
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
