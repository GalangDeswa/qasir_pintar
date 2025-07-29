import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// A wrapper around GetStorage for convenient dependency injection and safety.
class StorageService extends GetxService {
  late final GetStorage _box;

  /// Initialize in main() before calling runApp()
  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  /// Read a value with a fallback if missing
  T read<T>(String key, {required T fallback}) {
    return (_box.read(key) as T?) ?? fallback;
  }

  /// Persist a value
  Future<void> write<T>(String key, T value) {
    return _box.write(key, value);
  }

  /// Remove a single key
  Future<void> remove(String key) {
    return _box.remove(key);
  }

  /// Erase all data stored
  Future<void> erase() {
    return _box.erase();
  }

  /// Check if a key exists
  bool hasKey(String key) {
    return _box.hasData(key);
  }

  /// Get all keys currently stored
  List<String> getKeys() {
    return _box.getKeys().toList();
  }

  /// Read and decode JSON safely
  Map<String, dynamic> readJson(String key, {Map<String, dynamic>? fallback}) {
    final data = _box.read(key);
    if (data is Map<String, dynamic>) {
      return data;
    }
    return fallback ?? {};
  }

  /// Persist JSON-serializable map
  Future<void> writeJson(String key, Map<String, dynamic> value) {
    return _box.write(key, value);
  }
}
