part of 'emp_table_bloc.dart';

abstract class EmpTableState {}

class EmpTableInitial extends EmpTableState {}

class EmpTableFiltered extends EmpTableState{
  final List<Session>? filteredList;
  final String? month;

  EmpTableFiltered({this.filteredList, this.month});
}

class NoDataState extends EmpTableState{
   final String? textMessage;
   final String? month;


  NoDataState(this.textMessage, this.month);
}