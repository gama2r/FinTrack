import 'package:flutter/material.dart';

import 'screens/home_shell.dart';
import 'theme/app_theme.dart';

class FinTrackApp extends StatelessWidget {
  const FinTrackApp({super.key, this.now});

  /// Fixed clock for tests; the app uses the current date by default.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: HomeShell(now: now),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context)
              .copyWith(scrollbars: false, overscroll: false),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
