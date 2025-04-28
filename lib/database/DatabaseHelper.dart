import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'; // ✅ Added to fix DB path issue

class DatabaseHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory(); // ✅ Correct: use app document directory
    String path = join(documentsDirectory.path, 'temple_db.db'); // ✅ Fixed: use correct path + added .db extension
    print('Database path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE temples(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            temple_name TEXT,
            Temple_info TEXT,
            Temple_Embeddin_value REAL
          );
        '''); // ✅ No changes here — your table creation was already correct!

        await db.execute('''
          CREATE TABLE temple_images(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            temple_id INTEGER,
            image_path TEXT,
            FOREIGN KEY (temple_id) REFERENCES temples(id)
          );
        ''');
      },
    );
  }

  // Insert temple data into temples table
  Future<int> insertTemple({
    required String templeName, 
    required String templeInfo, 
    required double embeddingValue,
  }) async {
    final db = await database;
    Map<String, dynamic> data = {
      'temple_name': templeName,
      'Temple_info': templeInfo, 
      'Temple_Embeddin_value': embeddingValue, 
    };
    return await db.insert('temples', data);
  }

  // Insert temple image into temple_images table
  Future<int> insertTempleImage({
    required int templeId,
    required String imagePath,
  }) async {
    final db = await database;
    Map<String, dynamic> data = {
      'temple_id': templeId,
      'image_path': imagePath,
    };
    return await db.insert('temple_images', data);
  }

  Future <int> updateTempleEmbedding({
  required String templeName,
  required String newEmbeddingValue,
  }) async {
    final db = await database;
    return await db.update(
      'temples',
      {
        'Temple_Embeddin_value': newEmbeddingValue,

      },
      where: 'temple_name = ?',
      whereArgs: [templeName],
    ); 
  }
  // Add this to your DatabaseHelper class
Future<Map<String, List<double>>> getAllTempleEmbeddings() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('temples');
  
  final Map<String, List<double>> embeddings = {};
  
  for (var temple in maps) {
    // Convert the stored string to List<double>
    final embeddingString = temple['Temple_Embeddin_value'].toString();
    final embeddingList = embeddingString
      .replaceAll('[', '')
      .replaceAll(']', '')
      .split(',')
      .map((e) => double.parse(e.trim()))
      .toList();
    
    embeddings[temple['temple_name']] = embeddingList;
  }
  
  return embeddings;
}











}



