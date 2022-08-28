part of 'filter_bloc.dart';

abstract class FilterState {}

class FilterInitial extends FilterState {}

class ShowFilterState extends FilterState{
  List<Employee?> filteredEmployees;

  ShowFilterState(this.filteredEmployees);
}

class Loading extends FilterState{}