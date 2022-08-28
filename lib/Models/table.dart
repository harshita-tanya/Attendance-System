import 'package:erp_app/Models/session.dart';
import 'package:intl/intl.dart';

class EmployeeTable{
  final List<Session>? sessionList;
  Set<String>? sessionDateSet;

   EmployeeTable({this.sessionList});

  filterByMonth(String month){
   return  sessionList!.where((session) =>  DateFormat.MMMM().format(DateTime.parse(session.date!)) == month).toList();
  
  }

  List<Session>? initDateSet(){
    List<Session>? uniqueList = [];
    for(var session in sessionList!){
      sessionDateSet!.add(session.date!);
    }

   for (var date in sessionDateSet!) {
      Session session = sessionList!
          .firstWhere((element) => element.date == date);
      if (!(uniqueList.contains(session))) {
        uniqueList.add(session);
      }
    }
    return uniqueList;
  }
}