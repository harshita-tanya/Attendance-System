import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_app/Models/session.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';
import '../Models/user.dart';

class DataRepository {
  List<Employee> _employees = [];
  List<Employee?> _filterList = [];

  Future<Map<String, dynamic>?> fetchUserDocument(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final Map<String, dynamic>? userData = snapshot.data();
    return userData;
  }

  initialiseList(List<Map<String, dynamic>> snapshot) {
    List<Map<String, dynamic>> users = snapshot;
    _employees = users.map((user) => Employee.fromJson(user)).toList();
  }

  List<Employee?> getEmployeeList() {
    return _employees;
  }

  List<Employee?> filterOnWorkHour(
      bool isChoice1Selected, bool isChoice2Selected, DateTime? date) {
    _filterList = _employees.map((employee) {
      List<Session>? sessionList = employee.sessions;
      List<Session> filterWorkList = sessionList!
          .where((session) => (session.sessionTime! > 0 &&
              session.date ==
                  DateFormat('yyyy-MM-dd').format(date ?? DateTime.now())))
          .toList();

      if (filterWorkList.isNotEmpty) {
        return employee;
      }
    }).toList();
    _filterList.removeWhere((element) => [null].contains(element));

    log(_filterList.toString());
    return _filterList;
  }
}
