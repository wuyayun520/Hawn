class ChallengeUser {
  final String userId;
  final String username;
  final String displayName;
  final String profileImage;
  final String backgroundImage;
  final String bio;
  final String location;
  final String joinDate;
  final ChallengePost challengePost;

  ChallengeUser({
    required this.userId,
    required this.username,
    required this.displayName,
    required this.profileImage,
    required this.backgroundImage,
    required this.bio,
    required this.location,
    required this.joinDate,
    required this.challengePost,
  });

  factory ChallengeUser.fromJson(Map<String, dynamic> json) {
    return ChallengeUser(
      userId: json['user_id'] ?? '',
      username: json['username'] ?? '',
      displayName: json['display_name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      backgroundImage: json['background_image'] ?? '',
      bio: json['bio'] ?? '',
      location: json['location'] ?? '',
      joinDate: json['join_date'] ?? '',
      challengePost: ChallengePost.fromJson(json['challenge_post'] ?? {}),
    );
  }
}

class ChallengePost {
  final String postId;
  final String title;
  final String description;
  final String challengeType;
  final int currentDay;
  final int totalDays;
  final List<ChallengeImage> images;
  final Map<String, dynamic>? workoutDetails;
  final Map<String, dynamic>? stylingDetails;
  final Map<String, dynamic>? recipeDetails;
  final Map<String, dynamic>? progressMetrics;
  final Map<String, dynamic>? nutritionalInfo;
  final Map<String, dynamic>? productInfo;
  final SocialEngagement socialEngagement;
  final String createdAt;
  final String updatedAt;

  ChallengePost({
    required this.postId,
    required this.title,
    required this.description,
    required this.challengeType,
    required this.currentDay,
    required this.totalDays,
    required this.images,
    this.workoutDetails,
    this.stylingDetails,
    this.recipeDetails,
    this.progressMetrics,
    this.nutritionalInfo,
    this.productInfo,
    required this.socialEngagement,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChallengePost.fromJson(Map<String, dynamic> json) {
    return ChallengePost(
      postId: json['post_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      challengeType: json['challenge_type'] ?? '',
      currentDay: json['current_day'] ?? json['current_week'] ?? 0,
      totalDays: json['total_days'] ?? json['total_weeks'] ?? 0,
      images: (json['images'] as List<dynamic>?)
          ?.map((image) => ChallengeImage.fromJson(image))
          .toList() ?? [],
      workoutDetails: json['workout_details'],
      stylingDetails: json['styling_details'],
      recipeDetails: json['recipe_details'],
      progressMetrics: json['progress_metrics'],
      nutritionalInfo: json['nutritional_info'],
      productInfo: json['product_info'],
      socialEngagement: SocialEngagement.fromJson(json['social_engagement'] ?? {}),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class ChallengeImage {
  final String imagePath;
  final String description;
  final String timestamp;

  ChallengeImage({
    required this.imagePath,
    required this.description,
    required this.timestamp,
  });

  factory ChallengeImage.fromJson(Map<String, dynamic> json) {
    return ChallengeImage(
      imagePath: json['image_path'] ?? '',
      description: json['description'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class SocialEngagement {
  final int likes;
  final int comments;
  final int shares;
  final int followers;

  SocialEngagement({
    required this.likes,
    required this.comments,
    required this.shares,
    required this.followers,
  });

  factory SocialEngagement.fromJson(Map<String, dynamic> json) {
    return SocialEngagement(
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
      followers: json['followers'] ?? 0,
    );
  }
}
