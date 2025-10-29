import 'package:shared_preferences/shared_preferences.dart';

class BlockService {
  static const String _blockedUsersKey = 'blocked_users';
  
  // 获取用户的拉黑状态
  static Future<bool> isUserBlocked(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final blockedUsers = prefs.getStringList(_blockedUsersKey) ?? [];
      return blockedUsers.contains(userId);
    } catch (e) {
      print('Error getting block status: $e');
      return false;
    }
  }
  
  // 切换用户的拉黑状态
  static Future<bool> toggleUserBlock(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final blockedUsers = prefs.getStringList(_blockedUsersKey) ?? [];
      
      bool isCurrentlyBlocked = blockedUsers.contains(userId);
      
      if (isCurrentlyBlocked) {
        // 取消拉黑
        blockedUsers.remove(userId);
      } else {
        // 添加拉黑
        blockedUsers.add(userId);
      }
      
      await prefs.setStringList(_blockedUsersKey, blockedUsers);
      return !isCurrentlyBlocked; // 返回新的拉黑状态
    } catch (e) {
      print('Error toggling block status: $e');
      return false;
    }
  }
  
  // 获取所有已拉黑的用户ID列表
  static Future<List<String>> getBlockedUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_blockedUsersKey) ?? [];
    } catch (e) {
      print('Error getting blocked users: $e');
      return [];
    }
  }
  
  // 清除所有拉黑记录（用于测试）
  static Future<void> clearAllBlocks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_blockedUsersKey);
    } catch (e) {
      print('Error clearing blocks: $e');
    }
  }
}

