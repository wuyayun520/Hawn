import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/challenge_video_model.dart';

class ChallengeVideoService {
  static Future<List<ChallengeVideo>> loadChallengeVideos() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/paranoidCache/challenge_videos.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> videosJson = jsonData['challenge_videos'] ?? [];
      
      return videosJson.map((json) => ChallengeVideo.fromJson(json)).toList();
    } catch (e) {
      print('Error loading challenge videos: $e');
      return [];
    }
  }
}

