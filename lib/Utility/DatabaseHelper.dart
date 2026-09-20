import 'dart:convert';

import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;
  static int _errorCounter = 0;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'nia_geolocation.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE nia_geolocation(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        emp_code TEXT,
        atdate TEXT,
        in_out_date TEXT,
        LATITUDE REAL,
        LONGITUDE REAL,
        ADDRESS TEXT,
        MOBILE_NETWORK TEXT,
        flag INTEGER DEFAULT 0 
      )
    ''');

    await db.execute('''
    CREATE TABLE tblError(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      emp_code TEXT,
      error_message TEXT,
      error_date TEXT,
      flag INTEGER DEFAULT 0 
    )
  ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Add the ADDRESS column to the existing table
      await db.execute('ALTER TABLE nia_geolocation ADD COLUMN ADDRESS TEXT');
      await db.execute(
        'ALTER TABLE nia_geolocation ADD COLUMN MOBILE_NETWORK TEXT',
      );
      await db.execute(
        'ALTER TABLE nia_geolocation ADD COLUMN flag INTEGER DEFAULT 0',
      );
      await db.execute('''
      CREATE TABLE IF NOT EXISTS tblError(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        emp_code TEXT,
        error_message TEXT,
        error_date TEXT,
        flag INTEGER DEFAULT 0 
      )
    ''');
    }
  }

  Future<int> insertEmployee(Map<String, dynamic> employee) async {
    final db = await database;
    return await db.insert(
      'nia_geolocation',
      employee,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertError(Map<String, dynamic> error) async {
    final db = await database;
    _errorCounter++; // Increment the counter
    String errorMessage =
        error['error_message'] ?? ''; // Use an empty string if null
    error['error_message'] = '$errorMessage - Error #$_errorCounter';
    await db.insert(
      'tblError',
      error,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getErrors() async {
    final db = await database;
    return await db.query('tblError', orderBy: 'error_date DESC');
  }

  Future<List<Map<String, dynamic>>> getEmployees() async {
    final db = await database;
    return await db.query(
      'nia_geolocation',
      orderBy: 'emp_code,in_out_date DESC', // Order by emp_code and atdate in descending order
    );
  }

  Future<void> deleteSyncedErrors() async {
    final db = await database;
    await db.delete('tblError', where: 'flag = 1');
  }

  // Delete all error records
  Future<void> deleteAllErrors() async {
    final db = await database;
    await db.delete('tblError');
  }

  Future<void> deleteSyncedRecords() async {
    final db = await database;
    await db.delete('nia_geolocation', where: 'flag = 1');
  }

  void resetErrorCounter() {
    _errorCounter = 0;
  }

  Future<void> deleteGeolocation(String atDate) async {
    final db = await database;
    await db.delete(
      'nia_geolocation',
      where: 'atdate = ?', // Use both emp_code and atdate
      whereArgs: [atDate], // Provide values for the placeholders
    );
  }

  // Method to delete all records from the table
  Future<void> deleteAllEmployees() async {
    final db = await database;
    await db.delete('nia_geolocation');
  }

  Future<void> updateErrorSyncStatus(List<int> ids) async {
    final db = await database;
    for (var id in ids) {
      await db.update(
        'tblError',
        {'flag': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<List<Map<String, dynamic>>> getUnsyncedErrors() async {
    final db = await database;
    return await db.query(
      'tblError',
      where: 'flag = 0',
      orderBy: 'error_date DESC',
    );
  }

  Future<void> updateSyncStatus(List<int> ids) async {
    final db = await database;
    for (var id in ids) {
      await db.update(
        'nia_geolocation',
        {'flag': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<List<Map<String, dynamic>>> getUnsyncedRecords() async {
    final db = await database;
    return await db.query(
      'nia_geolocation',
      where: 'flag = 0',
      orderBy: 'id ASC',
      limit: 50,
    );
  }

  Future<void> syncWithServer() async {
    List<Map<String, dynamic>> unsyncedRecords = await getUnsyncedRecords();
    print(unsyncedRecords);
    if (unsyncedRecords.isNotEmpty) {
      try {
        List<Map<String, dynamic>> formattedRecords = unsyncedRecords.map((
          record,
        ) {
          return {
            "EMP_CODE": record["emp_code"],
            "ATDATE": record["atdate"], // Ensure this is in correct Date format
            "IN_OUT_DATE": record["in_out_date"],
            "LATITUDE": record["LATITUDE"].toString(),
            "LONGITUDE": record["LONGITUDE"].toString(),
            "ADDRESS": record["ADDRESS"],
            "MOBILE_NETWORK": record["MOBILE_NETWORK"] ?? "",
          };
        }).toList();
        final response = await http
            .post(
              Uri.parse(
                '${ApiConstant.baseUrl}/api/MobileApi/SaveSqlliteGeoLocation',
              ),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(formattedRecords),
            )
            .timeout(const Duration(seconds: 20));

        if (response.statusCode == 200) {
          try {
            final responseData = jsonDecode(response.body);
            final dynamic dataNode =
                responseData is Map ? responseData['data'] : null;
            if (dataNode is Map && dataNode['IsSuccess'] == true) {
              List<int> syncedIds = unsyncedRecords
                  .map((e) => e['id'] as int)
                  .toList();
              await updateSyncStatus(syncedIds);
              print('Sync successful: ${syncedIds.length} locations pushed');
            } else {
              print('Failed to sync data: ${response.body}');
            }
          } catch (parseError) {
            print('Failed to parse sync response: $parseError '
                '(body: ${response.body})');
          }
        } else {
          print(
            'Sync HTTP ${response.statusCode}: ${response.body}',
          );
        }
      } catch (e) {
        print('Error syncing data: $e');
      }
    } else {
      print('No new data to sync');
    }
  }
}
