import 'package:dart_wallet_v2/config/api/single_change.dart';
import 'package:json_annotation/json_annotation.dart';

part 'changes.g.dart';

@JsonSerializable()
class Changes {
  final List<SingleChange> changes;

  Changes({required this.changes});

  factory Changes.fromJson(Map<String, dynamic> json) =>
      _$ChangesFromJson(json);

  Map<String, dynamic> toJson() => _$ChangesToJson(this);
}
