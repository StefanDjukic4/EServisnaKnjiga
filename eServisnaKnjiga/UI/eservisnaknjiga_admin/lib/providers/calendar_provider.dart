import 'package:eservisnaknjiga_admin/models/calendar.dart';
import 'package:flutter/material.dart';

class CalendarProvider with ChangeNotifier {
  List<Meeting> _meetings = [];

  List<Meeting> get meetings => _meetings;

  void addMeeting({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
  }) {
    _meetings.add(Meeting(
      eventName: title,
      from: startTime,
      to: endTime,
      background: Colors.blue,
      isAllDay: false,
    ));
    notifyListeners();
  }

  void updateMeeting(
    Meeting oldMeeting, {
    required String title,
    required DateTime startTime,
    required DateTime endTime,
  }) {
    final index = _meetings.indexWhere(
      (meeting) => meeting.from == oldMeeting.from,
    );
    if (index != -1) {
      _meetings[index] = Meeting(
        eventName: title,
        from: startTime,
        to: endTime,
        background: Colors.blue,
        isAllDay: false,
      );
      notifyListeners();
    }
  }
}
