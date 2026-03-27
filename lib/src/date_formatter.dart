import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:vn_date_formatter/src/date_extensions.dart';
import 'package:vn_date_formatter/src/date_patterns.dart';

/// A collection of date formatting and conversion utilities with Vietnamese
/// locale support.
///
/// Call [VnDateFormatter.initialize] once before using any method that relies
/// on the `vi_VN` locale (i.e. [convertDateToString], [convertStringToDate],
/// and any helper that delegates to them).
///
/// ```dart
/// void main() async {
///   await DateFormatter.initialize();
///   runApp(const MyApp());
/// }
/// ```
class VnDateFormatter {
  VnDateFormatter._();

  /// Initialises the `vi_VN` locale data required by [convertDateToString]
  /// and [convertStringToDate].
  ///
  /// Safe to call multiple times — subsequent calls are no-ops.
  static Future<void> initialize() => initializeDateFormatting('vi_VN', null);

  // ---------------------------------------------------------------------------
  // Basic formatting
  // ---------------------------------------------------------------------------

  /// Formats [dateTime] using [DatePatterns.PATTERN_1] (`dd/MM/yyyy`).
  static String formatDateTimeToString(DateTime dateTime) {
    return DateFormat(DatePatterns.PATTERN_1).format(dateTime);
  }

  /// Formats [dateTime] for backend consumption.
  ///
  /// Returns `null` when [dateTime] is `null`.
  /// Defaults to [DatePatterns.PATTERN_DEFAULT] (`yyyy-MM-dd`).
  static String? convertDateTimeToStringBE(
    DateTime? dateTime, {
    String pattern = DatePatterns.PATTERN_DEFAULT,
  }) {
    if (dateTime == null) return null;
    return DateFormat(pattern).format(dateTime);
  }

  /// Formats [dateTime] as a full datetime string (`yyyy-MM-dd HH:mm:ss`).
  ///
  /// Returns `null` when [dateTime] is `null`.
  static String? formatDateTimeToStringBE(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateFormat(DatePatterns.PATTERN_5).format(dateTime);
  }

  // ---------------------------------------------------------------------------
  // Vietnamese long-form date
  // ---------------------------------------------------------------------------

  /// Returns a Vietnamese long-form date string, e.g.:
  /// `"15:30 ngày 25 tháng 3 năm 2026"`.
  ///
  /// You can override the full date locale string via [longDateLocale]
  /// (defaults to `"vi"`).
  static String convertDateToStringVN({
    DateTime? dateTime,
    String longDateLocale = "vi",
  }) {
    final dt = dateTime ?? DateTime.now();
    final time = convertDateToString(dt, DatePatterns.PATTERN_13);
    final longDate = DateFormat.yMMMMd(longDateLocale).format(dt);
    return "$time ngày $longDate".replaceAll(",", " năm");
  }

  // ---------------------------------------------------------------------------
  // Timestamp helpers
  // ---------------------------------------------------------------------------

  /// Converts a date string [dateTimeStr] (formatted with [pattern]) to a
  /// Unix millisecond timestamp. Returns `0` for empty input.
  static int convertDMYToTimeStamps(
    String dateTimeStr, {
    String pattern = DatePatterns.PATTERN_1,
  }) {
    if (dateTimeStr.isNotEmpty) {
      final dateTime = convertStringToDate(dateTimeStr, pattern);
      return dateTime.millisecondsSinceEpoch;
    }
    return 0;
  }

  // ---------------------------------------------------------------------------
  // Core conversion helpers
  // ---------------------------------------------------------------------------

  /// Formats [dateTime] (stripping milliseconds) using [pattern] and the
  /// `vi_VN` locale.
  static String convertDateToString(DateTime dateTime, String pattern) {
    return DateFormat(pattern, "vi_VN").format(dateTime.withoutMilliseconds());
  }

  /// Parses [dateTime] string using [pattern] and the `vi_VN` locale.
  static DateTime convertStringToDate(String dateTime, String pattern) {
    return DateFormat(pattern, "vi_VN").parse(dateTime);
  }

  /// Formats [dateTime] using [DatePatterns.PATTERN_DEFAULT] (`yyyy-MM-dd`).
  static String convertDateToStringDefault(DateTime dateTime) {
    return DateFormat(DatePatterns.PATTERN_DEFAULT).format(dateTime);
  }

  // ---------------------------------------------------------------------------
  // String-to-string conversions
  // ---------------------------------------------------------------------------

