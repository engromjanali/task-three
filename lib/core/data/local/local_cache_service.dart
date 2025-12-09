import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCacheService {
  static const String keyAdd = 'pending_add';
  static const String keyDelete = 'pending_delete';
  static const String keyUpdate = 'pending_update';

  /// General method: get list by key
  Future<List<Map<String, dynamic>>> getList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? [];
    return list.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  /// General method: save list back to storage
  Future<void> saveList(String key, List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = list.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList(key, encoded);
  }

  /// ---- PUBLIC APIs ----

  /// Add ONE pending item to a specific category
  Future<void> savePending(String key, Map<String, dynamic> data) async {
    final list = await getList(key);
    list.add(data);
    await saveList(key, list);
  }

  /// Get all pending items of a specific category
  Future<List<Map<String, dynamic>>> getPending(String key) async {
    return await getList(key);
  }

  /// Clear ALL items of a specific category
  Future<void> clearPending(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  /// Remove ONE item by index
  Future<void> removeAt(String key, int index) async {
    final list = await getList(key);

    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      await saveList(key, list);
    }
  }

  /// Remove ONE item matching a condition (example: remove by id)
  Future<void> removeById(String key, int id) async {
    final list = await getList(key);
    list.removeWhere((item) => item['id'] == id);
    await saveList(key, list);
  }

  /// ---- Shortcuts: category-specific ----

  Future<void> saveAdd(Map<String, dynamic> data) =>
      savePending(keyAdd, data);

  Future<void> saveDelete(Map<String, dynamic> data) =>
      savePending(keyDelete, data);

  Future<void> saveUpdate(Map<String, dynamic> data) =>
      savePending(keyUpdate, data);

  Future<List<Map<String, dynamic>>> getAddList() =>
      getPending(keyAdd);

  Future<List<Map<String, dynamic>>> getDeleteList() =>
      getPending(keyDelete);

  Future<List<Map<String, dynamic>>> getUpdateList() =>
      getPending(keyUpdate);

  Future<void> clearAdd() => clearPending(keyAdd);
  Future<void> clearDelete() => clearPending(keyDelete);
  Future<void> clearUpdate() => clearPending(keyUpdate);
}
