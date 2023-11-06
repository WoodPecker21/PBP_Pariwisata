import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //create db
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE generatedqr(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        data TEXT,
        has_used TEXT
      )
    """);
  }

  //call db
  static Future<sql.Database> db() async {
    return sql.openDatabase('generatedqr.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //insert
  static Future<int> addQR(String dataqr) async {
    final db = await SQLHelper.db();
    final data = {
      'data': dataqr,
      'has_used': 'false',
    };
    return await db.insert('generatedqr', data);
  }

  //get qr where id
  static Future<List<Map<String, dynamic>>> getQR(int id) async {
    final db = await SQLHelper.db();
    return db.query('generatedqr', where: 'id = ?', whereArgs: [id]);
  }

  //update
  static Future<int> setHasUsedQR(int id) async {
    final db = await SQLHelper.db();
    final data = {
      'has_used': 'true',
    };
    return await db.update('objekwisata', data, where: "id = $id");
  }

  //cek apakah ada
  static Future<int?> getQRId(String dataqr) async {
    final db = await SQLHelper.db();
    final result = await db.query('generatedqr',
        columns: ['id'], where: "data = '$dataqr'");
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return null;
    }
  }

//cek apakah qr sudah digunakan
  static Future<String?> getQRHasUsed(int id) async {
    final db = await SQLHelper.db();
    final result = await db.query('generatedqr',
        columns: ['has_used'], where: "id = '$id'");
    if (result.isNotEmpty) {
      return result.first['has_used'] as String;
    } else {
      return null;
    }
  }

  // delete
  // static Future<int> deleteObjekWisata(int id) async {
  //   final db = await SQLHelper.db();
  //   return await db.delete('objekwisata', where: "id = $id");
  // }
}
