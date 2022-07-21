part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoadingState extends AuthState{}

class AuthSuccessState extends AuthState{
  final bool? isAdmin;
  final bool? isValidForm;
  final String? uid;
  final Map<String, dynamic>? data;

  AuthSuccessState(this.isAdmin, this.isValidForm, this.uid, this.data);
}

class AuthFailureState extends AuthState{
  final String? errorMessage;

  AuthFailureState(this.errorMessage);
}