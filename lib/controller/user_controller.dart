import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:words/model/user_model.dart';

class UserController {
  var database;

  main() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'users.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY autoincrement, name TEXT)',
        );
      },
      version: 1,
    );

    return database;
  }

  //insert
  Future<bool> insertUser(name) async {
    final db = await main();
    var row = db.rawInsert('INSERT INTO users(name) VALUES(?)', [name]);
    print(row);
    return true;
  }

  Future<List<UserModel>> users() async {
    final db = await main();

    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return UserModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  Future<void> deleteUser(int id) async {
    final db = await main();

    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
