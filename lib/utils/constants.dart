class AppConstants {
  // App Information
  static const String appName = 'Hawn';
  static const String appDescription = 'Creative Challenge Platform';
  
  // Challenge Categories
  static const List<String> challengeCategories = [
    'Art & Design',
    'Photography',
    'Writing',
    'Music',
    'Video',
    'Technology',
    'Fashion',
    'Food',
    'Sports',
    'Other'
  ];
  
  // Challenge Difficulty Levels
  static const List<String> difficultyLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert'
  ];
  
  // Challenge Duration Options (in days)
  static const List<int> durationOptions = [1, 3, 7, 14, 30];
  
  // Challenge Status
  static const String statusActive = 'active';
  static const String statusCompleted = 'completed';
  static const String statusExpired = 'expired';
  static const String statusDraft = 'draft';
  
  // User Roles
  static const String roleCreator = 'creator';
  static const String roleParticipant = 'participant';
  
  // API Endpoints (placeholder for future implementation)
  static const String baseUrl = 'https://api.hawn.com';
  static const String challengesEndpoint = '/challenges';
  static const String usersEndpoint = '/users';
  static const String submissionsEndpoint = '/submissions';
  
  // Local Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userProfileKey = 'user_profile';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  
  // Validation Rules
  static const int minChallengeTitleLength = 3;
  static const int maxChallengeTitleLength = 100;
  static const int minChallengeDescriptionLength = 10;
  static const int maxChallengeDescriptionLength = 1000;
  static const int maxSubmissionFileSize = 10 * 1024 * 1024; // 10MB
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
