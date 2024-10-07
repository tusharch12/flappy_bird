import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GameDatabase {
  static final GameDatabase instance = GameDatabase._init();

  static Database? _database;

  GameDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('games.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE scores ( 
      id $idType, 
      score $integerType
    )
    ''');
  }

  Future<int> createScore(int score) async {
    final db = await instance.database;

    final id = await db.insert('scores', {'score': score});
    return id;
  }

  Future<List<int>> getLastFiveScores() async {
    final db = await instance.database;

    final result = await db.query(
      'scores',
      orderBy: 'id DESC',
      limit: 5,
    );

    return result.map((row) => row['score'] as int).toList();
  }

  Future<int?> getMaxScore() async {
    final db = await instance.database;

    final result = await db.rawQuery('SELECT MAX(score) as maxScore FROM scores');

    if (result.isNotEmpty && result.first['maxScore'] != null) {
      return result.first['maxScore'] as int;
    } else {
      return null;
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
