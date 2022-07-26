String? convertDateTime(String date) {
  try {
    final dateTime = DateTime.parse(date);
    final minute = '${dateTime.minute}'.padLeft(2, '0');
    final hour = '${dateTime.hour}'.padLeft(2, '0');
    final day = '${dateTime.day}'.padLeft(2, '0');
    final month = '${dateTime.month}'.padLeft(2, '0');
    final year = '${dateTime.year}'.padLeft(2, '0');

    return '$hour:$minute ($year-$month-$day)';
  } on Exception {
    return null;
  }
}
