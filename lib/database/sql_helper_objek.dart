import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //create db
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE objekwisata(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nama TEXT,
        deskripsi TEXT,
        kategori TEXT,
        gambar TEXT,
        rating DOUBLE,
        harga DOUBLE
      )
    """);
  }
  //harus tambah kolom gambar(blob), durasi, akomodasi, transportasi

  //call db
  static Future<sql.Database> db() async {
    return sql.openDatabase('objekwisata.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //insert employee
  static Future<int> addObjekWisata(String nama, String deskripsi,
      String kategori, String gambar, double rating, double harga) async {
    final db = await SQLHelper.db();
    final data = {
      'nama': nama,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'gambar': gambar,
      'rating': rating,
      'harga': harga
    };
    return await db.insert('objekwisata', data);
  }

  //read all
  static Future<List<Map<String, dynamic>>> getObjekWisata() async {
    final db = await SQLHelper.db();
    return db.query('objekwisata');
  }

  //read by id
  static Future<Map<String, dynamic>?> getObjekWisataById(int id) async {
    final db = await SQLHelper.db();
    final result = await db.query('objekwisata', where: "id = $id");
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  //update
  static Future<int> editObjekWisata(int id, String nama, String deskripsi,
      String kategori, String gambar, double rating, double harga) async {
    final db = await SQLHelper.db();
    final data = {
      'nama': nama,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'gambar': gambar,
      'rating': rating,
      'harga': harga
    };
    return await db.update('objekwisata', data, where: "id = $id");
  }

  //delete
  static Future<int> deleteObjekWisata(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('objekwisata', where: "id = $id");
  }

  //get harga
  static Future<double?> getHarga(int id) async {
    final db = await SQLHelper.db();
    final result = await db.query('objekwisata', where: "id = $id");
    if (result.isNotEmpty) {
      return result.first['harga'] as double;
    } else {
      return null;
    }
  }
}
