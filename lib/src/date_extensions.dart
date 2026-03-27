/// Extension on [DateTime] providing convenience helpers.
extension DateTimeClean on DateTime {
  /// Returns a copy of this [DateTime] with the milliseconds set to zero.
  DateTime withoutMilliseconds() =>
      DateTime(year, month, day, hour, minute, second);
}
