/// Formats a value as `$1,234.50` with optional leading sign.
String formatCurrency(double value, {bool signed = false}) {
  final negative = value < 0;
  final abs = value.abs();
  final fixed = abs.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();

  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }

  final body = '\$${buffer.toString()}.${parts.last}';
  if (signed) return negative ? '-$body' : '+$body';
  return negative ? '-$body' : body;
}

/// Compact chart label such as `$6.8k`.
String formatCompact(double value) => '\$${value.toStringAsFixed(1)}k';

String formatPercent(double value, {int decimals = 0}) =>
    '${value.toStringAsFixed(decimals)}%';
