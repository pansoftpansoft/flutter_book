import 'package:flutter_book/utils.dart' as utils;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Appointments.dart';

class AppointmentsDBWorker {
  AppointmentsDBWorker._();

  static final AppointmentsDBWorker db = AppointmentsDBWorker._();

  Database _db;


  Future get database async {
    if (_db == null) {
      _db = await init();
    }
    return _db;
  }

  Future<Database> init() async {
    String path = join(utils.docsDir.path, "notes.db");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
          await inDB.execute("CREATE TABLE IF NOT EXISTS appointments("
              "id INTEGER PRIMARY KEY,"
              "title TEXT,"
              "description TEXT,"
              "appointmentsDate  TEXT,"
              "appointmentsTime TEXT)");
        });
    return db;
  }
}