// the code below is used to create a class database for creating the sqlite database
// for our project
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  // the code below is used to create a static final instance of the Database provider class
  static final DatabaseProvider dbProvider = DatabaseProvider();

  // the code below is used to create an instance of the database from our sqflite package
  Database? database;

  // the code below is used to create a getter for checking that if the database
  // is not null then returning the database else creating a new database
  Future<Database> get db async {
    if (database != null) {
      return database!;
    } else {
      database = await createDatabase();
      return database!;
    }
  }

  Future<void> deleteDatabaseFile() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, 'main.db');

    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        print('Database deleted successfully');
      }
    } catch (e) {
      print('Error deleting database: $e');
    }
  }

  static Future<void> shareDatabaseFile() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, 'main.db');
    final file = File(path);

    if (await file.exists()) {
      // Use the `share` package to share the database file
      await Share.shareXFiles([XFile(file.path)], text: 'main.db');
    } else {
      print('Database file does not exist');
    }
  }

  Future<Database> createDatabase() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, 'main.db');

    // in the line of code below we need to use the openDatabase() method to
    // open the database and create the table using raw sql command
    var database = await openDatabase(
      path, // the path where our database is located
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE task (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            targetEffort INTEGER NOT NULL,
            status TEXT NOT NULL,
            description TEXT
          )
          ''');
        await db.execute('''
          CREATE TABLE progress (
            id TEXT PRIMARY KEY,
            taskId TEXT NOT NULL,
            duration INTERGER NOT NULL,
            startDm INTEGER NOT NULL,
            endDm INTEGER NOT NULL,
            startComment TEXT,
            endComment TEXT,

            FOREIGN KEY(taskId) REFERENCES task(id)
          )
          ''');
        await db.execute('''
          CREATE TABLE goal (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT
          )
          ''');
        await db.execute('''
          CREATE TABLE assoc_task_goal (
            taskId TEXT,
            goalId TEXT,
            PRIMARY KEY (taskId, goalId),
            FOREIGN KEY (taskId) REFERENCES task(id),
            FOREIGN KEY (goalId) REFERENCES goal(id)
          )
          ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) {
        if (newVersion > oldVersion) {}
      },
    );

    return database;
  }
}
