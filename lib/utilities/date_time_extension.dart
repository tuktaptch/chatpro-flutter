import 'package:date_format/date_format.dart';

extension DateTimeFormatter on DateTime? {
  /// คืนค่ารูปแบบเวลา เช่น "08:30 AM"
  String formattedTime() {
    final date = this ?? DateTime.now();
    return formatDate(date, [hh, ':', nn, ' ', am]);
  }

  /// คืนค่ารูปแบบวันที่ เช่น "1989-02-21"
  String formattedDate() {
    final date = this ?? DateTime.now();
    return formatDate(date, [dd, ' ', M, ', ', yyyy]);
  }
}
