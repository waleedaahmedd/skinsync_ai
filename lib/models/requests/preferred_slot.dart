class PreferredSlot {
  final String date;
  final String time;

  PreferredSlot({required this.date, required this.time});

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
    };
  }
}
