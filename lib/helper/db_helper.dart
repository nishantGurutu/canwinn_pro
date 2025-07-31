import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/model/lead_status_lead.dart';
import 'package:task_management/model/source_list_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'canwinn_pro3.db');
    return await openDatabase(path,
        version: 7, onCreate: _createDb, onUpgrade: _onUpgrade);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 7) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS leadStatusList (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        status TEXT,
        created_at TEXT ,
        updated_at TEXT
      )
    ''');
    }
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS responsiblePerson');
    await db.execute('DROP TABLE IF EXISTS locations');
    await db.execute('DROP TABLE IF EXISTS leads');
    await db.execute('DROP TABLE IF EXISTS onlineStatus');
    await db.execute('DROP TABLE IF EXISTS leadSource');
    await db.execute('DROP TABLE IF EXISTS leadStatusList');

    await db.execute('''
      CREATE TABLE responsiblePerson (
        id INTEGER PRIMARY KEY,
        employee_id TEXT,
        name TEXT,
        email TEXT,
        department_id INTEGER,
        company_id INTEGER,
        shift_id INTEGER,
        checkin_type INTEGER,
        attendance_type INTEGER,
        role INTEGER,
        phone TEXT,
        phone2 TEXT,
        image TEXT,
        gender TEXT,
        dob TEXT,
        email_verified_at TEXT,
        recovery_password TEXT,
        location TEXT,
        fcm_token TEXT,
        status INTEGER,
        type INTEGER,
        anniversary_date TEXT,
        anniversary_type TEXT,
        branding_image TEXT,
        is_logged_in INTEGER,
        marital_status TEXT,
        blood_group TEXT,
        father_name TEXT,
        mother_name TEXT,
        spouse_name TEXT,
        physically_challenged TEXT,
        location2 TEXT,
        city TEXT,
        state TEXT,
        pincode TEXT,
        salary_cycle TEXT,
        reporting_manager TEXT,
        staff_type TEXT,
        date_of_joining TEXT,
        uan TEXT,
        panno TEXT,
        adharno TEXT,
        adhar_enrollmentno TEXT,
        pf_no TEXT,
        pf_joining_date TEXT,
        pf_eligible TEXT,
        esi_eligible TEXT,
        esi_no TEXT,
        pt_eligible TEXT,
        lwf_eligible TEXT,
        eps_eligible TEXT,
        eps_joining_date TEXT,
        eps_exit_date TEXT,
        hps_eligible TEXT,
        name_of_bank TEXT,
        ifsc_code TEXT,
        account_no TEXT,
        name_of_account_holder TEXT,
        upi_details TEXT,
        weekoff TEXT,
        device_id TEXT,
        is_head INTEGER,
        assigned_dept TEXT,
        platform TEXT,
        app_version TEXT,
        android_version TEXT,
        model_name TEXT,
        google_access_token TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE locations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        latitude REAL,
        longitude REAL,
        timestamp TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
        CREATE TABLE leads (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          lead_id INTEGER, -- corresponds to API "id"
          lead_number TEXT,
          user_id INTEGER,
          lead_name TEXT,
          lead_type TEXT,
          company TEXT,
          phone TEXT,
          email TEXT,
          source INTEGER,
          designation TEXT,
          gender TEXT,
          status INTEGER,
          no_of_project TEXT,
          description TEXT,
          regional_ofc TEXT,
          reference_details TEXT,
          image TEXT,
          audio TEXT,
          type TEXT,
          address_type TEXT,
          address_line1 TEXT,
          address_line2 TEXT,
          city_town TEXT,
          postal_code TEXT,
          sector_locality TEXT,
          country TEXT,
          state TEXT,
          visiting_card TEXT,
          latitude REAL,
          longitude REAL,
          people_added TEXT,
          assigned_to TEXT,
          is_deleted INTEGER,
          created_at TEXT,
          updated_at TEXT,
          source_name TEXT,
          status_name TEXT,
          owner_name TEXT,
          is_synced INTEGER DEFAULT 0 
        )
      ''');

    await db.execute('''
      CREATE TABLE onlineStatus (
        status TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE leadSource (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        source_name TEXT,
        status TEXT,
        created_at TEXT ,
        updated_at TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE leadStatusList (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        status TEXT,
        created_at TEXT ,
        updated_at TEXT
      )
    ''');
  }

  Future<int> deleteLead(int id) async {
    final db = await database;
    try {
      return await db.delete(
        'leads',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting lead: $e');
      CustomToast().showCustomToast("Failed to delete lead locally.");
      return -1;
    }
  }

  Future<void> clearLeadsTable() async {
    final db = await instance.database;
    await db.delete('leads');
  }

  Future<void> insertStatus({required String status}) async {
    final db = await database;
    await db.insert("onlineStatus", {
      'status': status,
    });
  }

  Future<void> insertLeadSource(SourceListData source) async {
    final db = await database;

    await db.insert(
      'leadSource',
      {
        'id': source.id,
        'source_name': source.sourceName,
        'status': source.status,
        'created_at': source.createdAt,
        'updated_at': source.updatedAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SourceListData>> getLeadSources() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('leadSource');

    return maps.map((map) => SourceListData.fromJson(map)).toList();
  }

  Future<void> insertLeadStatus(LeadStatusData statusData) async {
    final db = await database;

    await db.insert(
      'leadStatusList',
      {
        'id': statusData.id,
        'name': statusData.name,
        'status': statusData.status,
        'created_at': statusData.createdAt,
        'updated_at': statusData.updatedAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LeadStatusData>> getLeadStatus() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('leadStatusList');

    return maps.map((map) => LeadStatusData.fromJson(map)).toList();
  }

  Future<void> insertLead({
    required String leadName,
    required String companyName,
    required String phone,
    required String email,
    required String source,
    required String status,
    required String description,
    required String address,
    required String imagePath,
    required String audioPath,
    required double? latitude,
    required double? longitude,
    required String timestamp,
  }) async {
    final db = await database;

    try {
      await db.insert(
        'leads',
        {
          'lead_name': leadName,
          'company': companyName,
          'phone': phone,
          'email': email,
          'source': source,
          'status': status,
          'description': description,
          'address_line1': address,
          'image': imagePath,
          'audio': audioPath,
          'latitude': latitude,
          'longitude': longitude,
          'created_at': timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      final allLeads = await db.query('leads');
      if (allLeads.isNotEmpty) {
        Get.back();
        CustomToast()
            .showCustomToast("Network not available, data saved locally.");
        print('All leads in database: $allLeads');
      } else {
        print('No leads found in the database after insertion.');
      }
    } catch (e) {
      print('Error inserting lead: $e');
      CustomToast().showCustomToast("Failed to save lead locally.");
    }
  }

  Future<List<Map<String, dynamic>>> getLeads() async {
    final db = await database;
    return await db.query('leads');
  }

  Future<void> insertLocation(
    double latitude,
    double longitude,
    String timestamp,
  ) async {
    try {
      final db = await database;
      await db.insert('locations', {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp,
        'is_synced': 0,
      });
      print('Inserted location: $latitude, $longitude at $timestamp');
      // CustomToast().showCustomToast('Locations saved successfully. in db');
    } catch (e) {
      print('Error inserting location: $e');
      rethrow; // Rethrow to allow caller to handle the error
    }
  }

  Future<List<Map<String, dynamic>>> getUnsyncedLocations() async {
    try {
      final db = await database;
      return await db
          .query('locations', where: 'is_synced = ?', whereArgs: [0]);
    } catch (e) {
      print('Error fetching unsynced locations: $e');
      return [];
    }
  }

  // // Optional: Method to retrieve stored locations for debugging
  // Future<List<Map<String, dynamic>>> getLocations() async {
  //   final db = await database;
  //   return await db.query('locations');
  // }

  Future<List<Map<String, dynamic>>> getLocations() async {
    try {
      final db = await database;
      return await db.query('locations');
    } catch (e) {
      print('Error fetching locations: $e');
      // CustomToast().showCustomToast('Failed to fetch locations');
      return [];
    }
  }
}
