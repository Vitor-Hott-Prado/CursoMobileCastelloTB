// lib/services/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String DB_NAME = 'training_app.db';
  static const int DB_VERSION = 1;

  // Table names
  static const String TABLE_ROUTINES = 'routines';
  static const String TABLE_EXERCISES = 'exercises';

  // Routine table columns
  static const String COLUMN_ROUTINE_ID = 'id';
  static const String COLUMN_ROUTINE_NAME = 'name';
  static const String COLUMN_ROUTINE_OBJECTIVE = 'objective'; // Adicione a coluna para objetivo

  // Exercise table columns
  static const String COLUMN_EXERCISE_ID = 'id';
  static const String COLUMN_EXERCISE_ROUTINE_ID = 'routineId'; // Chave estrangeira
  static const String COLUMN_EXERCISE_NAME = 'name';
  static const String COLUMN_EXERCISE_SERIES = 'series';
  static const String COLUMN_EXERCISE_REPETITIONS = 'repetitions';
  static const String COLUMN_EXERCISE_LOAD = 'load';
  static const String COLUMN_EXERCISE_TYPE = 'type';


  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), DB_NAME);
    return await openDatabase(
      path,
      version: DB_VERSION,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Create Routines table
    await db.execute('''
      CREATE TABLE $TABLE_ROUTINES (
        $COLUMN_ROUTINE_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_ROUTINE_NAME TEXT NOT NULL,
        $COLUMN_ROUTINE_OBJECTIVE TEXT NOT NULL
      )
    ''');

    // Create Exercises table
    await db.execute('''
      CREATE TABLE $TABLE_EXERCISES (
        $COLUMN_EXERCISE_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_EXERCISE_ROUTINE_ID INTEGER NOT NULL,
        $COLUMN_EXERCISE_NAME TEXT NOT NULL,
        $COLUMN_EXERCISE_SERIES INTEGER NOT NULL,
        $COLUMN_EXERCISE_REPETITIONS TEXT NOT NULL,
        $COLUMN_EXERCISE_LOAD TEXT NOT NULL,
        $COLUMN_EXERCISE_TYPE TEXT NOT NULL,
        FOREIGN KEY ($COLUMN_EXERCISE_ROUTINE_ID) REFERENCES $TABLE_ROUTINES($COLUMN_ROUTINE_ID) ON DELETE CASCADE
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implement database schema upgrades here.
    // For simplicity during development, you might drop and recreate.
    // For production, you'd write ALTER TABLE statements.
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS $TABLE_EXERCISES');
      await db.execute('DROP TABLE IF EXISTS $TABLE_ROUTINES');
      _onCreate(db, newVersion);
    }
  }
}