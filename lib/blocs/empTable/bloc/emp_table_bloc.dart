import 'package:erp_app/Models/session.dart';
import 'package:erp_app/Models/table.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'emp_table_event.dart';
part 'emp_table_state.dart';

class EmpTableBloc extends Bloc<EmpTableEvent, EmpTableState> {

  EmpTableBloc() : super(EmpTableInitial()) {
    on<MonthSelectedEvent>((event, emit) {
      EmployeeTable employeeTable = EmployeeTable(sessionList: event.sessions);
      List<Session> filteredList =
          employeeTable.filterByMonth(event.selectedMonth!);
      //List<Session> distinctList = employeeTable.initDateSet()!;
      //log(distinctList.toString());

      if (filteredList.isEmpty) {
        emit(
          NoDataState("No Data Available for this month.", event.selectedMonth),
        );
      } else {
        emit(EmpTableFiltered(
            filteredList: filteredList, month: event.selectedMonth));
      }
    });
  }
}
