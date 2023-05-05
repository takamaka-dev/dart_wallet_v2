import 'package:json_annotation/json_annotation.dart';

part 'single_change.g.dart';

@JsonSerializable()
class SingleChange {
  final String label;
  final String code;
  final double value;

  SingleChange({required this.label, required this.code, required this.value});

  factory SingleChange.fromJson(Map<String, dynamic> json) =>
      _$SingleChangeFromJson(json);
  Map<String, dynamic> toJson() => _$SingleChangeToJson(this);
}