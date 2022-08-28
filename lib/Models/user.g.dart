// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      firstName: json['name'] as String?,
      lastName: json['last_name'] as String?,
      emailId: json['email_id'] as String?,
      isAdmin: json['isAdmin'] as bool?,
      sessions: (json['sessions'] as List<dynamic>?)
          ?.map((e) => Session.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'name': instance.firstName,
      'last_name': instance.lastName,
      'email_id': instance.emailId,
      'isAdmin': instance.isAdmin,
      'sessions': instance.sessions,
    };
