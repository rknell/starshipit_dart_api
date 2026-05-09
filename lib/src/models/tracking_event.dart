import 'package:json_annotation/json_annotation.dart';

part 'tracking_event.g.dart';

@JsonSerializable(includeIfNull: false)
class TrackingEvent {
  const TrackingEvent({this.eventDatetime, this.status, this.details});

  @JsonKey(name: 'event_datetime')
  final String? eventDatetime;

  final String? status;
  final String? details;

  factory TrackingEvent.fromJson(Map<String, dynamic> json) =>
      _$TrackingEventFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingEventToJson(this);
}
