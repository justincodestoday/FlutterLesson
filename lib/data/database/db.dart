import 'dart:typed_data';

import 'package:hello_flutter/data/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/task.dart';

class TaskDatabase {
  static Future<void> _createTables(Database db) async {
    // triple quotes supports multiple lines.
    // This saves you from having to place \n every time you want a newline.

    // triple quotes allows both single and double quotes without escaping,
    // which might be useful in an SQL command.

    // constraints need to be placed at the creation of the database

    await db.execute("""
        CREATE TABLE ${User.tableName}(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    """);

    await db.execute("""
      CREATE TABLE ${Task.tableName}(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        priority INTEGER NOT NULL DEFAULT 0,
        createAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        fk_user_id INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(fk_user_id) REFERENCES users(id)
      )
    """);
  }

  static Future _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  static Future _onUpgradeToV2(Database db, int oldV, int newV) async {
    if (oldV < 2) {
      var tableInfo = await db.rawQuery(
        "PRAGMA table_info(${User.tableName})",
      );
      var columnNames = tableInfo.map((column) => column['name']);
      if (!columnNames.contains('image')) {
        await db.execute("""
          ALTER TABLE ${User.tableName} ADD COLUMN image BLOB
        """);
      }
    }
  }

  static Future<Database> createDb() async {
    return openDatabase(
        join(await getDatabasesPath(), "tasks_database.db"),
        version: 2,
        onConfigure: (Database db) async {
          await _onConfigure(db);
        },
        onCreate: (Database db, int version) async {
          await _createTables(db);
        },
        onUpgrade: (Database db, int oldV, int newV) async {
          if (oldV == 1) {
            await _onUpgradeToV2(db, oldV, newV);
          }
        },
    );
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await createDb();
    return db.query(Task.tableName, orderBy: "id");
  }

  static Future<int> createTask(Task task) async {
    final db = await createDb();
    return db.insert(Task.tableName, task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getTask(int id) async {
    final db = await createDb();
    return db.query(Task.tableName, where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getTasksByUserId(int userId) async {
    final db = await createDb();
    return db.query(Task.tableName, where: "fk_user_id = ?", whereArgs: [userId]);
  }

  static Future<int> updateTask(Task task) async {
    final db = await createDb();
    return db.update(Task.tableName, task.toMap(),
        where: "id = ?", whereArgs: [task.id]);
  }

  static Future<int> deleteTask(int id) async {
    final db = await createDb();
    return db.delete(Task.tableName, where: "id = ?", whereArgs: [id]);
  }

  static Future<int> createUser(User user) async {
    final db = await createDb();
    return db.insert(User.tableName, user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateUser(User user) async {
    final db = await createDb();
    return db.update(User.tableName, user.toMap(),
      where: "id = ?", whereArgs: [user.id]);
  }

  static Future updateProfilePic(int userId, Uint8List image) async {
    final db = await createDb();
    db.update(User.tableName, {"image": image}, where: "id = ?", whereArgs: [userId]);
  }

  static Future<List<Map<String, Object?>>> getUsers() async {
    final db = await createDb();
    return await db.query(User.tableName, orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getUserByEmail(String email) async {
    final db = await createDb();
    return db.query(User.tableName, where: "email = ?", whereArgs: [email], limit: 1);
  }
}

/*
1 -> title, desc
2 -> title, desc, priority, use ADD COLUMN priority, then upgrade database version
3 -> title, desc, priority, test, use ADD COLUMN test, then upgrade database version

user1 is still using version 1
user2 is using version 2
user3 is using version 3
*/