import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Classe auxiliar para gerenciar o banco de dados local usando SQLite.
class DatabaseHelper {
  // Instância única do banco de dados (singleton)
  static Database? _database;

  // Nome do arquivo do banco de dados
  static const String DB_NAME = 'training_app.db';

  // Versão do banco de dados (necessário para upgrades)
  static const int DB_VERSION = 1;

  // Nomes das tabelas
  static const String TABLE_ROUTINES = 'routines';
  static const String TABLE_EXERCISES = 'exercises';

  // Colunas da tabela de rotinas
  static const String COLUMN_ROUTINE_ID = 'id';
  static const String COLUMN_ROUTINE_NAME = 'name';
  static const String COLUMN_ROUTINE_OBJECTIVE = 'objective'; // Objetivo da rotina

  // Colunas da tabela de exercícios
  static const String COLUMN_EXERCISE_ID = 'id';
  static const String COLUMN_EXERCISE_ROUTINE_ID = 'routineId'; // Chave estrangeira para a rotina
  static const String COLUMN_EXERCISE_NAME = 'name';
  static const String COLUMN_EXERCISE_SERIES = 'series';
  static const String COLUMN_EXERCISE_REPETITIONS = 'repetitions';
  static const String COLUMN_EXERCISE_LOAD = 'load';
  static const String COLUMN_EXERCISE_TYPE = 'type';

  /// Getter que retorna a instância do banco de dados.
  /// Se não existir, ele inicializa.
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  /// Inicializa o banco de dados criando ou abrindo o arquivo SQLite.
  Future<Database> _initDatabase() async {
    // Define o caminho completo do arquivo do banco
    String path = join(await getDatabasesPath(), DB_NAME);

    // Abre ou cria o banco com as funções de criação e atualização
    return await openDatabase(
      path,
      version: DB_VERSION,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Função chamada quando o banco de dados é criado pela primeira vez.
  Future _onCreate(Database db, int version) async {
    // Criação da tabela de rotinas
    await db.execute('''
      CREATE TABLE $TABLE_ROUTINES (
        $COLUMN_ROUTINE_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_ROUTINE_NAME TEXT NOT NULL,
        $COLUMN_ROUTINE_OBJECTIVE TEXT NOT NULL
      )
    ''');

    // Criação da tabela de exercícios com chave estrangeira para rotinas
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

  /// Função chamada quando há mudança na versão do banco de dados.
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Lógica de upgrade do banco. Aqui está usando o método mais simples:
    // deletar e recriar tabelas (ideal apenas para desenvolvimento).
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS $TABLE_EXERCISES');
      await db.execute('DROP TABLE IF EXISTS $TABLE_ROUTINES');
      _onCreate(db, newVersion); // Recria as tabelas
    }
  }
}
