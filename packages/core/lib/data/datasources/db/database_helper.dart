import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:task/data/models/task_table.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblProjects = 'projects';
  static const String _tblTasks = 'tasks';
  static const String _tblMaterials = 'materials';
  static const String _tblProgressLogs = 'progress_logs';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/project_box.db';

    var db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('PRAGMA foreign_keys = ON');

    await db.execute('''
      CREATE TABLE $_tblProjects (
        id INTEGER NOT NULL,
        name TEXT,
        description TEXT,
        cover_image_path TEXT,
        status TEXT,
        creation_date INTEGER,
        completion_date INTEGER,
        PRIMARY KEY (id)
      );
    ''');
    await db.execute('''
      CREATE TABLE $_tblTasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        project_id INTEGER NOT NULL,
        parent_task_id INTEGER,
        title TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        order_sequence INTEGER,
        due_date INTEGER,
        priority INTEGER,
        description TEXT,
        FOREIGN KEY (project_id) REFERENCES $_tblProjects (id) ON DELETE CASCADE,
        FOREIGN KEY (parent_task_id) REFERENCES $_tblTasks (id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE $_tblMaterials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        project_id INTEGER NOT NULL,
        item_name TEXT NOT NULL,
        quantity REAL,
        unit TEXT,
        estimated_price REAL,
        actual_price REAL,
        is_acquired INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (project_id) REFERENCES $_tblProjects (id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE $_tblProgressLogs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        project_id INTEGER NOT NULL,
        image_path TEXT,
        log_text TEXT,
        log_date INTEGER NOT NULL,
        FOREIGN KEY (project_id) REFERENCES $_tblProjects (id) ON DELETE CASCADE
      );
    ''');
  }

  Future<Map<String, int>> getDashboardStats() async {
    final db = await database;
    if (db == null) {
      return {'completedProjects': 0, 'totalTasksDone': 0};
    }

    final completedProjectsResult = await db.rawQuery(
      "SELECT COUNT(*) FROM projects WHERE status = 'Done'",
    );
    final completedProjects =
        Sqflite.firstIntValue(completedProjectsResult) ?? 0;

    final totalTasksDoneResult = await db.rawQuery(
      "SELECT COUNT(*) FROM tasks WHERE is_completed = 1",
    );
    final totalTasksDone = Sqflite.firstIntValue(totalTasksDoneResult) ?? 0;
    return {
      'completedProjects': completedProjects,
      'totalTasksDone': totalTasksDone,
      'productiveStreak': 0,
    };
  }

  // --- Fungsi Upgrade Skema ---
  // PERINGATAN: Metode ini bersifat destruktif (menghapus semua data).
  // Hanya cocok untuk tahap pengembangan.
  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Di aplikasi produksi, Anda akan menggunakan ALTER TABLE untuk mengubah skema
    // tanpa menghapus data pengguna.
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS $_tblProgressLogs');
      await db.execute('DROP TABLE IF EXISTS $_tblMaterials');
      await db.execute('DROP TABLE IF EXISTS $_tblTasks');
      await db.execute('DROP TABLE IF EXISTS $_tblProjects');
      _onCreate(db, newVersion);
    }
  }

  // --- Metode CRUD (Create, Read, Update, Delete) untuk Projects ---

  // Create: Menambahkan project baru
  Future<int> insertProject(Map<String, dynamic> project) async {
    final db = await database;
    return await db!.insert(_tblProjects, project);
  }

  // Read: Mendapatkan detail project
  Future<Map<String, dynamic>> getProjectById(int id) async {
    final db = await database;

    // Ambil data proyek utama
    final projectResult = await db!.query(
      _tblProjects,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (projectResult.isEmpty) {
      throw Exception('Project not found');
    }

    final project = projectResult.first;

    // Ambil semua tasks yang terkait dengan proyek
    final taskResults = await db.query(
      _tblTasks,
      where: 'project_id = ?',
      whereArgs: [id],
    );

    // Ambil semua logs yang terkait dengan proyek
    final logResults = await db.query(
      _tblProgressLogs,
      where: 'project_id = ?',
      whereArgs: [id],
    );

    return {...project, 'tasks': taskResults, 'logs': logResults};
  }

  // Read: Mendapatkan semua projects
  Future<List<Map<String, dynamic>>> getProjects(int? limit) async {
    final db = await database;
    return await db!.query(
      _tblProjects,
      orderBy: 'creation_date DESC',
      limit: limit,
    );
  }

  Future<void> updateProjectsStatus(List<int> ids, String newStatus) async {
    final db = await database;
    if (db == null || ids.isEmpty) return;

    final batch = db.batch();

    // Buat satu query update untuk semua ID yang diberikan
    batch.update(
      _tblProjects, // Nama tabel proyek Anda
      {'status': newStatus},
      // Gunakan 'IN' clause untuk mencocokkan beberapa ID
      where: 'id IN (${ids.map((_) => '?').join(', ')})',
      whereArgs: ids,
    );

    await batch.commit(noResult: true);
  }

  // --- FUNGSI BARU UNTUK MENGHAPUS BEBERAPA PROYEK ---
  Future<void> removeProjects(List<int> ids) async {
    final db = await database;
    if (db == null || ids.isEmpty) return;

    final batch = db.batch();

    // Buat satu query delete untuk semua ID yang diberikan
    batch.delete(
      _tblProjects, // Nama tabel proyek Anda
      where: 'id IN (${ids.map((_) => '?').join(', ')})',
      whereArgs: ids,
    );

    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getProjectWithProgress(int? limit) async {
    final db = await database;
    return await db!.rawQuery('''
    SELECT 
      p.*,
      COUNT(t.id) as total_tasks,
      SUM(CASE WHEN t.is_completed = 1 THEN 1 ELSE 0 END) as completed_tasks
    FROM $_tblProjects p
    LEFT JOIN $_tblTasks t ON p.id = t.project_id
    GROUP BY p.id
    ORDER BY p.creation_date DESC
    ${limit != null ? 'LIMIT $limit' : ''}
  ''');
  }

  Future<int> updateProject(int id, Map<String, dynamic> project) async {
    final db = await database;
    return await db!.update(
      _tblProjects,
      project,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete: Menghapus project (dan semua data terkaitnya berkat ON DELETE CASCADE)
  Future<int> deleteProject(int id) async {
    final db = await database;
    return await db!.delete(_tblProjects, where: 'id = ?', whereArgs: [id]);
  }

  // --- Metode CRUD (Create, Read, Update, Delete) untuk Tasks ---
  Future<int> insertTask(int projectId, Map<String, dynamic> task) async {
    final db = await database;

    // Tambahkan projectId ke dalam map task
    final newTask = {
      ...task,
      'project_id': projectId, // pastikan kolom ini memang ada di tabel
    };

    return await db!.insert(_tblTasks, newTask);
  }

  Future<Map<String, int>> getTaskCountsForProject(int projectId) async {
    final db = await database;
    if (db == null) return {'total': 0, 'completed': 0};

    // Query untuk menghitung total tugas
    final totalResult = await db.rawQuery(
      'SELECT COUNT(*) FROM $_tblTasks WHERE project_id = ?',
      [projectId],
    );
    final totalTasks = Sqflite.firstIntValue(totalResult) ?? 0;

    // Query untuk menghitung tugas yang sudah selesai
    final completedResult = await db.rawQuery(
      'SELECT COUNT(*) FROM $_tblTasks WHERE project_id = ? AND is_completed = 1',
      [projectId],
    );
    final completedTasks = Sqflite.firstIntValue(completedResult) ?? 0;

    return {'total': totalTasks, 'completed': completedTasks};
  }

  Future<List<Map<String, dynamic>>> getNextTasks({int limit = 3}) async {
    final db = await database;
    if (db == null) return [];

    // Query ini menggabungkan tabel tugas dan proyek,
    // memfilter hanya tugas yang belum selesai dari proyek yang aktif,
    // mengurutkannya, dan membatasinya.
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT
        T.id,
        T.title,
        T.is_completed,
        T.order_sequence,
        T.due_date,
        T.priority,
        T.description,
        T.parent_task_id,
        T.project_id,
        P.name as project_name
      FROM tasks T
      INNER JOIN projects P ON T.project_id = P.id
      WHERE T.is_completed = 0 AND P.status = 'Active'
      ORDER BY T.priority DESC, T.due_date ASC, T.order_sequence ASC, P.creation_date DESC
      LIMIT ?
    ''',
      [limit],
    );

    return result;
  }

  Future<List<Map<String, dynamic>>> getTasksForProject(int projectId) async {
    final db = await database;
    return await db!.query(
      _tblTasks,
      where: 'project_id = ?',
      whereArgs: [projectId],
      orderBy: 'parent_task_id ASC, order_sequence ASC',
    );
  }

  Future<int> updateTask(int id, Map<String, dynamic> task) async {
    final db = await database;
    return await db!.update(_tblTasks, task, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db!.delete(_tblTasks, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTasksOrder(List<TaskTable> tasks) async {
    final db = await database;
    if (db == null) return;

    // Gunakan batch untuk performa yang lebih baik saat melakukan banyak update
    final batch = db.batch();

    // Iterasi melalui daftar tugas yang sudah diurutkan ulang
    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      // Update kolom 'order_sequence' berdasarkan posisi baru (indeks)
      batch.update(
        _tblTasks, // Nama tabel tugas Anda
        {'order_sequence': i},
        where: 'id = ?',
        whereArgs: [task.id],
      );
    }

    // Jalankan semua operasi update dalam satu batch
    await batch.commit(noResult: true);
  }

  Future<void> updateTaskStatus(int taskId, bool isCompleted) async {
    final db = await database;
    if (db == null) return;

    await db.update(
      _tblTasks, // Nama tabel tugas Anda
      {
        'is_completed': isCompleted
            ? 1
            : 0, // Ubah boolean menjadi integer (1 atau 0)
      },
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  // --- Metode CRUD (Create, Read, Update, Delete) untuk Materials ---

  Future<int> insertMaterial(Map<String, dynamic> material) async {
    final db = await database;
    return await db!.insert(_tblMaterials, material);
  }

  Future<List<Map<String, dynamic>>> getMaterialsForProject(
    int projectId,
  ) async {
    final db = await database;
    return await db!.query(
      _tblMaterials,
      where: 'project_id = ?',
      whereArgs: [projectId],
      orderBy: 'item_name ASC',
    );
  }

  Future<int> updateMaterial(int id, Map<String, dynamic> material) async {
    final db = await database;
    return await db!.update(
      _tblMaterials,
      material,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMaterial(int id) async {
    final db = await database;
    return await db!.delete(_tblMaterials, where: 'id = ?', whereArgs: [id]);
  }

  // --- Metode CRUD (Create, Read, Update, Delete) untuk ProgressLogs  ---
  Future<int> insertProgressLog(int projectId, Map<String, dynamic> log) async {
    final db = await database;

    final newLog = {
      ...log,
      'project_id': projectId, // pastikan kolom ini memang ada di tabel
    };
    return await db!.insert(_tblProgressLogs, newLog);
  }

  Future<List<Map<String, dynamic>>> getProgressLogsForProject(
    int projectId,
  ) async {
    final db = await database;
    return await db!.query(
      _tblProgressLogs,
      where: 'project_id = ?',
      whereArgs: [projectId],
      orderBy: 'log_date DESC', // Log terbaru muncul di atas
    );
  }

  Future<int> updateProgressLog(int id, Map<String, dynamic> log) async {
    final db = await database;
    return await db!.update(
      _tblProgressLogs,
      log,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProgressLog(int id) async {
    final db = await database;
    final logToDelete = await db!.query(
      _tblProgressLogs,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (logToDelete.isNotEmpty) {
      final imagePath = logToDelete.first['image_path'] as String?;
      if (imagePath != null && imagePath.isNotEmpty) {
        try {
          final file = File(imagePath);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          // ignore: avoid_print
          print('Error deleting file: $e');
        }
      }
    }
    return await db.delete(_tblProgressLogs, where: 'id = ?', whereArgs: [id]);
  }
}
