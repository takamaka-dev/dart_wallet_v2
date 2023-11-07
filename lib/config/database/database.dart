import 'package:drift/drift.dart';

part 'database.g.dart';

class Metatransaction extends Table {
  TextColumn get jsonhash => text().withLength(min: 6, max: 32)();
  DateTimeColumn get created => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get solved => dateTime().nullable()();
  BoolColumn get isSolved => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Metatransaction])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => throw UnimplementedError();
}