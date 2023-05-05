// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Changes _$ChangesFromJson(Map<String, dynamic> json) => Changes(
      objects: (json['objects'] as List<dynamic>)
          .map((e) => SingleChange.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChangesToJson(Changes instance) => <String, dynamic>{
      'objects': instance.objects,
    };
