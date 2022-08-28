// import 'package:erp_app/Data/authentication.dart';
// import 'package:erp_app/Models/user.dart';

// class UserEntity {
//   String? name;
//   String? emailId;
//   List<DateSession>? sessionHistory;

//   UserEntity({this.name, this.emailId, this.sessionHistory});

//   List<UserEntity> usersEntityList =
//       List.from(UserDataService().getUsersList.map((user) {
//     UserEntity entity = UserEntity(
//         name: user.name,
//         emailId: user.emailId,
//         sessionHistory: user.sessions!.map((session) {
//           DateSession dateSession = DateSession(
//               date: session.date, duration: session.sessionTime.toString());
//           return dateSession;
//         }).toList());
//     return entity;
//   }));

//   List<UserEntity> get getEntity => usersEntityList;

//   @override
//   String toString() {
//     // TODO: implement toString
//     return '{name: $name , emailId: $emailId, session: $sessionHistory}';
//   }
// }

// class DateSession {
//   final String? date;
//   final String? duration;

//   DateSession({this.date, this.duration});
// }
