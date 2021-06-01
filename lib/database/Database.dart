import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../datamodel/SecretDataModel.dart';

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
          'CREATE TABLE $tableName(id TEXT PRIMARY KEY, type TEXT NOT NULL, label TEXT, secret TEXT NOT NULL, issuer TEXT, counter INTEGER, period INTEGER NOT NULL, digits INTEGER NOT NULL, algorithm TEXT NOT NULL, tags TEXT, icon TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertSecret(Secret secret) async {
    final db = await database;
    await db.insert(tableName, secret.toMap());
  }

  Future<void> updateSecret(Secret secret) async {
    final db = await database;
    await db.update(
      tableName,
      secret.toMap(),
      where: 'id = ?',
      whereArgs: [secret.id],
    );
  }

  Future<Secret> getSecretById(String id) async {
    final db = await database;
    final Map<String, dynamic> map =
        (await db.query(tableName, where: 'id = ?', whereArgs: [id]))[0];
    return Secret.fromMap(map);
  }

  Future<List<Secret>> getSecrets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(
      maps.length,
      (index) {
        return Secret.fromMap(maps[index]);
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