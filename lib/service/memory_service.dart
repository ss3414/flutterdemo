import "package:flutter/services.dart";

/* 内存数据服务，用于跨引擎共享数据 */
class MemoryService {
  static const MethodChannel _channel = MethodChannel("com.example.app/memory");

  /* 保存数据到原生层 */
  static Future<bool> saveData(Map<String, dynamic> data,
      {String key = "default"}) async {
    try {
      final result = await _channel.invokeMethod("saveData", {
        "key": key,
        "data": data,
      });
      return result == true;
    } catch (e) {
      print("保存数据失败：$e");
      return false;
    }
  }

  /* 从原生层获取数据 */
  static Future<Map<String, dynamic>?> getData({String key = "default"}) async {
    try {
      final result = await _channel.invokeMethod("getData", {"key": key});
      if (result != null) {
        return Map<String, dynamic>.from(result);
      }
      return null;
    } catch (e) {
      print("获取数据失败：$e");
      return null;
    }
  }

  /* 删除指定键的数据 */
  static Future<bool> removeData({String key = "default"}) async {
    try {
      final result = await _channel.invokeMethod("removeData", {"key": key});
      return result == true;
    } catch (e) {
      print("删除数据失败：$e");
      return false;
    }
  }

  /* 清除所有数据 */
  static Future<bool> clearAllData() async {
    try {
      final result = await _channel.invokeMethod("clearAllData");
      return result == true;
    } catch (e) {
      print("清除数据失败：$e");
      return false;
    }
  }
}
