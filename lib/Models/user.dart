import 'package:erp_app/Models/session.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class Employee {
  String? firstName;
  String? lastName;
  String? emailId;
  bool? isAdmin;
  List<Session>? sessions = [];

  Employee({
    this.firstName,
    this.lastName,
    this.emailId,
    this.isAdmin,
    this.sessions,
  });

  // factory Employee.fromJson(Map<String, dynamic>? json) => Employee(
  //       firstName: json!['first_name'] ?? " -- ",
  //       lastName: json['last_name'] ?? " -- ",
  //       emailId: json['email_id'] ?? " -- ",
  //       employeeID: json['employee_id'] ?? " -- ",
  //       isAdmin: json['isAdmin'],
  //       sessions: List<UserSession>.from(json['sessions'].map((session) => UserSession.fromJson(session))),
  //     );

  factory Employee.fromJson(Map<String, dynamic> map) =>
      _$EmployeeFromJson(map);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
