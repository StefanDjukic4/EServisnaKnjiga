import 'package:flutter/material.dart';

class Meeting {
  Meeting({
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.isAllDay,
  });

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
