# AGENTS.md

## Project
- Single Flutter app (`fin_track`), Dart `^3.13.7`, mobile-first dark UI. No state-management, routing, or codegen packages — plain `setState`.
- Entry path: `lib/main.dart` → `FinTrackApp` (`lib/app.dart`) → `HomeShell` (`lib/screens/home_shell.dart`).

## Branches
- `mockup` is only for working with screens generated in Stitch. Do not add app functionality here.
- `main` is the functional app. Sync UI work from `mockup` into `main`, but keep `main` free of mock/demo data: empty first-run states plus real functionality only.

## Commands
```bash
flutter pub get
flutter run -d chrome                 # or: -d <device>
flutter analyze                       # must stay clean
flutter test                          # widget + golden tests
flutter test test/widget_test.dart --plain-name "logging income updates the income dashboard total"
flutter test --update-goldens test/golden_test.dart
flutter build web --release
flutter build apk --debug
```
- No CI, pre-commit hooks, Makefile, or build_runner. Run checks manually.
- Android app id: `com.example.fin_track`; debug APK at `build/app/outputs/flutter-apk/app-debug.apk`.

## Architecture
- All mutable state (`_navIndex`, `_dashboardIndex`, transactions, bills, added income) lives in `_HomeShellState` and flows down via data + callbacks. Keep new state there unless there is a real reason not to.
- Bottom-nav indices are non-contiguous: Dashboard `0`, Transactions `1`, Analytics `3`, Settings `4`. `HomeShell` maps `1→0`, `3→1`, else `2` when indexing `secondary_pages.dart`. Do not renumber these casually.
- `FlowHeader` (General/Bills/Income switcher) renders only when `_navIndex == 0`; selecting a dashboard forces `_navIndex = 0`.
- Theme tokens live in `lib/theme/app_theme.dart` (`AppColors`, `AppText`, `AppTheme`). Use them instead of hardcoded colors or text styles. Fonts are bundled in `assets/fonts` and declared in `pubspec.yaml`; do not add `google_fonts`.
- Shared widgets: `lib/widgets/common.dart`, `cards.dart`, `charts.dart`. Models: `lib/data/models.dart`. There is no mock dataset — the app starts empty and every dashboard computes from the in-memory `transactions`/`bills` lists.

## Add flow
- The floating add button is always present. On General it accepts bill or income; on Bills it is locked to bill; on Income it is locked to income. Secondary tabs keep the universal sheet.
- A locked screen passes `fixedKind`. A fixed kind hides the sheet's Bill/Income toggle (key `kind-toggle`) and shows a `Bill`/`Income` badge next to the title. Scoping is decided by callers in `HomeShell`, not inside the sheet.
- The sheet header has a close `×` button with tooltip `Close`. Keep the `Add transaction` and `Close` tooltips and the `Log a transaction` title — tests rely on them.
- Saving resets `_navIndex = 0` and jumps to Bills (`1`) or Income (`2`) based on the entry kind.

## Secondary pages
- Transactions, Analytics and Settings (`secondary_pages.dart`) mirror the Stitch section screens with the same names. Analytics uses page-private `_AnalyticsMetric` and `_AllocationLegend` widgets instead of the shared `MetricTile`, so dashboard goldens stay untouched.

## Pushed screens
- `notifications_page.dart` — opened by the header bell (tooltip `Notifications`); local filter chips and mark-all-read state live in the page.
- `edit_profile_page.dart` — opened by Settings → `Edit`.
- `vault_pages.dart` — `UnlockVaultPage` opens from Settings → `Privacy & security`; `CreateVaultPage` opens from Unlock Vault → `Switch Local Vault`, then `CreateVaultStep2Page` and `CreateVaultStep3Page` chain the 3-step setup. Both flows are demo screens with no persistence.
- These routes are outside the goldens; the six dashboard goldens must not change. Stitch's “FlowFinance - Personal Finance & Cash Flow Tracker” canvas screen is a duplicate of Create Local Vault.

## Tests and goldens
- `flutter test` compares six goldens in `test/goldens/`: three dashboards at 390×844 plus full pages at 390×1900. Any visual change fails until goldens are regenerated and inspected.
- Widget and golden tests both call `loadAppFonts()` from `test/test_fonts.dart`; goldens are invalid without the real bundled fonts.
- `test/failures/` holds generated diff artifacts from failed golden runs. Safe to delete; never treat as source.

## Gotchas
- `lib/theme/app_theme.dart` is the design source of truth; `README.md` documents the app and its Stitch origin.
- UI originates from Stitch project `16122598622821369244` ("Flutter Finance Tracker", Luminescent Wealth). When syncing a design change, update widgets and goldens together.
