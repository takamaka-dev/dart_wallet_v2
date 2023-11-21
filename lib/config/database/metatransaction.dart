import 'dart:io';
import 'package:hive/hive.dart';

part 'metatransaction.g.dart';

@HiveType(typeId: 1)
class Metatransaction {

  Metatransaction(this.jsonHash, this.creationTimestamp, this.isSolved);

  @HiveField(0, defaultValue: "")
  String jsonHash;

  @HiveField(1)
  DateTime creationTimestamp;

  @HiveField(2)
  bool isSolved;


}