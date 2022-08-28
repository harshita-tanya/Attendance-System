import 'package:erp_app/Data/location_repository.dart';
import 'package:erp_app/Models/session.dart';
import 'package:erp_app/Models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(SessionInitial()) {
    on<DatePickedEvent>((event, emit) {
       final LocationRepository locationRepository = LocationRepository();
       List<Session?> sessionList = locationRepository.getSessionList(event.date, event.employee);
       emit(PassSessionListState(sessionList));
    });
  }
}
