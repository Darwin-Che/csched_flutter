import 'package:flutter/material.dart';

final class DateMinute {
  int minutesSinceEpoch;

  DateMinute._(this.minutesSinceEpoch);

  static DateMinute fromDateTime(DateTime dt) {
    return DateMinute._(dt.millisecondsSinceEpoch ~/ 60000);
  }

  static DateMinute now() {
    final dt = DateTime.now();
    return DateMinute.fromDateTime(dt);
  }

  static DateMinute fromInt(int m) {
    return DateMinute._(m);
  }

  static DateMinute fromTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateMinute.fromDateTime(dt);
  }

  DateTime toDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(minutesSinceEpoch * 60000);
  }

  int toInt() {
    return minutesSinceEpoch;
  }

  DateMinute afterMinutes(int m) {
    return DateMinute._(minutesSinceEpoch + m);
  }

  void addMinutes(int m) {
    minutesSinceEpoch += m;
  }

  int operator -(DateMinute other) {
    return minutesSinceEpoch - other.minutesSinceEpoch;
  }

  int localHour() {
    return DateTime.fromMillisecondsSinceEpoch(minutesSinceEpoch * 60000).hour;
  }

  int localMinute() {
    return DateTime.fromMillisecondsSinceEpoch(minutesSinceEpoch * 60000).minute;
  }

  String toHHMM() {
    return '${localHour().toString().padLeft(2, '0')}:${localMinute().toString().padLeft(2, '0')}';
  }
}