import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Profile saved.')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(onSave: _save),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 6),
                    const _Avatar(),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Optional. Nothing leaves this device.',
                        style: AppText.labelSm.copyWith(
                          fontSize: 8.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const _SectionLabel(title: 'Personal Details'),
                    const SizedBox(height: 8),
                    _Field(
                      label: 'FULL NAME',
                      icon: Icons.badge_outlined,
                      controller: _name,
                      hint: 'Your name',
                    ),
                    const SizedBox(height: 12),
                    _Field(
                      label: 'EMAIL',
                      icon: Icons.mail_outline,
                      controller: _email,
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    _Field(
                      label: 'MOBILE NUMBER',
                      icon: Icons.stay_current_portrait,
                      controller: _phone,
                      hint: '+1 555 000 0000',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderSoft),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            size: 15,
                            color: AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'Profile details are stored locally and are '
                              'never uploaded.',
                              style: AppText.bodySm.copyWith(fontSize: 10.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
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
                    const SizedBox(height: 12),
                    Center(
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          child: Text(
                            'Cancel',
                            style: AppText.labelSm.copyWith(
                              fontSize: 9.5,
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
          ],
        ),
      ),
    );
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
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
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
        child: const ColoredBox(
          color: AppColors.surfaceHigh,
          child: Icon(
            Icons.person_outline,
            size: 40,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: AppText.labelSm.copyWith(
          fontSize: 8.5,
          letterSpacing: 0.9,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.icon,
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: AppText.labelSm.copyWith(
              fontSize: 8,
              letterSpacing: 0.7,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppText.bodyMd.copyWith(color: AppColors.onSurface),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppText.bodyMd.copyWith(color: AppColors.muted),
            prefixIcon: Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
            filled: true,
            fillColor: AppColors.surfaceLow,
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
        ),
      ],
    );
  }
}
