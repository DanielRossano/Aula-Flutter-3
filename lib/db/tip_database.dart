import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/tip.dart';
import 'dart:io';

class TipDatabase {
  static Database? _database;
  static final TipDatabase instance = TipDatabase._init();

  TipDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tips.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tips (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        billAmount REAL,
        tipAmount REAL,
        percentage REAL
      )
    ''');
  }

  Future<Tip> insertTip(Tip tip) async {
    final db = await instance.database;
    final id = await db.insert('tips', tip.toMap());
    return tip.copyWith(id: id);
  }

  Future<List<Tip>> getAllTips() async {
    final db = await instance.database;
    final result = await db.query('tips', orderBy: 'id DESC');
    return result.map((map) => Tip.fromMap(map)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

extension on Tip {
  Tip copyWith({int? id}) {
    return Tip(
      id: id ?? this.id,
      billAmount: billAmount,
      tipAmount: tipAmount,
      percentage: percentage,
    );
  }
}
