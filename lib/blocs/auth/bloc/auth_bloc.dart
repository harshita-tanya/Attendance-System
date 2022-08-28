import 'package:erp_app/Data/authentication.dart';
import 'package:erp_app/Data/data_service.dart';
import 'package:erp_app/Models/session.dart';
import 'package:erp_app/Models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(LoadingState());

      try {
        String? uid = await _authService.login(email: event.email, password: event.password);
        if (uid != null &&
            uid != "No User Found" &&
            uid != "Invalid Password !") {
         Employee? employee =
              await DataRepository().fetchUserDocument(uid);
          bool isAdmin = employee!.isAdmin!;
          emit(AuthSuccessState(isAdmin, event.isValidForm, uid, employee));
        } else {
          emit(AuthFailureState(uid));
        }
      } catch (error) {
        emit(AuthFailureState(error.toString()));
      }
    });

    on<LogOutRequested>((event, emit) async{
      emit(LoadingState());

      try{
        _authService.signOutUser(event.session!, event.userID!);
        emit(SignOutState());
      }catch(error){
        emit(AuthFailureState(error.toString()));
      }
    });
  }
}
