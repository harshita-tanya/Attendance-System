import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_app/Models/session.dart';
import 'package:intl/intl.dart';
import '../Models/user.dart';

class DataRepository {
  List<Employee> _employees = [];
  List<Employee?> _filterList = [];

  Future<Employee?> fetchUserDocument(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final Map<String, dynamic>? userData = snapshot.data();

    return Employee.fromJson(userData!);
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

  Future<List<Employee?>> getFilteredList(String date, String query) async{
    List<Employee?> filteredEmployees = [];
    final List<Employee> allEmployees = await FirebaseFirestore.instance.collection('users').get().then(
        (value) =>
            value.docs.map((doc) => Employee.fromJson(doc.data())).toList());
    if(query == "More"){
     filteredEmployees = allEmployees.map((employee){
      if(employee.sessions!.isNotEmpty){
         for(var session in employee.sessions!.where((session) => session.date == DateFormat("yyyy-MM-dd").format(DateTime.parse(date))).toList()){
            if(session.sessionTime! > 8){
              return employee;
            }
         }
      }
     }).toList();
    }else if(query == "Less"){
      filteredEmployees = allEmployees.map((employee){
      if(employee.sessions!.isNotEmpty){
         for(var session in employee.sessions!.where((session) => session.date == DateFormat("yyyy-MM-dd").format(DateTime.parse(date))).toList()){
            if(session.sessionTime! < 8){
              return employee;
            }
         }
      }
     }).toList();
    }

    List<Employee> finalList = [];
    for(var employee in filteredEmployees){
      if(![null].contains(employee)){
        finalList.add(employee!);
      }
    }
    log(finalList.toString());
    return finalList;
  }
}
