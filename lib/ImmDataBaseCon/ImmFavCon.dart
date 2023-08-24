// ignore_for_file: import_of_legacy_library_into_null_safe, depend_on_referenced_packages, prefer_const_declarations, file_names

import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ImmFavCon {
  static final _databaseName = "favorites.db";
  static final _databaseVersion = 1;

  static final table = 'favorites_table';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnrate = 'rate';
  static final columndiffRate = 'diffRate';
  static final columnsymbol = 'symbol';
  static final columnhistoryRate = 'historyRate';

  // make this a singleton class
  ImmFavCon._privateConstructor();
  static final ImmFavCon favInst =
  ImmFavCon._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    String query = '''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnrate DOUBLE,
            $columndiffRate TEXT NOT NULL,
            $columnsymbol TEXT NOT NULL, 
            $columnhistoryRate DOUBLE 
           
          )
          ''';
    await db.execute(query);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await favInst.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await favInst.database;
    return await db.query(table);
  }

  Future<int?> queryRowCount() async {
    Database db = await favInst.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await favInst.database;
    String id = row[columnName];
    return await db
        .update(table, row, where: '$columnName = ?', whereArgs: [id]);
  }

  Future<int> delete(String id) async {
    Database db = await favInst.database;
    return await db.delete(table, where: '$columnName = ?', whereArgs: [id]);
  }
}
