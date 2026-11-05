const monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Formats a date as `November 2026`.
String monthLabel(DateTime date) =>
    '${monthNames[date.month - 1]} ${date.year}';

/// Recent month labels, newest first, ending with [now]'s month.
List<String> recentMonthLabels(DateTime now, {int count = 6}) {
  return [
    for (var i = 0; i < count; i++)
      monthLabel(DateTime(now.year, now.month - i)),
  ];
}
