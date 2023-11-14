import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Metatransaction extends Table {
  TextColumn get jsonhash => text().withLength(min: 6, max: 255)();
  DateTimeColumn get created => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get solved => dateTime().nullable()();
  BoolColumn get isSolved => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Metatransaction])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await FileSystemUtils.getWalletDir('wallets');
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
