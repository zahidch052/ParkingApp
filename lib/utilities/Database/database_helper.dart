import 'dart:io';
import 'package:parkingapp/utilities/Database/paking_spot_fields.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  DataBaseHelper._privateConstructor();
  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();
  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;
  static final _tableName = 'myTable';
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    return _database = await initiateDataBase();
  }

  initiateDataBase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future? _onCreate(Database db, int version) async {
    print('creating database');
    await db.execute('''
      CREATE TABLE $_tableName ( 
        ${ParkingSpotsFields.identifier} INTEGER primary key autoincrement,
        ${ParkingSpotsFields.latitude} DOUBLE,
        ${ParkingSpotsFields.longitude} DOUBLE,
        ${ParkingSpotsFields.name} TEXT,
        ${ParkingSpotsFields.rating} INTEGER,
        ${ParkingSpotsFields.description} TEXT
        )
      ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    try {
      print('inserting value');
      return await db!.insert(_tableName, row);
    } catch (e) {
      print(e);
    }

    return -1;
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database? db = await instance.database;
    return await db!.query(_tableName);
  }
}
