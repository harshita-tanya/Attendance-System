import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  String? loginTime;
  String? logoutTime;
  int? sessionTime;
  String? location;
  String? date;
  List<Map<String, dynamic>> sessionList = [];
  List<dynamic>? locationChanges;

  Session(
      {this.loginTime,
      this.logoutTime,
      this.sessionTime,
      this.location,
      this.date,
      this.locationChanges});

   addSession(Session session, String userId) {
    sessionList.add({
      "loginTime": session.loginTime,
      "logoutTime": session.logoutTime,
      "sessionDuration": session.sessionTime.toString(),
      "location": session.location,
      "date": session.date,
      "locationChanges": session.locationChanges
    });

    addSessionsToFirestore(userId);
  }

  addSessionsToFirestore(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({"sessions": FieldValue.arrayUnion(sessionList)});
  }
  
  //Session.fromJson(Map<String, dynamic> json) {
  //   loginTime = json['loginTime'] ?? "--";
  //   logoutTime = json['logoutTime'] ?? "--";
  //   sessionTime = int.parse(json['sessionDuration']);
  //   location = json['location'];
  //   date = json['date'];
  // }
  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
