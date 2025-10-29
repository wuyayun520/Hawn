import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/challenge_user_model.dart';

class ChallengeDataService {
  static Future<List<ChallengeUser>> getFitnessUsers() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/responseTool/fitness_challenges_english.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> usersJson = jsonData['fitness_challenges'] ?? [];
      
      return usersJson.map((userJson) => ChallengeUser.fromJson(userJson)).toList();
    } catch (e) {
      print('Error loading fitness users: $e');
      return [];
    }
  }

  static Future<List<ChallengeUser>> getHairstyleUsers() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/responseTool/hairstyle_challenges_complete.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> usersJson = jsonData['hairstyle_challenges'] ?? [];
      
      return usersJson.map((userJson) => ChallengeUser.fromJson(userJson)).toList();
    } catch (e) {
      print('Error loading hairstyle users: $e');
      return [];
    }
  }

  static Future<List<ChallengeUser>> getFoodUsers() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/responseTool/food_challenges_complete.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> usersJson = jsonData['food_challenges'] ?? [];
      
      return usersJson.map((userJson) => ChallengeUser.fromJson(userJson)).toList();
    } catch (e) {
      print('Error loading food users: $e');
      return [];
    }
  }

  static Future<List<ChallengeUser>> getUsersByType(int typeIndex) async {
    switch (typeIndex) {
      case 0:
        return getFitnessUsers();
      case 1:
        return getHairstyleUsers();
      case 2:
        return getFoodUsers();
      default:
        return [];
    }
  }
}
