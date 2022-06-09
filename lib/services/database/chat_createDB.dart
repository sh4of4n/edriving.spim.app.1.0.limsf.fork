import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database? db;

class DatabaseCreator {
  static const String todoTable = 'todo';
  static const String id = 'id';
  static const String name = 'name';
  static const String info = 'info';
  static const String isDeleted = 'isDeleted';

  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>>? selectQueryResult,
      int? insertAndUpdateQueryResult,
      List<dynamic>? params]) {
    debugPrint(functionName);
    debugPrint(sql);
    if (params != null) {
      // ignore: avoid_print
      print(params);
    }
    if (selectQueryResult != null) {
      // ignore: avoid_print
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      // ignore: avoid_print
      print(insertAndUpdateQueryResult);
    }
  }

  Future<void> createTodoTable(Database db) async {
    const String todoSql = '''CREATE TABLE $todoTable
    (
      $id INTEGER PRIMARY KEY,
      $name TEXT,
      $info TEXT,
      $isDeleted BIT NOT NULL
    )''';

    await db.execute(todoSql);
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    //make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('todo_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    // ignore: avoid_print
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createTodoTable(db);
  }
}
