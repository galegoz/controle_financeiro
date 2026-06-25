import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('controle_pessoal.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE transactions (
  id $idType,
  type $textType,
  date $textType,
  description $textType,
  amount $realType,
  paymentMethod $textType
)
''');

    await db.execute('''
CREATE TABLE settings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  monthlyLimit $realType,
  currency $textType
)
''');

    // Inicializa as configurações padrão
    await db.insert('settings', {
      'monthlyLimit': 3000.0,
      'currency': 'BRL',
    });
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
