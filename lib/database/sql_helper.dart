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

  //read employee
  static Future<List<Map<String, dynamic>>> getObjekWisata() async {
    final db = await SQLHelper.db();
    return db.query('objekwisata');
  }

  //update employee
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

  //delete employee
  static Future<int> deleteObjekWisata(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('objekwisata', where: "id = $id");
  }
}
