String formatPrice(num? value) {
  if (value == null) {
    return "-";
  }
  return value.toStringAsFixed(2);
}

String formatPriceWithSymbol(num value, {String symbol = 'null'}) {
  final formatted = formatPrice(value);
  return symbol.isEmpty ? formatted : '$symbol$formatted';
}
