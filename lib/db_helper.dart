import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHepler {
  /// Database

//private construction
  DbHepler._();

  static final DbHepler getInstance = DbHepler._();

  //  db open()

  static const String TABLE_NOTE = "note";
  static const String COLUMN_NOTE_SNO = "s_no";
  static const String COLUMN_NOTE_TITLE = "title";
  static const String COLUMN_NOTE_DESC = "desc";

  Database? myDB;

// functions..

  Future<Database?> getDb() async {
    myDB ??= await openDb();

    return myDB;
    // if (myDB != null) {
    //   return myDB!;
    // } else {
    //   myDB = await openDb();
    //   return myDB;
    // }
  }

  Future<Database> openDb() async {
    Directory appdir = await getApplicationDocumentsDirectory();

    String dbPath = join(appdir.path, "noteDB.db");

    return await openDatabase(dbPath, onCreate: (db, version) {
      /// create tables here.
      try {
        print("creating table");
        db.execute(
            // "create table note (s_no integer primary key autoincreament ,title text, desc text )"
            /// you can create multiple table  but make sure table name must be different...

            "create table $TABLE_NOTE ($COLUMN_NOTE_SNO integer primary key autoincrement ,$COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text )");

        print("table created successfull");
      } catch (e) {
        print("Error creating table: $e");
      }
    }, version: 1);
  }

  //  all queries
// insertion
  Future<bool> addNote({required String mTitle, required String mDesc}) async {
    var db = await getDb();
    int rowsEffected = await db!.insert(
        TABLE_NOTE, {COLUMN_NOTE_TITLE: mTitle, COLUMN_NOTE_DESC: mDesc});
    return rowsEffected > 0;
  }

  ///reading all data...
  Future<List<Map<String, dynamic>>> getAllNote() async {
    var db = await getDb();

    List<Map<String, dynamic>> myData = await db!.query(
      TABLE_NOTE,
    );
    return myData;
  }

  // update data..
  Future<bool> updateNote(
      {required String mtitle, required String mdesc, required int sno}) async {
    var db = await getDb();
    int rowEffected = await db!.update(
        TABLE_NOTE, {COLUMN_NOTE_TITLE: mtitle, COLUMN_NOTE_DESC: mdesc},
        where: "$COLUMN_NOTE_SNO = $sno", whereArgs: ["$sno"]);
    return rowEffected > 0;
  }

  Future<bool> deleteNote({required int sno}) async {
    var db = await getDb();
    int noteDeleted = await db!
        .delete(TABLE_NOTE, where: "$COLUMN_NOTE_SNO = ?", whereArgs: ["$sno"]);
    return noteDeleted > 0;
  }
}














//  packages installed...
// add sqflite package from pub..
// path
// path provider.