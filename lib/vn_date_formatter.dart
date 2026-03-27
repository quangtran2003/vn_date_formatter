/// A Dart/Flutter package for formatting and converting dates with Vietnamese
/// locale support.
///
/// ## Quick start
///
/// ```dart
/// import 'package:vn_date_formatter/vn_date_formatter.dart';
///
/// void main() {
///   final now = DateTime.now();
///
///   // Format to dd/MM/yyyy
///   print(DateFormatter.formatDateTimeToString(now)); // 25/03/2026
///
///   // Vietnamese relative label
///   print(DateFormatter.convertDateVN('2026-03-24')); // Hôm qua
///
///   // Weekday in Vietnamese
///   print(DateFormatter.convertWeekdayVN(now)); // Hôm nay
///
///   // Strip milliseconds via extension
///   print(now.withoutMilliseconds());
/// }
/// ```
library vn_date_formatter;

export 'src/date_extensions.dart';
export 'src/date_patterns.dart';
export 'src/date_formatter.dart';
