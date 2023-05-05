// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_change.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleChange _$SingleChangeFromJson(Map<String, dynamic> json) => SingleChange(
      label: json['label'] as String,
      code: json['code'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$SingleChangeToJson(SingleChange instance) =>
    <String, dynamic>{
      'label': instance.label,
      'code': instance.code,
      'value': instance.value,
    };
