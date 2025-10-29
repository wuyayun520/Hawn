import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/trending_challenge_model.dart';

class TrendingChallengeService {
  static Future<List<TrendingChallenge>> loadAllChallenges() async {
    List<TrendingChallenge> allChallenges = [];

    try {
      // Load fitness challenges
      print('Loading fitness challenges...');
      final fitnessData = await _loadJsonFile('assets/responseTool/fitness_challenges_english.json');
      if (fitnessData != null && fitnessData['fitness_challenges'] is List) {
        final fitnessChallenges = (fitnessData['fitness_challenges'] as List)
            .map((e) => TrendingChallenge.fromJson(e, 'fitness'))
            .toList();
        allChallenges.addAll(fitnessChallenges);
        print('Loaded ${fitnessChallenges.length} fitness challenges');
      } else {
        print('Failed to load fitness challenges');
      }

      // Load food challenges
      print('Loading food challenges...');
      final foodData = await _loadJsonFile('assets/responseTool/food_challenges_complete.json');
      if (foodData != null && foodData['food_challenges'] is List) {
        final foodChallenges = (foodData['food_challenges'] as List)
            .map((e) => TrendingChallenge.fromJson(e, 'food'))
            .toList();
        allChallenges.addAll(foodChallenges);
        print('Loaded ${foodChallenges.length} food challenges');
      } else {
        print('Failed to load food challenges');
      }

      // Load hairstyle challenges
      print('Loading hairstyle challenges...');
      final hairstyleData = await _loadJsonFile('assets/responseTool/hairstyle_challenges_complete.json');
      if (hairstyleData != null && hairstyleData['hairstyle_challenges'] is List) {
        final hairstyleChallenges = (hairstyleData['hairstyle_challenges'] as List)
            .map((e) => TrendingChallenge.fromJson(e, 'hairstyle'))
            .toList();
        allChallenges.addAll(hairstyleChallenges);
        print('Loaded ${hairstyleChallenges.length} hairstyle challenges');
      } else {
        print('Failed to load hairstyle challenges');
      }

      print('Total challenges before sorting: ${allChallenges.length}');

      // Sort by creation date (most recent first)
      allChallenges.sort((a, b) => b.challengePost.createdAt.compareTo(a.challengePost.createdAt));

      return allChallenges;
    } catch (e) {
      print('Error loading trending challenges: $e');
      print('Stack trace: ${StackTrace.current}');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> _loadJsonFile(String path) async {
    try {
      final String response = await rootBundle.loadString(path);
      return json.decode(response);
    } catch (e) {
      print('Error loading JSON file $path: $e');
      return null;
    }
  }

  // Group challenges by date
  static Map<String, List<TrendingChallenge>> groupByDate(List<TrendingChallenge> challenges) {
    Map<String, List<TrendingChallenge>> grouped = {};

    for (var challenge in challenges) {
      final date = _formatDate(challenge.challengePost.createdAt);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(challenge);
    }

    return grouped;
  }

  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final challengeDate = DateTime(date.year, date.month, date.day);

    if (challengeDate == today) {
      return 'Today';
    } else if (challengeDate == yesterday) {
      return 'Yesterday';
    } else {
      final months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  // Filter challenges from the last 30 days
  // Note: For demo purposes, we'll show all challenges regardless of date
  static List<TrendingChallenge> filterLastMonth(List<TrendingChallenge> challenges) {
    // Since the JSON data has old dates (January 2024), we'll return all challenges
    // In production, you would use:
    // final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    // return challenges.where((challenge) => 
    //   challenge.challengePost.createdAt.isAfter(thirtyDaysAgo)
    // ).toList();
    
    print('Total challenges loaded: ${challenges.length}');
    return challenges;
  }
}

