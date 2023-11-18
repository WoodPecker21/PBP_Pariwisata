import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //create db
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE transaksi(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        idUser INTEGER,
        idBayar INTEGER,
        idObjek INTEGER,
        name TEXT,
        jumlahTamu INTEGER,
        email TEXT,
        ktpNumber TEXT,
        phoneNumber TEXT,
        tglStart TEXT
      )
    """);
  }

  //call db
  static Future<sql.Database> db() async {
    return sql.openDatabase('transaksi.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // //insert tgl dulu
  // static Future<int> addTransaksi(String tglStart) async {
  //   final db = await SQLHelper.db();
  //   final data = {'tglStart': tglStart};
  //   return await db.insert('transaksi', data);
  // }

  // booking insert
  static Future<int> insertBooking(
      int idUser,
      int idObjek,
      String name,
      int jumlahTamu,
      String email,
      String ktp,
      String phoneNumber,
      String tglStart,
      int idBayar) async {
    final db = await SQLHelper.db();
    final data = {
      'idUser': idUser,
      'idObjek': idObjek,
      'name': name,
      'jumlahTamu': jumlahTamu,
      'email': email,
      'ktpNumber': ktp,
      'phoneNumber': phoneNumber,
      'tglStart': tglStart,
      'idBayar': idBayar,
    };
    return await db.insert('transaksi', data);
  }

  // //booking 3: pembayaran
  // static Future<int> addPembayaran(int id, int idBayar) async {
  //   final db = await SQLHelper.db();
  //   final data = {'idBayar': idBayar};
  //   return await db.update('transaksi', data, where: "id = $id");
  // }

  //jika edit di future booking, hanya bisa edit tanggal
  static Future<int> editTanggal(int id, String tglGanti) async {
    final db = await SQLHelper.db();
    final data = {'tglStart': tglGanti};
    return await db.update('transaksi', data, where: "id = $id");
  }

  //delete
  static Future<int> deleteTransaksi(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('transaksi', where: "id = $id");
  }

  //read
  static Future<List<Map<String, dynamic>>> getTransaksi(int id) async {
    final db = await SQLHelper.db();
    return db.query('transaksi', where: "id = $id");
  }
}
