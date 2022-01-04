import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  // initialize
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // save data
  static Future<bool> save({
    required String key,
    required var value,
  }) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);

    return await sharedPreferences!.setDouble(key, value);
  }

  // reading data
  static dynamic read({required String key}) {
    return sharedPreferences!.get(key);
  }

  // remove
  static Future<bool> remove({required String key}) async {
    return await sharedPreferences!.remove(key);
  }
}
