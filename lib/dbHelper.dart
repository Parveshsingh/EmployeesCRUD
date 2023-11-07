import 'dart:io';

import 'package:demoapp/common/commonWidget.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class EmployeeDatabase {
  static final EmployeeDatabase instance = EmployeeDatabase._privateConstructor();
  static Database? _database;

  static const _databaseName = 'employee_database.db';
  static const _databaseVersion = 1;

  EmployeeDatabase._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String path = join(dataDirectory.path, _databaseName);
    printText("------------------- it is db path $path -------------------");

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        role TEXT,
        fromDate TEXT,   
        toDate TEXT       
      )
    ''');
  }

  Future<int> insertEmployee(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('employees', row);
  }

  Future<List<Map<String, dynamic>>?> queryAllEmployees() async {
    Database db = await instance.database;
    return await db.query('employees');
  }

  Future<Map<String, dynamic>?> getEmployeeById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateEmployee(int id, Map<String, dynamic> updatedEmployee) async {
    Database db = await instance.database;
    return await db.update(
      'employees',
      updatedEmployee,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    Database db = await instance.database;
    return await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
