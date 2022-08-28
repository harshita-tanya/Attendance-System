import 'dart:async';
import 'dart:developer';
import 'package:erp_app/Models/session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_app/Models/table.dart';
import 'package:erp_app/Screens/login_screen.dart';
import 'package:erp_app/Screens/map_screen.dart';
import 'package:erp_app/Screens/projects_screen.dart';
import 'package:erp_app/blocs/auth/bloc/auth_bloc.dart';
import 'package:erp_app/blocs/empTable/bloc/emp_table_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import '../Data/authentication.dart';
import '../Data/location.dart';
import '../Models/user.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';

class UserTable extends StatefulWidget {
  final String? userId;
  final DateTime? loginTime;
  final Employee? employee;
  const UserTable({Key? key, this.loginTime, this.userId, this.employee})
      : super(key: key);

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  late List<Map<String, dynamic>> sessionList;
  Set<String> sessionSet = {};
  List<Session>? uniqueList = [];
  List<Session> queryList = [];
  List<GeoPoint> locationHistory = [];
  TextEditingController newPasswordController = TextEditingController();
  Location location = Location();
  late LocationData locationData;
  late StreamSubscription<LocationData> locationStream;
  late EmployeeTable table;

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
  List<Session> distinctList = [];
  bool isAscending = false;

  @override
  void initState() {
    selectedMonth = monthList[DateTime.now().month - 1];
    findCurrentLocation();
    locationStream = location.onLocationChanged.listen((currentLocation) {
      locationHistory.add(
        GeoPoint(currentLocation.latitude!, currentLocation.longitude!),
      );
    });
    table = EmployeeTable(sessionList: widget.employee!.sessions);
    initUniqueList();
    super.initState();
  }

  findCurrentLocation() async {
    locationData = await LocationService().getLocation();
    locationHistory.add(
      GeoPoint(locationData.latitude!, locationData.longitude!),
    );
  }

  initUniqueList() {
    for (var session in widget.employee!.sessions!) {
      sessionSet.add(session.date!);
    }

    for (var date in sessionSet) {
      Session session = widget.employee!.sessions!
          .firstWhere((element) => element.date == date);
      if (!(distinctList.contains(session))) {
        distinctList.add(session);
      }
    }
    log(distinctList.toString());
  }

  populateQueryList() {
    queryList = distinctList
        .where((session) =>
            DateFormat.MMMM().format(DateTime.parse(session.date!)) ==
            selectedMonth)
        .toList();
  }

  int filterData(DateTime date) {
    List<Session> filteredList = [];
    int totalSessionTime = 0;
    final specifiedDate = DateFormat("yyyy-MM-dd").format(date);
    filteredList = widget.employee!.sessions!
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<EmpTableBloc>(
          create: (context) => EmpTableBloc(),
        ),
      ],
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignOutState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Session's Table",
                  style: TextStyle(color: Colors.black),
                ),
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
                backgroundColor: Colors.transparent,
              ),
              drawer: Drawer(
                child: SafeArea(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(LogOutRequested(
                            session: Session(
                              date: DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()),
                              loginTime: widget.loginTime.toString(),
                              logoutTime: DateTime.now().toString(),
                              location: GeoPoint(locationData.latitude!,
                                  locationData.longitude!),
                              sessionTime: DateTime.now()
                                  .difference(widget.loginTime!)
                                  .inMinutes,
                              locationChanges: locationHistory.toSet().toList(),
                            ),
                            userID: widget.userId,
                          ));

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
                                          validator: (password) => password!
                                                      .length <
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
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        child: TextButton(
                                          onPressed: () {
                                            String newPassword =
                                                newPasswordController.text;
                                            AuthRepository.changePassword(
                                                newPassword);
                                            newPasswordController.clear();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen()));
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
                                                color: Colors.white,
                                                fontSize: 18),
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
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BlocBuilder<EmpTableBloc, EmpTableState>(
                            builder: (context, state) {
                              if (state is EmpTableFiltered) {
                                return MonthDropDown(
                                    selectedMonth: state.month,
                                    sessionList: widget.employee!.sessions,
                                    monthList: monthList);
                              } else if (state is NoDataState) {
                                return MonthDropDown(
                                    selectedMonth: state.month,
                                    sessionList: widget.employee!.sessions,
                                    monthList: monthList);
                              }
                              return MonthDropDown(
                                selectedMonth: selectedMonth,
                                monthList: monthList,
                                sessionList: widget.employee!.sessions,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: BlocConsumer<EmpTableBloc, EmpTableState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          if (state is EmpTableFiltered) {
                            return DataTable(
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
                                                  ? distinctList.sort(
                                                      (a, b) => DateTime.parse(
                                                              a.date!)
                                                          .compareTo(
                                                        DateTime.parse(b.date!),
                                                      ),
                                                    )
                                                  : distinctList.sort((a, b) =>
                                                      DateTime.parse(b.date!)
                                                          .compareTo(DateTime.parse(
                                                              a.date!)))
                                              : isAscending
                                                  ? queryList.sort((a, b) => DateTime.parse(a.date!).compareTo(
                                                      DateTime.parse(b.date!)))
                                                  : queryList.sort((a, b) =>
                                                      DateTime.parse(b.date!).compareTo(
                                                          DateTime.parse(a.date!)));
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
                                rows: state.filteredList!.map((session) {
                                  return DataRow(cells: [
                                    DataCell(
                                      Text(
                                          '${state.filteredList!.indexOf(session) + 1}'),
                                    ),
                                    DataCell(
                                      Text('${session.date}'),
                                    ),
                                    DataCell(
                                      Text(((session.sessionTime)! / 60)
                                          .toStringAsFixed(2)),
                                    ),
                                    DataCell(
                                      const Text('Open'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeScreen(
                                              employee: widget.employee,
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
                                                widget.employee!.sessions,
                                            date: DateTime.parse(session.date!),
                                          ),
                                        ),
                                      );
                                    })
                                  ]);
                                }).toList());
                          }
                          if (state is NoDataState) {
                            return Center(
                              child: Text(state.textMessage!),
                            );
                          }
                          return DataTable(
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
                                        isAscending
                                            ? distinctList.sort(
                                                (a, b) =>
                                                    DateTime.parse(a.date!)
                                                        .compareTo(
                                                  DateTime.parse(b.date!),
                                                ),
                                              )
                                            : distinctList.sort((a, b) =>
                                                DateTime.parse(b.date!)
                                                    .compareTo(DateTime.parse(
                                                        a.date!)));
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
                              rows: distinctList.map((session) {
                                return DataRow(cells: [
                                  DataCell(Text(
                                      "${distinctList.indexOf(session) + 1}")),
                                  DataCell(Text("${session.date}")),
                                  DataCell(Text((session.sessionTime! / 60)
                                      .toStringAsFixed(2))),
                                  DataCell(const Text("Open"), onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen(
                                                  employee: widget.employee,
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
                                              widget.employee!.sessions,
                                          date: DateTime.parse(session.date!),
                                        ),
                                      ),
                                    );
                                  }),
                                ]);
                              }).toList());
                          ;
                        },
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}

class MonthDropDown extends StatelessWidget {
  const MonthDropDown(
      {Key? key,
      required this.selectedMonth,
      required this.monthList,
      required this.sessionList})
      : super(key: key);

  final String? selectedMonth;
  final List<String> monthList;
  final List<Session>? sessionList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            BlocProvider.of<EmpTableBloc>(context)
                .add(MonthSelectedEvent(sessionList, value));
          }),
    );
  }
}
