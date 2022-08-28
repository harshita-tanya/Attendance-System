part of 'session_bloc.dart';

abstract class SessionState {}

class SessionInitial extends SessionState {}

class PassSessionListState extends SessionState{
  final List<Session?> sessionList;

  PassSessionListState(this.sessionList);
}