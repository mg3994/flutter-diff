import 'dart:async';

class ZeroSQLiteDatabase {
  final String path;
  bool _isOpen = false;
  final Map<String, List<Map<String, dynamic>>> _tables = {};

  ZeroSQLiteDatabase({required this.path});

  bool get isOpen => _isOpen;

  Future<void> open() async {
    _isOpen = true;
  }

  Future<void> execute(String sql) async {
    if (!_isOpen) throw Exception('Database not open');
  }

  Future<void> insert(String table, Map<String, dynamic> row) async {
    if (!_isOpen) throw Exception('Database not open');
    _tables.putIfAbsent(table, () => []).add(Map<String, dynamic>.from(row));
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    if (!_isOpen) throw Exception('Database not open');
    return _tables[table] ?? [];
  }

  Future<void> close() async {
    _isOpen = false;
    _tables.clear();
  }
}
