// import 'package:aeon_hrms/Utility/DatabaseHelper.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart' as sql;
// import 'package:sqflite/sqflite.dart';

// class SQLloginDetail {
//   static Future<void> createTables(Database database) async {
//     await database.execute("""CREATE TABLE IF NOT EXISTS UserDetails(
//         id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
//         EMP_CODE TEXT,
//         EMP_NAME TEXT,
//         MOBILENO TEXT,
//         EMAILID TEXT,
//         OLongitude TEXT,
//         OLatitude TEXT,
//         LOC_CODE TEXT,
//         CHECK_IN_OUT TEXT,
//         createdDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
//       )
//       """);
//   }
// // id: the id of a item
// // title, description: name and description of your activity
// // created_at: the time that the item was created. It will be automatically handled by SQLite

//   static Future<Database> db() async {
//     var databasesPath = await getDatabasesPath();
//     String path = join(databasesPath, 'divergent.db');
// //join is from path package
//     print("Path${path}");
//     Future<sql.Database> db = sql.openDatabase(
//       path,
//       version: 1,
//       onCreate: (Database db, int version) async {
//         await createTables(db);
//       },
//     );
//     return db;
//   }

//   // Create new item (journal)
//   static Future<int> createUser(
//       String empCode,
//       String empName,
//       String mobileNo,
//       String emailId,
//       String latitude,
//       String longitude,
//       String locCode,
//       String checkInOut) async {
//     if (kDebugMode) {
//       print('emp code vslue $empCode');
//       print('empName code vslue $empName');
//       print('locCode code vslue $locCode');
//       print('latitude code vslue $latitude');
//       print('longititude code vslue $longitude');
//     }

//     final db = await SQLloginDetail.db();

//     final data = {
//       'EMP_CODE': empCode,
//       'EMP_NAME': empName,
//       'MOBILENO': mobileNo,
//       'EMAILID': emailId,
//       'Olongitude': longitude,
//       'OLatitude': latitude,
//       'LOC_CODE': locCode,
//       'CHECK_IN_OUT': checkInOut,
//     };
//     final id = await db.insert('UserDetails', data,
//         conflictAlgorithm: sql.ConflictAlgorithm.replace);
//     return id;
//   }

//   // Read all items (journals)
//   static Future<List<Map<String, dynamic>>> getUserDetails() async {
//     final db = await SQLloginDetail.db();
//     return db.query('UserDetails', orderBy: "id");
//   }

//   static Future<List<Map<String, Object?>>> getUserDetailsExist(
//       String empCode) async {
//     final db = await SQLloginDetail.db();
//     return db.rawQuery(
//         'SELECT COUNT(*) FROM UserDetails where EMP_CODE=' '$empCode' '');
//   }

//   // Read a single item by id
//   // The app doesn't use this method but I put here in case you want to see it
//   static Future<List<Map<String, dynamic>>> getUserDetailsByempcode(
//       String empCode) async {
//     final db = await SQLloginDetail.db();
//     return db.query('UserDetails',
//         where: "EMP_CODE = ?", whereArgs: [empCode], limit: 1);
//   }

//   // Update an item by id
//   static Future<int> updateUserDetails(
//       String empCode,
//       String empName,
//       String mobileNo,
//       String emailId,
//       String latitude,
//       String longitude,
//       String locCode,
//       String checkInOut) async {
//     final db = await SQLloginDetail.db();
//     final data = {
//       'EMP_CODE': empCode,
//       'EMP_NAME': empName,
//       'MOBILENO': mobileNo,
//       'EMAILID': emailId,
//       'Olongitude': longitude,
//       'OLatitude': latitude,
//       'LOC_CODE': locCode,
//       'CHECK_IN_OUT': checkInOut,
//     };

//     final result = await db.update('UserDetails', data,
//         where: "EMP_CODE = ?", whereArgs: [empCode]);
//     return result;
//   }

//   // Delete
//   static Future<void> deleteUserDetailsbyid(int id) async {
//     final db = await SQLloginDetail.db();
//     try {
//       await db.delete("UserDetails", where: "id = ?", whereArgs: [id]);
//     } catch (err) {
//       debugPrint("Something went wrong when deleting an item: $err");
//     }
//   }

//   // ignore: non_constant_identifier_names
//   static Future<void> deleteUserDetailsbyEmp_code(String empCode) async {
//     final db = await SQLHelper.db();
//     try {
//       await db
//           .delete("UserDetails", where: "EMP_CODE = ?", whereArgs: [empCode]);
//     } catch (err) {
//       debugPrint("Something went wrong when deleting an item: $err");
//     }
//   }
// }
