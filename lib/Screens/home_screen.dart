import 'package:erp_app/Models/session.dart';
import 'package:erp_app/Models/user.dart';
import 'package:erp_app/Screens/employee_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final String? userId;
  final DateTime? loginTime;
  final Map<String, dynamic>? sessionList;
  final Employee? employee;
  const HomeScreen(
      {Key? key, this.userId, this.loginTime, this.sessionList, this.employee})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Session>? filteredSessions;
  List<Session>? sessionData;
  int totalSessionTime = 0;

  @override
  void initState() {
    sessionData = List.from(widget.employee!.sessions!);
    filterData(widget.loginTime!);
    super.initState();
  }

  filterData(DateTime date) {
    final specifiedDate = DateFormat("yyyy-MM-dd").format(date);
    filteredSessions =
        sessionData!.where((session) => session.date == specifiedDate).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your session details",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: filteredSessions!.isEmpty
            ? const Center(
                child: Text("No Data Available for this date"),
              )
            : SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredSessions!.length,
                        itemBuilder: (context, index) {
                          return filteredSessions![index] == null
                              ? const Text("No Data Available Currently")
                              : SessionCard(userData: filteredSessions![index], index: index, date: widget.loginTime,);
                              //SessionDetails(
                                //  session: filteredSessions![index]);
                        })
                  ],
                ),
              ),
      ),
    );
  }
}

class SessionDetails extends StatelessWidget {
  final Session? session;
  const SessionDetails({Key? key, this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 250.0,
        child: Card(
          elevation: 10.0,
          color: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Date",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${DateTime.parse(session!.loginTime!).day}/${DateTime.parse(session!.loginTime!).month}/${DateTime.parse(session!.loginTime!).year}",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Login Time",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${DateTime.parse(session!.loginTime!).hour}:${DateTime.parse(session!.loginTime!).minute}:${DateTime.parse(session!.loginTime!).second}",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Logout Time",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${DateTime.parse(session!.logoutTime!).hour}:${DateTime.parse(session!.logoutTime!).minute}:${DateTime.parse(session!.logoutTime!).second}",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Session Time",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${session!.sessionTime!} Minute",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Location",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "[${session!.location!.latitude}, ${session!.location!.longitude}]",
                      overflow: TextOverflow.visible,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
