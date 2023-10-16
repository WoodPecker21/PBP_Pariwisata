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
        birthDate TEXT
      )
    """);
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
      String phoneNumber, String birthDate) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'password': password,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate
    };
    return await db.insert('user', data);
  }

  //read
  static Future<List<Map<String, dynamic>>> getUser() async {
    final db = await SQLHelper.db();
    return db.query('user');
  }

  //update
  static Future<int> editUser(int id, String name, String password,
      String email, String phoneNumber, String birthDate) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'password': password,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate
    };
    return await db.update('user', data, where: "id = $id");
  }

  //delete
  static Future<int> deleteUser(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('user', where: "id = $id");
  }
}
