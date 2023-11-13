import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //create db
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE transaksi(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        idUser INTEGER,
        idBayar INTEGER,
        name TEXT,
        jumlahTamu INTEGER,
        email TEXT,
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

  //insert tgl dulu
  static Future<int> addTransaksi(String tglStart) async {
    final db = await SQLHelper.db();
    final data = {'tglStart': tglStart};
    return await db.insert('transaksi', data);
  }

  // booking 2: update
  static Future<int> addDetail(int idTransaksi, int idUser, String name,
      int jumlahTamu, String email, String phoneNumber) async {
    final db = await SQLHelper.db();
    final data = {
      'idUser': idUser,
      'name': name,
      'jumlahTamu': jumlahTamu,
      'email': email,
      'phoneNumber': phoneNumber,
    };
    return await db.update('transaksi', data, where: "id = $idTransaksi");
  }

  //booking 3: pembayaran
  static Future<int> addPembayaran(int id, int idBayar) async {
    final db = await SQLHelper.db();
    final data = {'idBayar': idBayar};
    return await db.update('transaksi', data, where: "id = $id");
  }

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
  static Future<List<Map<String, dynamic>>> getTransaksi() async {
    final db = await SQLHelper.db();
    return db.query('transaksi');
  }
}
