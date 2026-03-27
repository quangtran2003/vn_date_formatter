import 'package:vn_date_formatter/vn_date_formatter.dart';

void main() {
  final now = DateTime(2026, 3, 25, 15, 30, 45, 999);

  // ── Basic formatting ────────────────────────────────────────────────────────

  // dd/MM/yyyy
  print(VnDateFormatter.formatDateTimeToString(now)); // 25/03/2026

  // yyyy-MM-dd (backend default)
  print(VnDateFormatter.convertDateTimeToStringBE(now)); // 2026-03-25

  // yyyy-MM-dd HH:mm:ss
  print(VnDateFormatter.formatDateTimeToStringBE(now)); // 2026-03-25 15:30:45

  // null-safe
  print(VnDateFormatter.convertDateTimeToStringBE(null)); // null

  // ── Vietnamese long-form ────────────────────────────────────────────────────

  // "15:30 ngày 25 tháng 3 năm 2026"
  print(VnDateFormatter.convertDateToStringVN(dateTime: now));

  // ── Relative labels ─────────────────────────────────────────────────────────

  final today = VnDateFormatter.convertDateToStringDefault(DateTime.now());
  print(VnDateFormatter.convertDateVN(today)); // Hôm nay

  final yesterday = VnDateFormatter.convertDateToStringDefault(
    DateTime.now().subtract(const Duration(days: 1)),
  );
  print(VnDateFormatter.convertDateVN(yesterday)); // Hôm qua

  final threeDaysAgo = VnDateFormatter.convertDateToStringDefault(
    DateTime.now().subtract(const Duration(days: 3)),
  );
  print(VnDateFormatter.convertDateVN(threeDaysAgo)); // 3 ngày trước

  // Custom labels (e.g. when integrating with your own localisation)
  print(
    VnDateFormatter.convertDateVN(
      today,
      todayLabel: 'Today',
      yesterdayLabel: 'Yesterday',
      daysAgoLabel: 'days ago',
    ),
  ); // Today

  // ── Weekday label ────────────────────────────────────────────────────────────

  print(VnDateFormatter.convertWeekdayVN(null)); // Hôm nay
  print(VnDateFormatter.convertWeekdayVN(DateTime(2026, 3, 23))); // Thứ Hai

  // ── Pattern conversions ──────────────────────────────────────────────────────

  print(
    VnDateFormatter.convertPattern1ToPatternDefault('25/03/2026'),
  ); // 2026-03-25

  print(
    VnDateFormatter.convertPatternDefaultToPattern1('2026-03-25'),
  ); // 25/03/2026

  print(
    VnDateFormatter.convertPatternDefaultToPatternOther(
      '2026-03-25',
      outPattern: DatePatterns.PATTERN_6,
    ),
  ); // 25/03/2026 00:00

  // ── Timestamps ───────────────────────────────────────────────────────────────

  print(VnDateFormatter.convertDMYToTimeStamps('25/03/2026'));

  // ── Miscellaneous ────────────────────────────────────────────────────────────

  print(VnDateFormatter.getQuarter(DateTime(2026, 3))); // 1
  print(VnDateFormatter.getQuarter(DateTime(2026, 7))); // 3
  print(VnDateFormatter.convertHourToInt('09:30')); // 930

  // ── DateTime extension ───────────────────────────────────────────────────────

  print(now.withoutMilliseconds()); // 2026-03-25 15:30:45.000
}
