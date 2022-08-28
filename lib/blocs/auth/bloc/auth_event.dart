part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent{
  final String email;
  final String password;
  final bool isValidForm;

  LoginRequested(this.email, this.password, this.isValidForm);
}

class RegisterRequested extends AuthEvent{}

class LogOutRequested extends AuthEvent{
  final Session? session;
  final String? userID;

  LogOutRequested({this.session, this.userID});
}

