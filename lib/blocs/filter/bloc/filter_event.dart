part of 'filter_bloc.dart';

abstract class FilterEvent {}

class FilterClickedEvent extends FilterEvent{
  final DateTime? dateTime;
  final String? workHour;

  FilterClickedEvent({this.dateTime, this.workHour});
}

class ClearFilterEvent extends FilterEvent{}