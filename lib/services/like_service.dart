import 'package:shared_preferences/shared_preferences.dart';

class LikeService {
  static const String _likedUsersKey = 'liked_users';
  
  // 获取用户点赞状态
  static Future<bool> isUserLiked(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedUsers = prefs.getStringList(_likedUsersKey) ?? [];
      return likedUsers.contains(userId);
    } catch (e) {
      print('Error getting like status: $e');
      return false;
    }
  }
  
  // 切换用户点赞状态
  static Future<bool> toggleUserLike(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedUsers = prefs.getStringList(_likedUsersKey) ?? [];
      
      bool isCurrentlyLiked = likedUsers.contains(userId);
      
      if (isCurrentlyLiked) {
        // 取消点赞
        likedUsers.remove(userId);
      } else {
        // 添加点赞
        likedUsers.add(userId);
      }
      
      await prefs.setStringList(_likedUsersKey, likedUsers);
      return !isCurrentlyLiked; // 返回新的点赞状态
    } catch (e) {
      print('Error toggling like status: $e');
      return false;
    }
  }
  
  // 获取所有已点赞的用户ID列表
  static Future<List<String>> getLikedUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_likedUsersKey) ?? [];
    } catch (e) {
      print('Error getting liked users: $e');
      return [];
    }
  }
  
  // 清除所有点赞记录（用于测试）
  static Future<void> clearAllLikes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_likedUsersKey);
    } catch (e) {
      print('Error clearing likes: $e');
    }
  }
}
