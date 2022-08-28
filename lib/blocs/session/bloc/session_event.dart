part of 'session_bloc.dart';

abstract class SessionEvent {}

class DatePickedEvent extends SessionEvent{
  final String date;
  final Employee employee;

  DatePickedEvent(this.date, this.employee);
}