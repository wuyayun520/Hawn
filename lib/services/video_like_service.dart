import 'package:shared_preferences/shared_preferences.dart';

class VideoLikeService {
  static const String _likedVideosKey = 'liked_videos';
  static const String _videoLikeCountKey = 'video_like_count_';

  // Check if a video is liked
  static Future<bool> isVideoLiked(int videoId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedVideos = prefs.getStringList(_likedVideosKey) ?? [];
      return likedVideos.contains(videoId.toString());
    } catch (e) {
      print('Error checking video like status: $e');
      return false;
    }
  }

  // Toggle video like status
  static Future<bool> toggleVideoLike(int videoId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedVideos = prefs.getStringList(_likedVideosKey) ?? [];
      
      bool isLiked = likedVideos.contains(videoId.toString());
      
      if (isLiked) {
        // Unlike the video
        likedVideos.remove(videoId.toString());
        await _decrementLikeCount(videoId);
      } else {
        // Like the video
        likedVideos.add(videoId.toString());
        await _incrementLikeCount(videoId);
      }
      
      await prefs.setStringList(_likedVideosKey, likedVideos);
      return !isLiked; // Return new like status
    } catch (e) {
      print('Error toggling video like: $e');
      return false;
    }
  }

  // Get current like count for a video
  static Future<int> getVideoLikeCount(int videoId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('$_videoLikeCountKey$videoId') ?? 0;
    } catch (e) {
      print('Error getting video like count: $e');
      return 0;
    }
  }

  // Set initial like count for a video
  static Future<void> setInitialLikeCount(int videoId, int initialCount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_videoLikeCountKey$videoId';
      
      // Only set if not already set
      if (!prefs.containsKey(key)) {
        await prefs.setInt(key, initialCount);
      }
    } catch (e) {
      print('Error setting initial like count: $e');
    }
  }

  // Increment like count
  static Future<void> _incrementLikeCount(int videoId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_videoLikeCountKey$videoId';
      final currentCount = prefs.getInt(key) ?? 0;
      await prefs.setInt(key, currentCount + 1);
    } catch (e) {
      print('Error incrementing like count: $e');
    }
  }

  // Decrement like count
  static Future<void> _decrementLikeCount(int videoId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_videoLikeCountKey$videoId';
      final currentCount = prefs.getInt(key) ?? 0;
      if (currentCount > 0) {
        await prefs.setInt(key, currentCount - 1);
      }
    } catch (e) {
      print('Error decrementing like count: $e');
    }
  }

  // Get all liked video IDs
  static Future<List<int>> getLikedVideoIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedVideos = prefs.getStringList(_likedVideosKey) ?? [];
      return likedVideos.map((id) => int.parse(id)).toList();
    } catch (e) {
      print('Error getting liked video IDs: $e');
      return [];
    }
  }

  // Clear all like data (for testing/reset)
  static Future<void> clearAllLikeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_likedVideosKey);
      
      // Get all keys and remove like count keys
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_videoLikeCountKey)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Error clearing like data: $e');
    }
  }
}
