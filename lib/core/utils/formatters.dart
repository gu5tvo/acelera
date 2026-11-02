String brl(num value, {bool showCents = false}) {
  final raw = showCents ? value.toStringAsFixed(2) : value.round().toString();
  final parts = raw.split('.');
  final digits = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  final cents = parts.length > 1 ? ',${parts[1]}' : '';
  return 'R\$ $buffer$cents';
}

String brlMonthly(int value) => '${brl(value)}/mês';
