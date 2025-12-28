import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service for handling local storage operations
class StorageService {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception(
        'StorageService not initialized. Call StorageService.init() first.',
      );
    }
    return _prefs!;
  }

  // ============= String Operations =============

  /// Save string value
  Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  /// Get string value
  String? getString(String key) {
    return prefs.getString(key);
  }

  // ============= Int Operations =============

  /// Save int value
  Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  /// Get int value
  int? getInt(String key) {
    return prefs.getInt(key);
  }

  // ============= Double Operations =============

  /// Save double value
  Future<bool> setDouble(String key, double value) async {
    return await prefs.setDouble(key, value);
  }

  /// Get double value
  double? getDouble(String key) {
    return prefs.getDouble(key);
  }

  // ============= Bool Operations =============

  /// Save bool value
  Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  /// Get bool value
  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  // ============= List Operations =============

  /// Save list of strings
  Future<bool> setStringList(String key, List<String> value) async {
    return await prefs.setStringList(key, value);
  }

  /// Get list of strings
  List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }

  // ============= JSON Operations =============

  /// Save object as JSON
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    final jsonString = jsonEncode(value);
    return await prefs.setString(key, jsonString);
  }

  /// Get object from JSON
  Map<String, dynamic>? getJson(String key) {
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // ============= Other Operations =============

  /// Check if key exists
  bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  /// Remove specific key
  Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  /// Clear all data
  Future<bool> clear() async {
    return await prefs.clear();
  }

  /// Get all keys
  Set<String> getKeys() {
    return prefs.getKeys();
  }
}
