import 'package:shared_preferences/shared_preferences.dart';

class FollowService {
  static const String _followedUsersKey = 'followed_users';
  static const String _userFollowersCountPrefix = 'user_followers_count_';
  
  // 获取用户的关注状态
  static Future<bool> isUserFollowed(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final followedUsers = prefs.getStringList(_followedUsersKey) ?? [];
      return followedUsers.contains(userId);
    } catch (e) {
      print('Error getting follow status: $e');
      return false;
    }
  }
  
  // 获取用户的粉丝数量
  static Future<int> getUserFollowersCount(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // 如果没有存储过，返回随机初始值
      int? storedCount = prefs.getInt('$_userFollowersCountPrefix$userId');
      if (storedCount == null) {
        // 使用userId生成一个稳定的随机数
        final hashCode = userId.hashCode;
        storedCount = 1000 + (hashCode.abs() % 9001); // 1000-10000
        await prefs.setInt('$_userFollowersCountPrefix$userId', storedCount);
      }
      return storedCount;
    } catch (e) {
      print('Error getting user followers count: $e');
      return 1000;
    }
  }
  
  // 切换用户的关注状态
  static Future<Map<String, dynamic>> toggleUserFollow(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final followedUsers = prefs.getStringList(_followedUsersKey) ?? [];
      
      // 获取当前关注状态和粉丝数量
      bool isCurrentlyFollowed = followedUsers.contains(userId);
      int currentCount = await getUserFollowersCount(userId);
      
      // 切换关注状态
      bool newFollowStatus = !isCurrentlyFollowed;
      if (newFollowStatus) {
        // 添加关注
        followedUsers.add(userId);
      } else {
        // 取消关注
        followedUsers.remove(userId);
      }
      
      await prefs.setStringList(_followedUsersKey, followedUsers);
      
      // 更新粉丝数量
      int newCount = newFollowStatus ? currentCount + 1 : currentCount - 1;
      await prefs.setInt('$_userFollowersCountPrefix$userId', newCount);
      
      return {
        'isFollowed': newFollowStatus,
        'followersCount': newCount,
      };
    } catch (e) {
      print('Error toggling follow status: $e');
      return {
        'isFollowed': false,
        'followersCount': 1000,
      };
    }
  }
  
  // 获取所有已关注的用户ID列表
  static Future<List<String>> getFollowedUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_followedUsersKey) ?? [];
    } catch (e) {
      print('Error getting followed users: $e');
      return [];
    }
  }
  
  // 清除所有关注记录（用于测试）
  static Future<void> clearAllFollows() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_followedUsersKey);
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_userFollowersCountPrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Error clearing follows: $e');
    }
  }
}

