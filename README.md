# FinTrack

A dark, mobile-first bills and income tracker built with Flutter, following the
**Luminescent Wealth** design system in [`DESIGN.md`](DESIGN.md).

## Features

- **General dashboard** — net cash flow hero, safe-to-spend budget, upcoming
  bills carousel, filterable cash-flow activity and savings spotlight.
- **Bills dashboard** — monthly bill total with settlement ring, category
  allocation, due-soon actions, working **Pay Now** flow, recently paid history
  and subscription audit.
- **Income dashboard** — total received, scheduled income, income-stream
  diversification, expected inflows and a six-month earnings chart.
- **Dashboard menu** — animated General / Bills / Income segmented switcher.
- **Bottom navigation** — dashboard, transactions ledger, analytics and settings,
  with a floating quick-add action.
- **Add transactions** — the floating action follows the active dashboard:
  General accepts bills or income, Bills is bill-only, Income is income-only.
  Income's “Log Income” stays locked to income. New entries update the relevant
  dashboard.
- Locally bundled Manrope, Hanken Grotesk and JetBrains Mono fonts.
- Responsive layout for mobile, tablet and desktop/web.

## Run

```bash
flutter pub get
flutter run -d chrome   # or: flutter run -d <device>
```

## Verify

```bash
flutter analyze
flutter test
flutter build web --release
```

Golden screenshots for the three dashboards live in `test/goldens/`.
