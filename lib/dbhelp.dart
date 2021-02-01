import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DbHelp {
  static final String tname = "Dictionary";

  static Database dbExists;

  Future<Database> get db async {
    if (dbExists != null) {
      print('dbstatus' + 'Db already exists');
      return dbExists;
    } else {
      dbExists = await initDb();
      return dbExists;
    }
  }

  Future initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sample.db');

    final exists = await databaseExists(path);

    if (!exists) {
      print('dbstatus' + 'Creating new copy from assets');

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join('assets', 'sample.db'));
      List<int> byte =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(byte, flush: true);
    } else {
      print('dbstatus' + 'Opening database');
    }

    return await openDatabase(path);
  }
}
