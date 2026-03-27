# vn_date_formatter

A Dart/Flutter package for formatting and converting dates with full Vietnamese
locale support.

## Features

- 20+ named date/time pattern constants (`DatePatterns`)
- Format & parse helpers (`VnDateFormatter`)
- Vietnamese long-form date string — `"15:30 ngày 25 tháng 3 năm 2026"`
- Relative-time labels — `"Hôm nay"`, `"Hôm qua"`, `"3 ngày trước"`
- Vietnamese weekday labels — `"Thứ Hai"` … `"Chủ Nhật"`
- Quarter calculation
- `DateTime.withoutMilliseconds()` extension
- Configurable labels — integrate with any localisation system (GetX, Flutter
  `intl`, etc.)

## Installation

```yaml
dependencies:
  vn_date_formatter: ^1.0.0
```

Then run:

```sh
flutter pub get
```

## Usage

```dart
import 'package:vn_date_formatter/vn_date_formatter.dart';

void main() {
  final now = DateTime(2026, 3, 25, 15, 30, 45);

  // ── Basic formatting ────────────────────────────────────────────────────────

  VnDateFormatter.formatDateTimeToString(now);
  // → "25/03/2026"

  VnDateFormatter.convertDateTimeToStringBE(now);
  // → "2026-03-25"

  VnDateFormatter.formatDateTimeToStringBE(now);
  // → "2026-03-25 15:30:45"

  VnDateFormatter.convertDateTimeToStringBE(null);
  // → null

  // ── Vietnamese long-form ─────────────────────────────────────────────────────

  VnDateFormatter.convertDateToStringVN(dateTime: now);
  // → "15:30 ngày 25 tháng 3 năm 2026"

  // ── Relative labels ──────────────────────────────────────────────────────────

  VnDateFormatter.convertDateVN('2026-03-25'); // → "Hôm nay"
  VnDateFormatter.convertDateVN('2026-03-24'); // → "Hôm qua"
  VnDateFormatter.convertDateVN('2026-03-22'); // → "3 ngày trước"
  VnDateFormatter.convertDateVN('2026-03-01'); // → "01/03/2026"

  // Custom labels for your own i18n system:
  VnDateFormatter.convertDateVN(
    '2026-03-25',
    todayLabel: 'Today',
    yesterdayLabel: 'Yesterday',
    daysAgoLabel: 'days ago',
  ); // → "Today"

  // ── Weekday labels ───────────────────────────────────────────────────────────

  VnDateFormatter.convertWeekdayVN(null);                  // → "Hôm nay"
  VnDateFormatter.convertWeekdayVN(DateTime(2026, 3, 23)); // → "Thứ Hai"

  // ── Pattern conversions ──────────────────────────────────────────────────────

  VnDateFormatter.convertPattern1ToPatternDefault('25/03/2026');
  // → "2026-03-25"

  VnDateFormatter.convertPatternDefaultToPattern1('2026-03-25');
  // → "25/03/2026"

  VnDateFormatter.convertPatternDefaultToPatternOther(
    '2026-03-25',
    outPattern: DatePatterns.PATTERN_6,
  ); // → "25/03/2026 00:00"

  // ── Miscellaneous ────────────────────────────────────────────────────────────

  VnDateFormatter.getQuarter(DateTime(2026, 3)); // → 1
  VnDateFormatter.getQuarter(DateTime(2026, 7)); // → 3
  VnDateFormatter.convertHourToInt('09:30');     // → 930

  // ── DateTime extension ───────────────────────────────────────────────────────

  DateTime(2026, 3, 25, 15, 30, 45, 999).withoutMilliseconds();
  // → DateTime(2026, 3, 25, 15, 30, 45)
}
```

## API reference

### `DatePatterns`

