import 'package:eservisnaknjiga_admin/models/search_result.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';
import 'package:eservisnaknjiga_admin/providers/reservation_provider.dart';
import 'package:eservisnaknjiga_admin/widgets/master_screen.dart';
import 'package:eservisnaknjiga_admin/models/reservation.dart';
import 'package:eservisnaknjiga_admin/utils/dialog_helpers.dart';

import '../models/data_source.dart';
import '../models/meeting.dart';

class CalendarListScreen extends StatefulWidget {
  const CalendarListScreen({super.key});

  @override
  State<CalendarListScreen> createState() => _CalendarListScreenState();
}

class _CalendarListScreenState extends State<CalendarListScreen> {
  final ReservationProvider _reservationProvider = ReservationProvider();
  SearchResult<Reservation>? result;
  final List<Meeting> _meetings = <Meeting>[];
  DataSource? _dataSource;

  @override
  void initState() {
    super.initState();
    _loadMeetings();
  }

  Future<void> _loadMeetings() async {
    await getMeetingDetails();
    setState(() {}); // osvježi prikaz
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Rezervacije",
      child: Column(
        children: [
          Expanded(
            child: _meetings.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SfCalendar(
                    view: CalendarView.week,
                    firstDayOfWeek: 1,
                    dataSource: _dataSource!,
                    showNavigationArrow: true,
                    viewHeaderHeight: 60,
                    onTap: calendarTapped,
                    timeSlotViewSettings: const TimeSlotViewSettings(
                      startHour: 6,
                      endHour: 22,
                    ),
                    appointmentBuilder: (context, details) {
                      final Meeting meeting = details.appointments.first;
                      return Tooltip(
                        message: "Status: ${meeting.status}\n"
                            "Početak: ${meeting.from}\n"
                            "${meeting.eventName}",
                        textStyle: const TextStyle(color: Colors.white),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: meeting.background,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              meeting.eventName,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void calendarTapped(CalendarTapDetails details) async {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      if (details.appointments != null && details.appointments!.isNotEmpty) {
        final dynamic firstAppointment = details.appointments!.first;

        if (firstAppointment is Meeting) {
          final Meeting meeting = firstAppointment;
          final updated = await showMeetingDialog(
            context,
            meeting,
            (updatedMeeting) async {
              try {
                final index = _meetings.indexWhere((m) => m.id == meeting.id);
                if (index != -1) {
                  if (updatedMeeting.status == 'modify') {
                    Reservation reservatio = Reservation(
                      index,
                      null,
                      updatedMeeting.from,
                      updatedMeeting.description,
                      updatedMeeting.status,
                      null,
                      null,
                    );
                    await _reservationProvider.setState(
                      updatedMeeting.id,
                      updatedMeeting.status,
                      reservatio,
                    );
                  } else {
                    await _reservationProvider.setState(
                      updatedMeeting.id,
                      updatedMeeting.status,
                    );
                  }
                }
              } catch (e) {
                showErrorDialog(context, e.toString());
              }
            },
          );

          // refreshuj prikaz ako je potrebno
          if (updated == true) {
            await _loadMeetings();
          }
        }
      }
    }
  }

  Future<List<Meeting>> getMeetingDetails() async {
    _meetings.clear();

    try {
      result = await _reservationProvider.get();
    } catch (e) {
      print(e);
    }

    result?.result.forEach((result) {
      String nazivPaketa = result.rezervacijaPaketi
              ?.map((paket) => paket.paket?.naziv)
              .whereType<String>()
              .join(" | ") ??
          "Nema paketa";

      String eventName = [
        if (result.opis?.isNotEmpty ?? false)
          "Model: ${result.automobil?.marka ?? "Nepoznato"} ${result.automobil?.model ?? ""}",
        "Paketi: $nazivPaketa",
        "Napomena: ${result.opis ?? "Nema napomene"}",
      ].join("\n");

      _meetings.add(Meeting(
        id: result.id ?? 0,
        from: result.datum ?? DateTime.now(),
        to: result.datum?.add(const Duration(hours: 2)) ?? DateTime.now(),
        background: setColorForStatus(result.status ?? ""),
        startTimeZone: '',
        endTimeZone: '',
        description: result.opis ?? "",
        isAllDay: false,
        status: result.status ?? "",
        eventName: eventName,
      ));
    });

    _dataSource = DataSource(_meetings);
    return _meetings;
  }

  Color setColorForStatus(String status) {
    switch (status) {
      case 'created':
        return Colors.grey;
      case 'accepted':
        return Colors.lightBlue;
      case 'modify':
        return Colors.yellow;
      case 'pending_payment':
        return Colors.orangeAccent;
      case 'paid_mpay':
        return Colors.green;
      case 'paid_cash':
        return Colors.greenAccent;
      default:
        return Colors.red;
    }
  }
}