  /// Parses a date [String] via [DateTime.parse] (local timezone) and
  /// reformats it with [pattern].
  ///
  /// Returns [date] unchanged if parsing fails.
  static String changeDateString(
    String date, {
    String pattern = DatePatterns.PATTERN_1,
  }) {
    try {
      final parsedDate = DateTime.parse(date).toLocal();
      return DateFormat(pattern).format(parsedDate);
    } catch (_) {
      return date;
    }
  }

  /// Converts a `dd/MM/yyyy` string to `yyyy-MM-dd`.
  static String convertPattern1ToPatternDefault(String dateTime) {
    return DateFormat(DatePatterns.PATTERN_DEFAULT)
        .format(DateFormat(DatePatterns.PATTERN_1).parse(dateTime));
  }

  /// Converts a `yyyy-MM-dd` string to `dd/MM/yyyy`.
  ///
  /// Returns `""` for empty input.
  static String convertPatternDefaultToPattern1(String dateTime) {
    if (dateTime.isEmpty) return "";
    return DateFormat(DatePatterns.PATTERN_1)
        .format(DateFormat(DatePatterns.PATTERN_DEFAULT).parse(dateTime));
  }

  /// Converts a date string from [inPattern] to [outPattern].
  ///
  /// Returns `""` for empty input.
  static String convertPatternDefaultToPatternOther(
    String dateTime, {
    String outPattern = DatePatterns.PATTERN_1,
    String inPattern = DatePatterns.PATTERN_DEFAULT,
  }) {
    if (dateTime.isEmpty) return "";
    return DateFormat(outPattern).format(DateFormat(inPattern).parse(dateTime));
  }

  // ---------------------------------------------------------------------------
  // Relative / human-readable labels
  // ---------------------------------------------------------------------------

  /// Returns a human-readable relative label for [dateTime] (a `yyyy-MM-dd`
  /// string) in Vietnamese.
  ///
  /// | Difference | Output |
  /// |---|---|
  /// | 0 days | [todayLabel] |
  /// | 1 day  | [yesterdayLabel] |
  /// | 2–6 days | `"N [daysAgoLabel]"` |
  /// | ≥ 7 days | `dd/MM/yyyy` formatted string |
  ///
  /// Override the labels to use your own localisation system.
  static String convertDateVN(
    String dateTime, {
    String todayLabel = "Hôm nay",
    String yesterdayLabel = "Hôm qua",
    String daysAgoLabel = "ngày trước",
  }) {
    final input = convertStringToDate(dateTime, DatePatterns.PATTERN_DEFAULT);
    final diff = DateTime.now().difference(input);
    final today = diff.inDays;

    if (today == 0) return todayLabel;
    if (today == 1) return yesterdayLabel;
    if (today > 1 && today < 7) return "$today $daysAgoLabel";
    return changeDateString(dateTime);
  }

  /// Returns a Vietnamese weekday label for [dateTime].
  ///
  /// | Case | Output |
  /// |---|---|
  /// | null or today | [todayLabel] |
  /// | yesterday | [yesterdayLabel] |
  /// | other | weekday name from [weekdayLabels] |
  ///
  /// [weekdayLabels] must be a 7-element list ordered
  /// `[Mon, Tue, Wed, Thu, Fri, Sat, Sun]`.
  static String convertWeekdayVN(
    DateTime? dateTime, {
    String todayLabel = "Hôm nay",
    String yesterdayLabel = "Hôm qua",
    List<String> weekdayLabels = const [
      "Thứ Hai",
      "Thứ Ba",
      "Thứ Tư",
      "Thứ Năm",
      "Thứ Sáu",
      "Thứ Bảy",
      "Chủ Nhật",
    ],
  }) {
    assert(
      weekdayLabels.length == 7,
      "weekdayLabels must contain exactly 7 elements (Mon–Sun).",
    );

    final now = DateTime.now();

    if (dateTime == null ||
        (dateTime.year == now.year &&
            dateTime.month == now.month &&
            dateTime.day == now.day)) {
      return todayLabel;
    }

    final yesterday = DateTime(now.year, now.month, now.day - 1);
    if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return yesterdayLabel;
    }

    // DateTime.monday == 1, DateTime.sunday == 7
    return weekdayLabels[dateTime.weekday - 1];
  }

  // ---------------------------------------------------------------------------
  // Miscellaneous
  // ---------------------------------------------------------------------------

  /// Returns the quarter (1–4) for [date].
  static int getQuarter(DateTime date) => (date.month + 2) ~/ 3;

  /// Parses an `HH:mm` string to an integer (e.g. `"09:30"` → `930`).
  static int convertHourToInt(String dateTime) {
    return int.tryParse(
          dateTime.replaceAll(":", '').replaceAll(" ", ""),
        ) ??
        0;
  }
}
