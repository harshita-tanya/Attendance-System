// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      loginTime: json['loginTime'] as String?,
      logoutTime: json['logoutTime'] as String?,
      sessionTime: json['sessionDuration'] as int?,
      date: json['date'] as String?,
      location: json['location'] as GeoPoint,
      locationChanges: (json['locationChanges'] as List<dynamic>?)
          ?.map((e) => e as GeoPoint)
          .toList(),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'loginTime': instance.loginTime,
      'logoutTime': instance.logoutTime,
      'sessionDuration': instance.sessionTime,
      'location': instance.location,
      'date': instance.date,
      'locationChanges': instance.locationChanges,
    };
