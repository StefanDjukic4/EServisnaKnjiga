import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meeting.dart';
import '../screens/work_order_detail_screen.dart';
import '../providers/reservation_provider.dart';

Future<bool> showMeetingDialog(
    BuildContext context, Meeting meeting, ValueChanged<Meeting> onSave) async {
  final reservationProvider =
      Provider.of<ReservationProvider>(context, listen: false);
  final List<String> allowedActions =
      await reservationProvider.getAllowedActions(meeting.id);

  if (allowedActions.isEmpty) {
    showInfoDialog(context, 'Nijedna akcija nije dozvoljena za ovaj termin.');
    return false;
  }

  DateTime newFrom = meeting.from;
  String newEventName = meeting.eventName;
  String newDescription = meeting.description;
  String selectedAction = meeting.status;

  Map<String, String> actionTitles = {
    'accepted': 'Prihvati',
    'canceled': 'Odbi',
    'modify': 'Predlog novog termina',
  };

  Future<void> _selectDateTime(DateTime initialDateTime,
      ValueChanged<DateTime> onDateTimeChanged) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        onDateTimeChanged(DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        ));
      }
    }
  }

  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Izmjeni status termina'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: allowedActions
                        .map((value) => RadioListTile<String>(
                              title: Text(actionTitles[value] ?? value),
                              value: value,
                              groupValue: selectedAction,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedAction = newValue;
                                  });
                                }
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Odustani'),
              ),
              TextButton(
                onPressed: () async {
                  if (selectedAction == 'modify' &&
                      (meeting.status == 'canceled' ||
                          meeting.status == 'accepted')) {
                    showErrorDialog(context,
                        'Exception: {"errors":{"ERROR":["Izmjena statusa nije dozvoljena"]}}');
                  } else {
                    if (selectedAction == 'modify') {
                      await _selectDateTime(newFrom, (dateTime) {
                        newFrom = dateTime;
                      });
                    }

                    final updatedMeeting = Meeting(
                      id: meeting.id,
                      from: newFrom,
                      to: newFrom.add(const Duration(hours: 2)),
                      background: setColorForStatus(selectedAction),
                      isAllDay: meeting.isAllDay,
                      eventName: newEventName,
                      startTimeZone: meeting.startTimeZone,
                      endTimeZone: meeting.endTimeZone,
                      description: newDescription,
                      status: selectedAction,
                    );

                    onSave(updatedMeeting);
                    Navigator.of(context).pop(false); // nije potreban refresh
                  }
                },
                child: const Text('Sacuvaj'),
              ),
              if (meeting.status == 'accepted')
                TextButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkOrderScreen(id: meeting.id),
                      ),
                    );

                    if (result == true) {
                      Navigator.of(context).pop(true); // signal za refresh
                    }
                  },
                  child: const Text('Kreiraj nalog'),
                ),
            ],
          );
        },
      );
    },
  ).then((value) => value ?? false);
}

Color setColorForStatus(String status) {
  if (status == 'created') return Colors.grey;
  if (status == 'accepted') return Colors.lightBlue;
  if (status == 'modify') return Colors.yellow;
  if (status == 'pending_payment') return Colors.orangeAccent;
  if (status == 'paid_mpay') return Colors.green;
  if (status == 'paid_cash') return Colors.greenAccent;
  return Colors.red;
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

void showInfoDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Info'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