| Constant          | Value                 | Example output      |
| ----------------- | --------------------- | ------------------- |
| `PATTERN_1`       | `dd/MM/yyyy`          | 25/03/2026          |
| `PATTERN_2`       | `dd/MM`               | 25/03               |
| `PATTERN_3`       | `yyyy-MM-dd'T'HHmmss` | 2026-03-25T153045   |
| `PATTERN_4`       | `h:mm a dd/MM`        | 3:30 PM 25/03       |
| `PATTERN_5`       | `yyyy-MM-dd HH:mm:ss` | 2026-03-25 15:30:45 |
| `PATTERN_6`       | `dd/MM/yyyy HH:mm`    | 25/03/2026 15:30    |
| `PATTERN_7`       | `HH:mm dd/MM/yyyy`    | 15:30 25/03/2026    |
| `PATTERN_8`       | `yyyy-MM-ddTHH:mm:ss` | 2026-03-25T15:30:45 |
| `PATTERN_9`       | `HH:mm - dd/MM/yyyy`  | 15:30 - 25/03/2026  |
| `PATTERN_10`      | `dd/MM/yyyy HH:mm:ss` | 25/03/2026 15:30:45 |
| `PATTERN_11`      | `MM/yyyy`             | 03/2026             |
| `PATTERN_12`      | `HH:mm:ss`            | 15:30:45            |
| `PATTERN_13`      | `HH:mm`               | 15:30               |
| `PATTERN_DEFAULT` | `yyyy-MM-dd`          | 2026-03-25          |

### `VnDateFormatter` — static methods

| Method                                                              | Description                      |
| ------------------------------------------------------------------- | -------------------------------- |
| `formatDateTimeToString(dt)`                                        | `dd/MM/yyyy`                     |
| `convertDateTimeToStringBE(dt, {pattern})`                          | Null-safe format for backend     |
| `formatDateTimeToStringBE(dt)`                                      | `yyyy-MM-dd HH:mm:ss`, null-safe |
| `convertDateToStringVN({dateTime})`                                 | Vietnamese long-form             |
| `convertDMYToTimeStamps(str, {pattern})`                            | String → Unix ms                 |
| `convertDateToString(dt, pattern)`                                  | Format with `vi_VN` locale       |
| `convertStringToDate(str, pattern)`                                 | Parse with `vi_VN` locale        |
| `convertDateToStringDefault(dt)`                                    | `yyyy-MM-dd`                     |
| `changeDateString(date, {pattern})`                                 | Reformat ISO string              |
| `convertPattern1ToPatternDefault(str)`                              | `dd/MM/yyyy` → `yyyy-MM-dd`      |
| `convertPatternDefaultToPattern1(str)`                              | `yyyy-MM-dd` → `dd/MM/yyyy`      |
| `convertPatternDefaultToPatternOther(str, {outPattern, inPattern})` | Arbitrary conversion             |
| `convertDateVN(str, {todayLabel, yesterdayLabel, daysAgoLabel})`    | Relative label                   |
| `convertWeekdayVN(dt, {todayLabel, yesterdayLabel, weekdayLabels})` | Weekday label                    |
| `getQuarter(dt)`                                                    | Quarter 1–4                      |
| `convertHourToInt(str)`                                             | `"09:30"` → `930`                |

### `DateTimeClean` extension

| Method                  | Description                           |
| ----------------------- | ------------------------------------- |
| `withoutMilliseconds()` | Returns copy with milliseconds zeroed |

## Integrating with GetX (or any i18n system)

The label parameters on `convertDateVN` and `convertWeekdayVN` accept any
`String`, so you can pass translated values directly:

```dart
VnDateFormatter.convertDateVN(
  dateString,
  todayLabel: LocaleKeys.home_today.tr,
  yesterdayLabel: LocaleKeys.home_yesterday.tr,
  daysAgoLabel: LocaleKeys.notification_daysAgo.tr,
);

VnDateFormatter.convertWeekdayVN(
  dateTime,
  todayLabel: LocaleKeys.home_today.tr,
  yesterdayLabel: LocaleKeys.home_yesterday.tr,
  weekdayLabels: [
    LocaleKeys.shift_monday.tr,
    LocaleKeys.shift_tuesday.tr,
    LocaleKeys.shift_wednesday.tr,
    LocaleKeys.shift_thursday.tr,
    LocaleKeys.shift_friday.tr,
    LocaleKeys.shift_saturday.tr,
    LocaleKeys.shift_sunday.tr,
  ],
);
```

## License

MIT — see [LICENSE](LICENSE).
