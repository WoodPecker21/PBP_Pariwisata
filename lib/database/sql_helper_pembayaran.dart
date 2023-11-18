import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //create db
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE pembayaran(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        harga DOUBLE,
        metode TEXT
      )
    """);
  }

  //call db
  static Future<sql.Database> db() async {
    return sql.openDatabase('pembayaran.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //insert
  static Future<int> addPembayaran(String metode, double harga) async {
    final db = await SQLHelper.db();
    final data = {
      'harga': harga,
      'metode': metode,
    };
    int insertedId = await db.insert('pembayaran', data);
    return insertedId;
  }

  // delete
  // static Future<int> deleteObjekWisata(int id) async {
  //   final db = await SQLHelper.db();
  //   return await db.delete('objekwisata', where: "id = $id");
  // }
}
