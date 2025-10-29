import 'package:shared_preferences/shared_preferences.dart';

class TrendingPostService {
  static const String _likedPostsKey = 'liked_trending_posts';
  static const String _postLikeCountKey = 'trending_post_like_count_';
  static const String _reportedPostsKey = 'reported_trending_posts';

  // ==================== Like Functionality ====================
  
  // Check if a post is liked
  static Future<bool> isPostLiked(String postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedPosts = prefs.getStringList(_likedPostsKey) ?? [];
      return likedPosts.contains(postId);
    } catch (e) {
      print('Error checking post like status: $e');
      return false;
    }
  }

  // Toggle post like status
  static Future<bool> togglePostLike(String postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedPosts = prefs.getStringList(_likedPostsKey) ?? [];
      
      bool isLiked = likedPosts.contains(postId);
      
      if (isLiked) {
        // Unlike the post
        likedPosts.remove(postId);
        await _decrementLikeCount(postId);
      } else {
        // Like the post
        likedPosts.add(postId);
        await _incrementLikeCount(postId);
      }
      
      await prefs.setStringList(_likedPostsKey, likedPosts);
      return !isLiked; // Return new like status
    } catch (e) {
      print('Error toggling post like: $e');
      return false;
    }
  }

  // Get current like count for a post
  static Future<int> getPostLikeCount(String postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('$_postLikeCountKey$postId') ?? 0;
    } catch (e) {
      print('Error getting post like count: $e');
      return 0;
    }
  }

  // Set initial like count for a post
  static Future<void> setInitialLikeCount(String postId, int initialCount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_postLikeCountKey$postId';
      
      // Only set if not already set
      if (!prefs.containsKey(key)) {
        await prefs.setInt(key, initialCount);
      }
    } catch (e) {
      print('Error setting initial like count: $e');
    }
  }

  // Increment like count
  static Future<void> _incrementLikeCount(String postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_postLikeCountKey$postId';
      final currentCount = prefs.getInt(key) ?? 0;
      await prefs.setInt(key, currentCount + 1);
    } catch (e) {
      print('Error incrementing like count: $e');
    }
  }

  // Decrement like count
  static Future<void> _decrementLikeCount(String postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_postLikeCountKey$postId';
      final currentCount = prefs.getInt(key) ?? 0;
      if (currentCount > 0) {
        await prefs.setInt(key, currentCount - 1);
      }
    } catch (e) {
      print('Error decrementing like count: $e');
    }
  }

  // ==================== Report Functionality ====================
  
  // Report a post
  static Future<bool> reportPost(String postId, String reason) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportedPosts = prefs.getStringList(_reportedPostsKey) ?? [];
      
      if (!reportedPosts.contains(postId)) {
        reportedPosts.add(postId);
        await prefs.setStringList(_reportedPostsKey, reportedPosts);
        
        // Store report reason
        await prefs.setString('report_reason_$postId', reason);
        await prefs.setString('report_time_$postId', DateTime.now().toIso8601String());
        
        return true;
      }
      return false;
    } catch (e) {
      print('Error reporting post: $e');
      return false;
    }
  }

  // Check if a post is reported
  static Future<bool> isPostReported(String postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportedPosts = prefs.getStringList(_reportedPostsKey) ?? [];
      return reportedPosts.contains(postId);
    } catch (e) {
      print('Error checking post report status: $e');
      return false;
    }
  }

  // Get all reported post IDs
  static Future<List<String>> getReportedPostIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_reportedPostsKey) ?? [];
    } catch (e) {
      print('Error getting reported post IDs: $e');
      return [];
    }
  }

  // Unreport a post (for testing/undo)
  static Future<bool> unreportPost(String postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportedPosts = prefs.getStringList(_reportedPostsKey) ?? [];
      
      if (reportedPosts.contains(postId)) {
        reportedPosts.remove(postId);
        await prefs.setStringList(_reportedPostsKey, reportedPosts);
        await prefs.remove('report_reason_$postId');
        await prefs.remove('report_time_$postId');
        return true;
      }
      return false;
    } catch (e) {
      print('Error unreporting post: $e');
      return false;
    }
  }

  // Clear all data (for testing/reset)
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_likedPostsKey);
      await prefs.remove(_reportedPostsKey);
      
      // Clear all like count and report data
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_postLikeCountKey) || 
            key.startsWith('report_reason_') || 
            key.startsWith('report_time_')) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
}

