import 'package:erp_app/Data/data_service.dart';
import 'package:erp_app/Models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterInitial()) {
    on<FilterClickedEvent>((event, emit) async{
      emit(Loading());
       final DataRepository dataRepository = DataRepository();
       final List<Employee?> employees = await dataRepository.getFilteredList(event.dateTime!.toString(), event.workHour!);

       emit(ShowFilterState(employees));
    });

    on<ClearFilterEvent>((event, emit) => emit(FilterInitial()));
  }
}
