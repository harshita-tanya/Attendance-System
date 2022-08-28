import 'package:erp_app/Data/location_repository.dart';
import 'package:erp_app/Models/user.dart';
import 'package:erp_app/blocs/session/bloc/session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Models/session.dart';

class EmployeeScreen extends StatefulWidget {
  final Employee? userData;
  final DateTime? dateTime;
  const EmployeeScreen({Key? key, this.userData, this.dateTime})
      : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  List<Session>? sessionData;
  List<Session>? filteredSessions;
  List<Session>? listOfSession;
  DateTime? selectedDate;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  int totalSessionTime = 0;
  DateTime? focusDay, currentDay;

  @override
  void initState() {
    sessionData = widget.userData!.sessions!;
    focusDay = widget.dateTime;
    currentDay = widget.dateTime;
    filterData(widget.dateTime!);
    super.initState();
  }

  filterData(DateTime date) {
    final specifiedDate = DateFormat("yyyy-MM-dd").format(date);
    filteredSessions =
        sessionData!.where((session) => session.date == specifiedDate).toList();
    totalSessionTime = filteredSessions!
        .map((session) => session.sessionTime)
        .fold(0, (previousValue, element) => previousValue + element!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "${widget.userData!.firstName.toString()}'s sessions",
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                      BlocProvider.of<SessionBloc>(context).add(DatePickedEvent(
                          DateFormat("yyyy-MM-dd").format(focusedDay),
                          widget.userData!));
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
                                    itemCount: filteredSessions!.length,
                                    itemBuilder: (context, index) {
                                      List<Session> currentSession = [
                                        filteredSessions![index]
                                      ];
                                      return BlocBuilder<SessionBloc, SessionState>(
                                        builder: (context, state) {
                                          if (state is PassSessionListState) {
                                            return SessionCard(
                                              userData: filteredSessions![index],
                                              date: focusDay,
                                              index: index,
                                              session: state.sessionList,
                                            );
                                          }
                                          return SessionCard(
                                            userData: filteredSessions![index],
                                            date: focusDay,
                                            index: index,
                                            session: currentSession,
                                          );
                                        },
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SessionCard extends StatelessWidget {
  final Session? userData;
  final int? index;
  final DateTime? date;
  final List<Session?>? session;
  final LocationRepository locationRepository = LocationRepository();

  SessionCard({
    this.userData,
    this.date,
    this.index,
    this.session,
    Key? key,
  }) : super(key: key);

  // initSessionList() {
  //   session!.add(userData!);
  //   // locationRepository.setMarkerList(session, date!);
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 190,
        child: Card(
          elevation: 10.0,
          color: Colors.blue,
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
                              "${DateFormat("jm").format(DateTime.parse(userData!.loginTime!))} - ${DateFormat("jm").format(DateTime.parse(userData!.logoutTime!))}",
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
                              "${userData!.locationChanges!.length} Location Detected",
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
                              "${locationRepository.getDistance([
                                    userData!
                                  ], date!)!.toStringAsFixed(2)} Km",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 8.0),
                    //   child: TextButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => MapScreen(
                    //             sessionList: session,
                    //             date: date,
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //     style: TextButton.styleFrom(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(8.0),
                    //       ),
                    //       backgroundColor: const Color(0xff3FCF8E),
                    //     ),
                    //     child: const Text(
                    //       "Location History",
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //   ),
                    // ),
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
                        "0 h ${userData!.sessionTime!} min",
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
