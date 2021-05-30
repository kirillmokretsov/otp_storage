import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'SecretDataModel.dart';

class DB {
  final dbName = "data.db";
  final tableName = "secrets";

  static final DB _singleton = DB._internal();

  Future<Database> database;

  factory DB() {
    return _singleton;
  }

  DB._internal();

  initDB() async {
    database = openDatabase(
      join(await getDatabasesPath(), dbName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName(id TEXT PRIMARY KEY, secret TEXT, name TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertSecret(Secret secret) async {
    final db = await database;
    await db.insert(tableName, secret.toMap());
  }

  Future<Secret> getSecretById(String id) async {
    final db = await database;
    final Map<String, dynamic> map = (await db.query(tableName, where: 'id = ?', whereArgs: [id]))[0];
    return Secret(map['id'], map['secret'], map['name']);
  }

  Future<List<Secret>> getSecrets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(
      maps.length,
      (i) {
        return Secret(
          maps[i]['id'],
          maps[i]['secret'],
          maps[i]['name'],
        );
      },
    );
  }

  Future<void> deleteSecret(Secret secret) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [secret.id],
    );
  }
}
