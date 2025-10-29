import 'package:shared_preferences/shared_preferences.dart';

class VideoHideService {
  static const String _hiddenVideosKey = 'hidden_videos';

  // Hide a video
  static Future<bool> hideVideo(int videoId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hiddenVideos = prefs.getStringList(_hiddenVideosKey) ?? [];
      
      if (!hiddenVideos.contains(videoId.toString())) {
        hiddenVideos.add(videoId.toString());
        await prefs.setStringList(_hiddenVideosKey, hiddenVideos);
        return true;
      }
      return false;
    } catch (e) {
      print('Error hiding video: $e');
      return false;
    }
  }

  // Check if a video is hidden
  static Future<bool> isVideoHidden(int videoId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hiddenVideos = prefs.getStringList(_hiddenVideosKey) ?? [];
      return hiddenVideos.contains(videoId.toString());
    } catch (e) {
      print('Error checking video hide status: $e');
      return false;
    }
  }

  // Get all hidden video IDs
  static Future<List<int>> getHiddenVideoIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hiddenVideos = prefs.getStringList(_hiddenVideosKey) ?? [];
      return hiddenVideos.map((id) => int.parse(id)).toList();
    } catch (e) {
      print('Error getting hidden video IDs: $e');
      return [];
    }
  }

  // Unhide a video
  static Future<bool> unhideVideo(int videoId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hiddenVideos = prefs.getStringList(_hiddenVideosKey) ?? [];
      
      if (hiddenVideos.contains(videoId.toString())) {
        hiddenVideos.remove(videoId.toString());
        await prefs.setStringList(_hiddenVideosKey, hiddenVideos);
        return true;
      }
      return false;
    } catch (e) {
      print('Error unhiding video: $e');
      return false;
    }
  }

  // Clear all hidden videos (for testing/reset)
  static Future<void> clearAllHiddenVideos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_hiddenVideosKey);
    } catch (e) {
      print('Error clearing hidden videos: $e');
    }
  }

  // Filter videos to exclude hidden ones
  static Future<List<T>> filterHiddenVideos<T>(List<T> videos, int Function(T) getId) async {
    try {
      final hiddenIds = await getHiddenVideoIds();
      return videos.where((video) => !hiddenIds.contains(getId(video))).toList();
    } catch (e) {
      print('Error filtering hidden videos: $e');
      return videos;
    }
  }
}
