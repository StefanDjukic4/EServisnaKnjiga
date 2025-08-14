import 'package:flutter/material.dart';

class Meeting {
  Meeting({
    required this.from,
    required this.to,
    this.background = Colors.green,
    this.isAllDay = false,
    this.eventName = '',
    this.startTimeZone = '',
    this.endTimeZone = '',
    this.description = '',
    this.status = '',
    required this.id,
  });

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String startTimeZone;
  String endTimeZone;
  String description;
  String status;
  int id;
}
