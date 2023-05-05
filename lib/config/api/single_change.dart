import 'package:json_annotation/json_annotation.dart';

part 'single_change.g.dart';

@JsonSerializable()
class SingleChange {
  final String name;
  final int age;

  SingleChange({required this.name, required this.age});

  factory SingleChange.fromJson(Map<String, dynamic> json) =>
      _$SingleChangeFromJson(json);
  Map<String, dynamic> toJson() => _$SingleChangeToJson(this);
}