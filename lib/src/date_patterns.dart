// ignore_for_file: constant_identifier_names

/// Common date/time format patterns used throughout the package.
class DatePatterns {
  DatePatterns._();

  /// `HH` — hour (24-hour clock)
  static const String PATTERN_HH = "HH";

  /// `dd` — day of month
  static const String PATTERN_DD = "dd";

  /// `MM` — month number
  static const String PATTERN_MM = "MM";

  /// `yy` — 2-digit year
  static const String PATTERN_Y = "yy";

  /// `yyyy` — 4-digit year
  static const String PATTERN_YY = "yyyy";

  /// `dd/MM/yyyy` — e.g. 25/03/2026
  static const String PATTERN_1 = "dd/MM/yyyy";

  /// `dd/MM` — e.g. 25/03
  static const String PATTERN_2 = "dd/MM";

  /// `yyyy-MM-dd'T'HHmmss` — compact ISO-like
  static const String PATTERN_3 = "yyyy-MM-dd'T'HHmmss";

  /// `h:mm a dd/MM` — e.g. 3:30 PM 25/03
  static const String PATTERN_4 = "h:mm a dd/MM";

  /// `yyyy-MM-dd HH:mm:ss` — full datetime with space separator
  static const String PATTERN_5 = "yyyy-MM-dd HH:mm:ss";

  /// `dd/MM/yyyy HH:mm` — e.g. 25/03/2026 15:30
  static const String PATTERN_6 = "dd/MM/yyyy HH:mm";

  /// `HH:mm dd/MM/yyyy` — e.g. 15:30 25/03/2026
  static const String PATTERN_7 = "HH:mm dd/MM/yyyy";

  /// `yyyy-MM-ddTHH:mm:ss` — ISO 8601 with T separator
  static const String PATTERN_8 = "yyyy-MM-ddTHH:mm:ss";

  /// `HH:mm - dd/MM/yyyy` — e.g. 15:30 - 25/03/2026
  static const String PATTERN_9 = "HH:mm - dd/MM/yyyy";

  /// `dd/MM/yyyy HH:mm:ss` — full datetime, VN order
  static const String PATTERN_10 = "dd/MM/yyyy HH:mm:ss";

  /// `MM/yyyy` — month and year only
  static const String PATTERN_11 = "MM/yyyy";

  /// `HH:mm:ss` — time with seconds
  static const String PATTERN_12 = "HH:mm:ss";

  /// `HH:mm` — time only
  static const String PATTERN_13 = "HH:mm";

  /// `-MMyyyy` — prefixed month-year
  static const String PATTERN_14 = "-MMyyyy";

  /// `yyyy-MM-dd HH:mm` — datetime without seconds
  static const String PATTERN_15 = "yyyy-MM-dd HH:mm";

  /// `HH:mm dd/MM` — time then short date
  static const String PATTERN_16 = "HH:mm dd/MM";

  /// `yyyy-MM-dd` — ISO date (default backend pattern)
  static const String PATTERN_DEFAULT = "yyyy-MM-dd";
}
