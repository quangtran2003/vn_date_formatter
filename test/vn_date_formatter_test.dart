import 'package:flutter_test/flutter_test.dart';
import 'package:vn_date_formatter/vn_date_formatter.dart';

void main() {
  setUpAll(() async {
    await VnDateFormatter.initialize();
  });

  // ---------------------------------------------------------------------------
  // DatePatterns
  // ---------------------------------------------------------------------------
  group('DatePatterns', () {
    test('constants have expected values', () {
      expect(DatePatterns.PATTERN_1, 'dd/MM/yyyy');
      expect(DatePatterns.PATTERN_DEFAULT, 'yyyy-MM-dd');
      expect(DatePatterns.PATTERN_5, 'yyyy-MM-dd HH:mm:ss');
      expect(DatePatterns.PATTERN_13, 'HH:mm');
    });
  });

  // ---------------------------------------------------------------------------
  // DateFormatter — basic formatting
  // ---------------------------------------------------------------------------
  group('DateFormatter.formatDateTimeToString', () {
    test('formats with PATTERN_1', () {
      final dt = DateTime(2026, 3, 25);
      expect(VnDateFormatter.formatDateTimeToString(dt), '25/03/2026');
    });
  });

  group('DateFormatter.convertDateTimeToStringBE', () {
    test('returns null for null input', () {
      expect(VnDateFormatter.convertDateTimeToStringBE(null), isNull);
    });

    test('formats with default pattern', () {
      final dt = DateTime(2026, 3, 25);
      expect(VnDateFormatter.convertDateTimeToStringBE(dt), '2026-03-25');
    });

    test('formats with custom pattern', () {
      final dt = DateTime(2026, 3, 25, 15, 30);
      expect(
        VnDateFormatter.convertDateTimeToStringBE(
          dt,
          pattern: DatePatterns.PATTERN_6,
        ),
        '25/03/2026 15:30',
      );
    });
  });

  group('DateFormatter.formatDateTimeToStringBE', () {
    test('returns null for null input', () {
      expect(VnDateFormatter.formatDateTimeToStringBE(null), isNull);
    });

    test('formats with PATTERN_5', () {
      final dt = DateTime(2026, 3, 25, 15, 30, 45);
      expect(
        VnDateFormatter.formatDateTimeToStringBE(dt),
        '2026-03-25 15:30:45',
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Timestamp helpers
  // ---------------------------------------------------------------------------
  group('DateFormatter.convertDMYToTimeStamps', () {
    test('returns 0 for empty string', () {
      expect(VnDateFormatter.convertDMYToTimeStamps(''), 0);
    });

    test('returns correct timestamp', () {
      final expected = DateTime(2026, 3, 25).millisecondsSinceEpoch;
      expect(
        VnDateFormatter.convertDMYToTimeStamps('25/03/2026'),
        expected,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // String conversions
  // ---------------------------------------------------------------------------
  group('DateFormatter.changeDateString', () {
    test('reformats ISO string to PATTERN_1', () {
      expect(
        VnDateFormatter.changeDateString('2026-03-25'),
        '25/03/2026',
      );
    });

    test('returns original string on parse failure', () {
      expect(VnDateFormatter.changeDateString('not-a-date'), 'not-a-date');
    });
  });

  group('DateFormatter.convertPattern1ToPatternDefault', () {
    test('converts dd/MM/yyyy → yyyy-MM-dd', () {
      expect(
        VnDateFormatter.convertPattern1ToPatternDefault('25/03/2026'),
        '2026-03-25',
      );
    });
  });

  group('DateFormatter.convertPatternDefaultToPattern1', () {
    test('converts yyyy-MM-dd → dd/MM/yyyy', () {
      expect(
        VnDateFormatter.convertPatternDefaultToPattern1('2026-03-25'),
        '25/03/2026',
      );
    });

    test('returns empty string for empty input', () {
      expect(VnDateFormatter.convertPatternDefaultToPattern1(''), '');
    });
  });

  group('DateFormatter.convertPatternDefaultToPatternOther', () {
    test('converts with custom patterns', () {
      expect(
        VnDateFormatter.convertPatternDefaultToPatternOther(
          '2026-03-25',
          outPattern: DatePatterns.PATTERN_2,
        ),
        '25/03',
      );
    });

    test('returns empty string for empty input', () {
      expect(VnDateFormatter.convertPatternDefaultToPatternOther(''), '');
    });
  });

  // ---------------------------------------------------------------------------
  // Relative labels
  // ---------------------------------------------------------------------------
  group('DateFormatter.convertDateVN', () {
    test('returns todayLabel for today', () {
      final today = VnDateFormatter.convertDateToStringDefault(DateTime.now());
      expect(VnDateFormatter.convertDateVN(today), 'Hôm nay');
    });

    test('returns yesterdayLabel for yesterday', () {
      final yesterday = VnDateFormatter.convertDateToStringDefault(
        DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(VnDateFormatter.convertDateVN(yesterday), 'Hôm qua');
    });

    test('returns "N ngày trước" for 3 days ago', () {
      final date = VnDateFormatter.convertDateToStringDefault(
        DateTime.now().subtract(const Duration(days: 3)),
      );
      expect(VnDateFormatter.convertDateVN(date), '3 ngày trước');
    });

    test('returns formatted date for ≥ 7 days ago', () {
      final date = VnDateFormatter.convertDateToStringDefault(
        DateTime(2026, 3, 1),
      );
      // Should fall back to dd/MM/yyyy
      expect(VnDateFormatter.convertDateVN(date), isNotEmpty);
    });

    test('accepts custom labels', () {
      final today = VnDateFormatter.convertDateToStringDefault(DateTime.now());
      expect(
        VnDateFormatter.convertDateVN(
          today,
          todayLabel: 'Today',
          yesterdayLabel: 'Yesterday',
          daysAgoLabel: 'days ago',
        ),
        'Today',
      );
    });
  });

  group('DateFormatter.convertWeekdayVN', () {
    test('returns todayLabel for null', () {
      expect(VnDateFormatter.convertWeekdayVN(null), 'Hôm nay');
    });

    test('returns todayLabel for today', () {
      expect(VnDateFormatter.convertWeekdayVN(DateTime.now()), 'Hôm nay');
    });

    test('returns yesterdayLabel for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(VnDateFormatter.convertWeekdayVN(yesterday), 'Hôm qua');
    });
  });

  // ---------------------------------------------------------------------------
  // Miscellaneous
  // ---------------------------------------------------------------------------
  group('DateFormatter.getQuarter', () {
    test('Q1: January–March', () {
      expect(VnDateFormatter.getQuarter(DateTime(2026, 1)), 1);
      expect(VnDateFormatter.getQuarter(DateTime(2026, 3)), 1);
    });

    test('Q2: April–June', () {
      expect(VnDateFormatter.getQuarter(DateTime(2026, 4)), 2);
      expect(VnDateFormatter.getQuarter(DateTime(2026, 6)), 2);
    });

    test('Q3: July–September', () {
      expect(VnDateFormatter.getQuarter(DateTime(2026, 7)), 3);
    });

    test('Q4: October–December', () {
      expect(VnDateFormatter.getQuarter(DateTime(2026, 10)), 4);
      expect(VnDateFormatter.getQuarter(DateTime(2026, 12)), 4);
    });
  });

  group('DateFormatter.convertHourToInt', () {
    test('converts HH:mm to int', () {
      expect(VnDateFormatter.convertHourToInt('09:30'), 930);
      expect(VnDateFormatter.convertHourToInt('15:00'), 1500);
    });
  });

  // ---------------------------------------------------------------------------
  // DateTimeClean extension
  // ---------------------------------------------------------------------------
  group('DateTime.withoutMilliseconds', () {
    test('strips milliseconds', () {
      final dt = DateTime(2026, 3, 25, 15, 30, 45, 999);
      final clean = dt.withoutMilliseconds();
      expect(clean.millisecond, 0);
      expect(clean.second, 45);
    });
  });
}
