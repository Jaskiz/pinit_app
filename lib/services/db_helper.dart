import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recordatorio_model.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'pinit_database2.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE recordatorios(
            id TEXT PRIMARY KEY, 
            titulo TEXT, 
            notas TEXT, 
            fecha TEXT, 
            hora TEXT, 
            categoria TEXT, 
            esPlantilla INTEGER, 
            antelacion TEXT, 
            antelacionMinutos INTEGER,
            tono TEXT, 
            color INTEGER
          )''',
        );
      },
    );
  }

  static Future<void> insertar(Recordatorio recordatorio) async {
    final db = await database;
    await db.insert('recordatorios', recordatorio.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Recordatorio>> obtenerTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recordatorios');
    return List.generate(maps.length, (i) => Recordatorio.fromMap(maps[i]));
  }
  
  static Future<void> eliminar(String id) async {
    final db = await database;
    await db.delete('recordatorios', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> actualizar(Recordatorio recordatorio) async {
  final db = await database;
  await db.update(
    'recordatorios',
    recordatorio.toMap(),
    where: 'id = ?',
    whereArgs: [recordatorio.id],
  );
}
}