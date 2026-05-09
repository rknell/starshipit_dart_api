// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingEvent _$TrackingEventFromJson(Map<String, dynamic> json) =>
    TrackingEvent(
      eventDatetime: json['event_datetime'] as String?,
      status: json['status'] as String?,
      details: json['details'] as String?,
    );

Map<String, dynamic> _$TrackingEventToJson(TrackingEvent instance) =>
    <String, dynamic>{
      'event_datetime': ?instance.eventDatetime,
      'status': ?instance.status,
      'details': ?instance.details,
    };
