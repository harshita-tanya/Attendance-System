part of 'emp_table_bloc.dart';

abstract class EmpTableEvent {}

class MonthSelectedEvent extends EmpTableEvent{
  final List<Session>? sessions;
  final String? selectedMonth;

  MonthSelectedEvent(this.sessions, this.selectedMonth);
}
