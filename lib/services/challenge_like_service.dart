import 'package:shared_preferences/shared_preferences.dart';

class ChallengeLikeService {
  static const String _likedChallengesPrefix = 'liked_challenge_';
  static const String _challengeLikesCountPrefix = 'challenge_likes_count_';
  
  // 生成挑战卡片的唯一ID
  static String _getChallengeId(String userId, int imageIndex) {
    return '${userId}_$imageIndex';
  }
  
  // 获取挑战卡片的点赞状态
  static Future<bool> isChallengeLiked(String userId, int imageIndex) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final challengeId = _getChallengeId(userId, imageIndex);
      return prefs.getBool('$_likedChallengesPrefix$challengeId') ?? false;
    } catch (e) {
      print('Error getting challenge like status: $e');
      return false;
    }
  }
  
  // 获取挑战卡片的点赞数量
  static Future<int> getChallengeLikesCount(String userId, int imageIndex) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final challengeId = _getChallengeId(userId, imageIndex);
      // 如果没有存储过，返回随机初始值
      int? storedCount = prefs.getInt('$_challengeLikesCountPrefix$challengeId');
      if (storedCount == null) {
        // 使用userId和imageIndex生成一个稳定的随机数
        final hashCode = challengeId.hashCode;
        storedCount = 100 + (hashCode.abs() % 901); // 100-1000
        await prefs.setInt('$_challengeLikesCountPrefix$challengeId', storedCount);
      }
      return storedCount;
    } catch (e) {
      print('Error getting challenge likes count: $e');
      return 100;
    }
  }
  
  // 切换挑战卡片的点赞状态
  static Future<Map<String, dynamic>> toggleChallengeLike(String userId, int imageIndex) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final challengeId = _getChallengeId(userId, imageIndex);
      
      // 获取当前点赞状态和数量
      bool isCurrentlyLiked = await isChallengeLiked(userId, imageIndex);
      int currentCount = await getChallengeLikesCount(userId, imageIndex);
      
      // 切换点赞状态
      bool newLikeStatus = !isCurrentlyLiked;
      await prefs.setBool('$_likedChallengesPrefix$challengeId', newLikeStatus);
      
      // 更新点赞数量
      int newCount = newLikeStatus ? currentCount + 1 : currentCount - 1;
      await prefs.setInt('$_challengeLikesCountPrefix$challengeId', newCount);
      
      return {
        'isLiked': newLikeStatus,
        'likesCount': newCount,
      };
    } catch (e) {
      print('Error toggling challenge like: $e');
      return {
        'isLiked': false,
        'likesCount': 100,
      };
    }
  }
  
  // 清除所有点赞记录（用于测试）
  static Future<void> clearAllLikes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_likedChallengesPrefix) || 
            key.startsWith(_challengeLikesCountPrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Error clearing challenge likes: $e');
    }
  }
}

