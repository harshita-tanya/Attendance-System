// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      loginTime: json['loginTime'] as String?,
      logoutTime: json['logoutTime'] as String?,
      sessionTime: int.parse(json['sessionDuration']),
      location: json['location'] as String?,
      date: json['date'] as String?,
      locationChanges: json['locationChanges'] as List<dynamic>?,
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'loginTime': instance.loginTime,
      'logoutTime': instance.logoutTime,
      'sessionDuration': instance.sessionTime,
      'location': instance.location,
      'date': instance.date,
      'locationChanges': instance.locationChanges,
    };
