List<Map<String, String>> getNextNDays(int n) {
  final now = DateTime.now();
  final List<Map<String, String>> dates = [];

  for (int i = 0; i < n; i++) {
    final date = now.add(Duration(days: i));
    final dayInitial = _getDayString(date.weekday);
    dates.add({
      "date": date.day.toString().padLeft(2, '0'),
      "day": dayInitial, // or dayInitial if you want short "Mon", "Tue"
    });
  }

  return dates;
}

String _getDayString(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return "Mon";
    case DateTime.tuesday:
      return "Tue";
    case DateTime.wednesday:
      return "Wed";
    case DateTime.thursday:
      return "Thu";
    case DateTime.friday:
      return "Fri";
    case DateTime.saturday:
      return "Sat";
    case DateTime.sunday:
      return "Sun";
    default:
      return "";
  }
}
