import 'dart:async';
import 'dart:developer';
import 'package:erp_app/Models/session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_app/Screens/login_screen.dart';
import 'package:erp_app/Screens/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import '../Data/authentication.dart';
import '../Data/location.dart';
import '../Models/user.dart';
import 'home_screen.dart';

class UserTable extends StatefulWidget {
  final String? userId;
  final DateTime? loginTime;
  final Map<String, dynamic>? userData;
  const UserTable({Key? key, this.loginTime, this.userId, this.userData})
      : super(key: key);

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  late List<Map<String, dynamic>> sessionList;
  Set<String> sessionSet = {};
  List<Session> uniqueList = [];
  List<Session> queryList = [];
  Session session = Session();
  DateTime? logoutTime;
  List<String> locationHistory = [];
  String? locationGeopoint;
  TextEditingController newPasswordController = TextEditingController();
  late LocationData locationData;
  Location location = Location();
  late StreamSubscription<LocationData> locationStream;
  DocumentSnapshot<Map<String, dynamic>>? snapshot;

  List<String> monthList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  String? selectedMonth;
  Employee employee = Employee();
  List<Session> DistinctList = [];
  bool isAscending = false;

  @override
  void initState() {
    findCurrentLocation();
    locationStream = location.onLocationChanged.listen((currentLocation) {
      //log(currentLocation.latitude.toString());
      locationHistory
          .add("(${currentLocation.latitude}, ${currentLocation.longitude})");
    });
    readData();
    super.initState();
  }

  readData() {
    employee = Employee.fromJson(widget.userData!);
    initUniqueList();
  }

  findCurrentLocation() async {
    locationData = await LocationService().getLocation();
    //log(locationData.toString());
    locationHistory.add(
        "(${locationData.latitude.toString()}, ${locationData.longitude.toString()})");
    locationGeopoint = "${locationData.latitude}, ${locationData.longitude}";
  }

  initUniqueList() async {
    employee.sessions!.forEach((element) {
      sessionSet.add(element.date!);
    });
    log(sessionSet.toString());
    sessionSet.forEach((date) {
      Session session =
          employee.sessions!.firstWhere((element) => element.date == date);
      if (!(DistinctList.contains(session))) {
        DistinctList.add(session);
      }
    });
  }

  populateQueryList() {
    queryList = DistinctList.where((session) =>
        DateFormat.MMMM().format(DateTime.parse(session.date!)) ==
        selectedMonth).toList();
  }

  int filterData(DateTime date) {
    List<Session> filteredList = [];
    int totalSessionTime = 0;
    final specifiedDate = DateFormat("yyyy-MM-dd").format(date);
    filteredList = employee.sessions!
        .where((session) => session.date == specifiedDate)
        .toList();
    return totalSessionTime;
  }

  @override
  void dispose() {
    locationStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Session's Table"),
          actions: const [
            Icon(Icons.share),
          ],
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    logoutTime = DateTime.now();
                    Set? history = locationHistory.toSet();
                    //log(history.toList().toString());

                    int? sessionDuration =
                        logoutTime?.difference(widget.loginTime!).inMinutes;
                    session.loginTime = widget.loginTime.toString();
                    session.logoutTime = DateTime.now().toString();
                    session.sessionTime = sessionDuration;
                    session.location = locationGeopoint;
                    session.locationChanges = history.toList();
                    session.date = DateFormat('yyyy-MM-dd').format(logoutTime!);

                    FirebaseAuth.instance.signOut().then((value) {
                      session.addSession(session, widget.userId!);
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.arrow_back),
                    title: Text(
                      "Sign Out",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 250.0,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Enter your new password",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: newPasswordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      hintText: 'Password',
                                      suffixIcon: Icon(Icons.lock),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                    validator: (password) => password!.length <
                                            8
                                        ? "Password length must be atleast 8 characters"
                                        : null,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                SizedBox(
                                  height: 56.0,
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: TextButton(
                                    onPressed: () {
                                      String newPassword =
                                          newPasswordController.text;
                                      AuthRepository.changePassword(
                                          newPassword);
                                      newPasswordController.clear();
                                    },
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      backgroundColor: Colors.black,
                                    ),
                                    child: const Text(
                                      "Sign In",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: const ListTile(
                    leading: Icon(Icons.lock_clock),
                    title: Text(
                      "Change Password",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: employee.sessions!.isEmpty
            ? const Center(
                child: Text("No Data Available"),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50.0,
                            child: DropdownButton<String>(
                                hint: const Text('Select Month'),
                                value: selectedMonth,
                                items: monthList
                                    .map(
                                      (month) => DropdownMenuItem(
                                        value: month,
                                        child: Text(month),
                                      ),
                                    )
                                    .toList(),
                                //isExpanded: true,
                                iconSize: 36,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    selectedMonth = value;
                                    populateQueryList();
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          sortAscending: isAscending,
                          sortColumnIndex: 1,
                          columns: [
                            const DataColumn(
                              label: Text("Sr. No"),
                            ),
                            DataColumn(
                                label: const Text("Date"),
                                onSort: (index, sortAscending) {
                                  isAscending = sortAscending;
                                  setState(() {
                                    selectedMonth == null
                                        ? isAscending
                                            ? DistinctList.sort((a, b) =>
                                                DateTime.parse(a.date!).compareTo(
                                                    DateTime.parse(b.date!)))
                                            : DistinctList.sort((a, b) =>
                                                DateTime.parse(b.date!).compareTo(
                                                    DateTime.parse(a.date!)))
                                        : isAscending
                                            ? queryList.sort((a, b) =>
                                                DateTime.parse(a.date!).compareTo(
                                                    DateTime.parse(b.date!)))
                                            : queryList.sort(
                                                (a, b) => DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));
                                  });
                                }),
                            const DataColumn(
                              label: Text("Total login hours"),
                            ),
                            const DataColumn(
                              label: Text("Login History"),
                            ),
                            const DataColumn(
                              label: Text("Location History"),
                            ),
                          ],
                          rows: selectedMonth == null
                              ? DistinctList.map((session) {
                                  return DataRow(cells: [
                                    DataCell(Text(
                                        "${DistinctList.indexOf(session) + 1}")),
                                    DataCell(Text("${session.date}")),
                                    DataCell(Text((session.sessionTime! / 60)
                                        .toStringAsFixed(2))),
                                    DataCell(const Text("Open"), onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                    employee: employee,
                                                    loginTime: DateTime.parse(
                                                        session.date!),
                                                  )));
                                    }),
                                    DataCell(const Text("Open"), onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MapScreen(
                                                  sessionList:
                                                      employee.sessions,
                                                  date: DateTime.parse(
                                                      session.date!))));
                                    }),
                                  ]);
                                }).toList()
                              : queryList.map((session) {
                                  return DataRow(cells: [
                                    DataCell(
                                      Text('${queryList.indexOf(session) + 1}'),
                                    ),
                                    DataCell(
                                      Text('${session.date}'),
                                    ),
                                    DataCell(
                                      Text((filterData(DateTime.parse(
                                                  session.date!)) /
                                              60)
                                          .toStringAsFixed(2)),
                                    ),
                                    DataCell(
                                      const Text('Open'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeScreen(
                                              employee: employee,
                                              loginTime:
                                                  DateTime.parse(session.date!),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    DataCell(const Text('Open'), onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MapScreen(
                                                  sessionList:
                                                      employee.sessions,
                                                  date: DateTime.parse(
                                                      session.date!))));
                                    })
                                  ]);
                                }).toList()),
                    ),
                  ],
                )));
  }
}
