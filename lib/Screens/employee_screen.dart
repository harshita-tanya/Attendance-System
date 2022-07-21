import 'dart:developer';
import 'package:erp_app/Data/location_repository.dart';
import 'package:erp_app/Screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Models/session.dart';

class EmployeeScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final DateTime? dateTime;
  const EmployeeScreen({Key? key, this.userData, this.dateTime})
      : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  List<Map<String, dynamic>>? sessionData;
  List<Map<String, dynamic>>? filteredSessions;
  DateTime? selectedDate;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  int totalSessionTime = 0;
  DateTime? focusDay, currentDay;

  @override
  void initState() {
    sessionData = List.from(widget.userData!['sessions']);
    focusDay = widget.dateTime;
    currentDay = widget.dateTime;
    filterData(widget.dateTime!);
    log(widget.userData.toString());
    super.initState();
  }

  filterData(DateTime date) {
    final specifiedDate = DateFormat("yyyy-MM-dd").format(date);
    filteredSessions = sessionData!
        .where((session) => session['date'] == specifiedDate)
        .toList();
    totalSessionTime = filteredSessions!
        .map((session) => Session.fromJson(session).sessionTime)
        .fold(0, (previousValue, element) => previousValue + element!);
    log(totalSessionTime.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.userData!['name'].toString()}'s sessions"),
      ),
      body: SafeArea(
        child: Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TableCalendar(
                firstDay: DateTime(2022, 1, 1),
                lastDay: DateTime(2022, 12, 31),
                focusedDay: focusDay!,
                currentDay: currentDay,
                calendarFormat: _calendarFormat,
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonShowsNext: false,
                ),
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                calendarBuilders: CalendarBuilders(
                  selectedBuilder: (context, date, focusedDay) {
                    return Container(
                        margin: const EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        ));
                  },
                ),
                onDaySelected: (date, focusedDay) {
                  setState(() {
                    focusDay = focusedDay;
                    currentDay = date;
                    filterData(date);
                  });
                },
                startingDayOfWeek: StartingDayOfWeek.monday,
                onPageChanged: (focusedDay) {
                  focusDay = focusedDay;
                },
              ),
              filteredSessions!.isEmpty
                  ? const Center(
                      child: Text("No Data Available for this date."),
                    )
                  : Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Total Working Hour: ${(totalSessionTime / 60).toStringAsFixed(2)} Hour",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20.0),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "No. of Logins: ${filteredSessions!.length}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20.0),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                                //shrinkWrap: true,
                                itemCount: filteredSessions!.length,
                                itemBuilder: (context, index) {
                                  return SessionCard(
                                    userData: filteredSessions![index],
                                    date: currentDay,
                                    index: index,
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class SessionCard extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final int? index;
  final DateTime? date;
  List<Session>? session = [];
  LocationRepository locationRepository = LocationRepository();

  SessionCard({
    this.userData,
    this.date,
    this.index,
    Key? key,
  }) : super(key: key);

  initSessionList() {
    session!.add(Session.fromJson(userData!));
    locationRepository.setMarkerList(session, date!);
  }

  @override
  Widget build(BuildContext context) {
    initSessionList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 190,
        child: Card(
          elevation: 10.0,
          color: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.alarm,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              "${DateFormat("jm").format(DateTime.parse(userData!['loginTime']))} - ${DateFormat("jm").format(DateTime.parse(userData!['logoutTime']))}",
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "${userData!['locationChanges'].length} Location Detected",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.timeline,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "${locationRepository.getDistance()!.toStringAsFixed(2)} Km",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextButton(
                        onPressed: () {
                          log(session![0].locationChanges.toString());
                          log(date.toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(
                                sessionList: session,
                                date: date,
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: const Color(0xff3FCF8E),
                        ),
                        child: const Text(
                          "Location History",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const VerticalDivider(
                      color: Colors.white,
                      thickness: 1.0,
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "0 h ${userData!['sessionDuration']!} min",
                        style: const TextStyle(
                            fontSize: 25.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
