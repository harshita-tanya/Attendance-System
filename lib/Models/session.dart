import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  String? loginTime;
  String? logoutTime;
  GeoPoint? location;
  int? sessionTime;
  String? date;
  List<Map<String, dynamic>> sessionList = [];
  List<GeoPoint>? locationChanges;

  Session(
      {this.loginTime,
      this.logoutTime,
      this.sessionTime,
      this.location,
      this.date,
      this.locationChanges
    });

   addSession(Session session, String userId) {
    
    sessionList.add({
      "loginTime": session.loginTime,
      "logoutTime": session.logoutTime,
      "sessionDuration": session.sessionTime,
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

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
