import 'dart:developer';

import 'package:erp_app/Screens/employee_screen.dart';
import 'package:erp_app/Screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp_app/Models/session.dart';
import '../Models/user.dart';

class EmployeeTable extends StatefulWidget {
  final Employee? userData;
  const EmployeeTable({Key? key, this.userData}) : super(key: key);

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
  late List<Session> sessionList;
  late Set<Map<String, dynamic>> sessionSet = {};
  late List<Session> uniqueList = [];
  late List<Session> queryList = [];
  bool isAscending = false;
  bool switchValue = false;

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

  @override
  void initState() {
    sessionList = widget.userData!.sessions!;
    sessionList.forEach((element) {
      sessionSet.add({
        'date': element.date,
      });
    });
    sessionSet.forEach((date) {
      Session session =
          sessionList.firstWhere((element) => element.date == date['date']);
      if (!(uniqueList.contains(session))) {
        uniqueList.add(session);
      }
    });
    selectedMonth = DateFormat.MMMM().format(DateTime.now());
    populateQueryList();
    super.initState();
  }

  populateQueryList() {
    queryList = uniqueList
        .where((session) =>
            DateFormat.MMMM().format(DateTime.parse(session.date!)) ==
            selectedMonth)
        .toList();
  }

  int filterData(DateTime date) {
    List<Session> filteredList = [];
    int totalSessionTime = 0;
    final specifiedDate = DateFormat("yyyy-MM-dd").format(date);
    filteredList =
        sessionList.where((session) => session.date == specifiedDate).toList();
    totalSessionTime = filteredList
        .map((session) => session.sessionTime)
        .fold(0, (previousValue, element) => previousValue + element!);
    return totalSessionTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Session History",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: sessionList.isEmpty
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
                        const SizedBox(
                          width: 6.0,
                        ),
                        FilterChip(
                            label: const Text("Display Less than 8 hour",
                                style: TextStyle(color: Colors.white)),
                            selected: switchValue,
                            selectedColor: Colors.green,
                            disabledColor: Colors.grey,
                            onSelected: (value) {
                              setState(() {
                                switchValue = value;
                              });
                            })
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
                                setState(() {
                                  isAscending = sortAscending;
                                  selectedMonth == null
                                      ? isAscending
                                          ? uniqueList.sort((a, b) =>
                                              DateTime.parse(a.date!).compareTo(
                                                  DateTime.parse(b.date!)))
                                          : uniqueList.sort((a, b) =>
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
                            ? uniqueList.map((session) {
                                String sessionTime =
                                    (filterData(DateTime.parse(session.date!)) /
                                            60)
                                        .toStringAsFixed(2);
                                return DataRow(selected: true, cells: [
                                  DataCell(
                                    Text('${uniqueList.indexOf(session) + 1}'),
                                  ),
                                  DataCell(
                                    Text('${session.date}'),
                                  ),
                                  DataCell(
                                    Text(sessionTime),
                                  ),
                                  DataCell(
                                    const Text('Open'),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EmployeeScreen(
                                            userData: widget.userData,
                                            dateTime:
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
                                              widget.userData!.sessions,
                                          date: DateTime.parse(session.date!),
                                        ),
                                      ),
                                    );
                                  }),
                                ]);
                              }).toList()
                            : queryList.map((session) {
                                String sessionTime =
                                    (filterData(DateTime.parse(session.date!)) /
                                            60)
                                        .toStringAsFixed(2);
                                return DataRow(
                                    color: switchValue &&
                                            (session.sessionTime! < 480)
                                        ? MaterialStateProperty.all(
                                            Colors.yellow)
                                        : MaterialStateProperty.all(
                                            Colors.transparent),
                                    cells: [
                                      DataCell(
                                        Text(
                                            '${queryList.indexOf(session) + 1}'),
                                      ),
                                      DataCell(
                                        Text('${session.date}'),
                                      ),
                                      DataCell(
                                        Text(sessionTime),
                                      ),
                                      DataCell(
                                        const Text('Open'),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EmployeeScreen(
                                                userData: widget.userData,
                                                dateTime: DateTime.parse(
                                                    session.date!),
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
                                                  widget.userData!.sessions,
                                              date:
                                                  DateTime.parse(session.date!),
                                            ),
                                          ),
                                        );
                                      })
                                    ]);
                              }).toList()),
                  ),
                ],
              )),
    );
  }
}
