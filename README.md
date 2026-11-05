# FinTrack

A dark, mobile-first bills and income tracker built with Flutter. FinTrack runs
entirely on the device: there is no account, backend, or network sync. On first
launch every dashboard is empty until you log your first entry.

## First run

There is no seeded demo data. The General, Bills and Income dashboards all start
at `$0.00` with empty states ("No activity yet", "No bills yet", and "No history
yet"). Log a bill or income from the floating **+** action and the totals,
filters, category allocation and settlement ring update from those real entries.

Entries currently live in app memory for the session. Nothing is written to a
database yet, so restarting the app clears the ledger.

## Features

- **General dashboard** — net cash flow, income vs. outflow, safe-to-spend
  remaining, upcoming bills from your own list, filterable activity, and a
  local-storage note.
- **Bills dashboard** — computed monthly total, settlement progress, category
  allocation, due-soon actions, a working **Pay Now** flow, recently paid
  history, and a subscription summary.
- **Income dashboard** — total received, income streams grouped by category,
  and an empty-by-default trajectory panel.
- **Dashboard switcher** — animated General / Bills / Income segmented control
  with a month selector.
- **Secondary pages** — Transactions ledger, Analytics and Settings, all driven
  by the same in-memory data.
- **Add flow** — the floating action is scoped to the active screen: General
  accepts bills or income, Bills is bill-only, and Income is income-only.
- **Alerts and profile** — the header bell opens the notification inbox (empty
  until entries exist); Settings → Edit opens a local profile form, and
  Settings → Privacy & security opens the offline vault demo flow.
- Bundled Manrope, Hanken Grotesk and JetBrains Mono fonts; responsive layout.

## Project layout

```
lib/
  app.dart                 MaterialApp + theme
  main.dart                entry point
  data/models.dart         TransactionEntry, BillItem, CategorySlice
  screens/                 dashboards, secondary pages, vault/profile flows
  theme/app_theme.dart     AppColors, AppText, AppTheme design tokens
  utils/                   formatters and date helpers
  widgets/                 shared cards, charts, header, nav and add sheet
test/
  widget_test.dart         first-run, add-flow and navigation tests
  golden_test.dart         six golden screenshots
```

All mutable app state lives in `_HomeShellState` and flows down through
constructor parameters and callbacks. There is no state-management or routing
package; navigation uses plain `setState` and `Navigator`.

## Run

```bash
flutter pub get
flutter run -d chrome                 # or: -d <device>
```

## Verify

```bash
flutter analyze                       # must stay clean
flutter test                          # widget + golden tests
flutter build web --release
flutter build apk --debug
```

Goldens live in `test/goldens/` (three 390×844 dashboards and three full pages
at 390×1900) and are rendered with the bundled fonts. Regenerate them after an
intentional visual change:

```bash
flutter test --update-goldens test/golden_test.dart
```

## Design source

The UI originates from the Stitch project **Flutter Finance Tracker
(Luminescent Wealth)**. The `mockup` branch is kept as a separate workspace for
Stitch-generated screens. Visual changes to this app should update widgets and
goldens together, and reconcile with the Stitch canvas when applicable.
