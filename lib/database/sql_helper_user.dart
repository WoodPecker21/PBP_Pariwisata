import 'dart:typed_data';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //create db
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        password TEXT,
        email TEXT,
        phoneNumber TEXT,
        birthDate TEXT,
        gender TEXT,
        imageProfile BLOB
      )
    """);
  }

  static Future<int> updateProfileImages(
      String name, Uint8List profileImage) async {
    final db = await SQLHelper.db();
    final data = {'imageProfile': profileImage};
    return db.update('user', data, where: 'name = ?', whereArgs: [name]);
  }

  //call db
  static Future<sql.Database> db() async {
    return sql.openDatabase('user.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //insert
  static Future<int> addUser(String name, String password, String email,
      String phoneNumber, String birthDate, String gender) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'password': password,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'gender': gender,
    };
    return await db.insert('user', data);
  }

  //read
  static Future<List<Map<String, dynamic>>> getUser() async {
    final db = await SQLHelper.db();
    return db.query('user');
  }

  //update
  static Future<int> editUser(
      int id,
      String name,
      String email,
      String phoneNumber,
      String birthDate,
      String gender,
      Uint8List imageProfil) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'gender': gender,
      'imageProfile': imageProfil,
    };
    return await db.update('user', data, where: "id = $id");
  }

  //delete
  static Future<int> deleteUser(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('user', where: "id = $id");
  }

  //cari user berdasarkan username dan password
  static Future<int> searchUser(String nameInput, String passwordInput) async {
    final db = await SQLHelper.db();

    List<Map<String, dynamic>> result = await db.query(
      'user',
      columns: ['id'],
      where: 'name = ? AND password = ?',
      whereArgs: [nameInput, passwordInput],
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int; // Return the user ID as an int
    }

    return -1; // No user found with the provided name and password
  }

  static Future<Map<String, dynamic>?> getUserById(int userId) async {
    final db = await SQLHelper.db();

    List<Map<String, dynamic>> result = await db.query(
      'user',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return result.first; // Return the user as a Map<String, dynamic>
    }

    return null; // No user found with the provided ID
  }

  static Future<int> insertImage(int userId, Uint8List image) async {
    final db = await SQLHelper.db();

    return await db.update(
      'user',
      {'imageProfile': image},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  static Future<Uint8List?> getImageProfile(int userId) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> result = await db.query(
      'user',
      columns: ['imageProfile'],
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty && result.first['imageProfile'] != null) {
      return result.first['imageProfile'] as Uint8List;
    } else if (result.first['imageProfile'] == null) {
      return null;
    } else {
      return null;
    }
  }
}
