import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class ProfileService {
  static const String _avatarKey = 'profile_avatar';
  static const String _usernameKey = 'profile_username';
  static const String _signatureKey = 'profile_signature';

  // 保存头像文件名（只保存最后一段名称）
  static Future<void> saveAvatarFileName(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarKey, fileName);
  }

  // 获取头像文件名
  static Future<String?> getAvatarFileName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarKey);
  }

  // 获取完整头像路径
  static Future<String?> getAvatarPath() async {
    final fileName = await getAvatarFileName();
    if (fileName == null) return null;
    
    try {
      final directory = await getApplicationDocumentsDirectory();
      final avatarPath = '${directory.path}/profile_avatar_$fileName';
      final file = File(avatarPath);
      
      if (await file.exists()) {
        return avatarPath;
      }
    } catch (e) {
      print('Error getting avatar path: $e');
    }
    
    return null;
  }

  // 保存头像文件到沙盒
  static Future<String?> saveAvatarFile(File sourceFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = sourceFile.path.split('.').last;
      final fileName = '$timestamp.$extension';
      final avatarPath = '${directory.path}/profile_avatar_$fileName';
      
      await sourceFile.copy(avatarPath);
      await saveAvatarFileName(fileName);
      
      return fileName;
    } catch (e) {
      print('Error saving avatar file: $e');
      return null;
    }
  }

  // 保存用户名
  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  // 获取用户名
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey) ?? 'Username';
  }

  // 保存签名
  static Future<void> saveSignature(String signature) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_signatureKey, signature);
  }

  // 获取签名
  static Future<String> getSignature() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_signatureKey) ?? 'Signature';
  }

  // 清除所有数据
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_avatarKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_signatureKey);
  }
}
