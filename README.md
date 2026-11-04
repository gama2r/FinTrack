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
  with a floating quick-add action. The three sections mirror the
  **Transactions Ledger**, **Analytics** and **Settings** screens from the
  Stitch project, including trend captions, the income-trajectory velocity
  footer, the committed-spend allocation legend and the online avatar dot.
- **Alerts and profile** — the header bell opens the notification feed
  (filters, grouped alerts, mark-all-read); Settings → Edit opens the profile
  editor, and Settings → Privacy & security opens the local-vault unlock demo
  with its vault-setup flow.
- **Add transactions** — the floating action follows the active dashboard:
  General accepts bills or income, Bills is bill-only, Income is income-only.
  Income's “Log Income” stays locked to income. New entries update the relevant
  dashboard. The sheet has a close button, USD amount suffix, per-category
  icon chips and a kind badge when the kind is fixed.
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
