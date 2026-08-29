extension StringUtils on String {
  String get capitalize {
    if (length < 2) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String addStringToStart(String start) {
    return '$start$this';
  }
}
