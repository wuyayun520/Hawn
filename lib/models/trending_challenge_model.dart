class TrendingChallenge {
  final String userId;
  final String username;
  final String displayName;
  final String profileImage;
  final String backgroundImage;
  final String bio;
  final String location;
  final String joinDate;
  final ChallengePostData challengePost;
  final String categoryType; // 'fitness', 'food', 'hairstyle'

  TrendingChallenge({
    required this.userId,
    required this.username,
    required this.displayName,
    required this.profileImage,
    required this.backgroundImage,
    required this.bio,
    required this.location,
    required this.joinDate,
    required this.challengePost,
    required this.categoryType,
  });

  factory TrendingChallenge.fromJson(Map<String, dynamic> json, String category) {
    return TrendingChallenge(
      userId: json['user_id'] ?? '',
      username: json['username'] ?? '',
      displayName: json['display_name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      backgroundImage: json['background_image'] ?? '',
      bio: json['bio'] ?? '',
      location: json['location'] ?? '',
      joinDate: json['join_date'] ?? '',
      challengePost: ChallengePostData.fromJson(json['challenge_post'] ?? {}),
      categoryType: category,
    );
  }
}

class ChallengePostData {
  final String postId;
  final String title;
  final String description;
  final String challengeType;
  final List<ChallengeImageData> images;
  final SocialEngagementData socialEngagement;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChallengePostData({
    required this.postId,
    required this.title,
    required this.description,
    required this.challengeType,
    required this.images,
    required this.socialEngagement,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChallengePostData.fromJson(Map<String, dynamic> json) {
    return ChallengePostData(
      postId: json['post_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      challengeType: json['challenge_type'] ?? '',
      images: (json['images'] as List?)
              ?.map((e) => ChallengeImageData.fromJson(e))
              .toList() ??
          [],
      socialEngagement: SocialEngagementData.fromJson(json['social_engagement'] ?? {}),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class ChallengeImageData {
  final String imagePath;
  final String description;
  final DateTime timestamp;

  ChallengeImageData({
    required this.imagePath,
    required this.description,
    required this.timestamp,
  });

  factory ChallengeImageData.fromJson(Map<String, dynamic> json) {
    return ChallengeImageData(
      imagePath: json['image_path'] ?? '',
      description: json['description'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class SocialEngagementData {
  final int likes;
  final int comments;
  final int shares;
  final int followers;

  SocialEngagementData({
    required this.likes,
    required this.comments,
    required this.shares,
    required this.followers,
  });

  factory SocialEngagementData.fromJson(Map<String, dynamic> json) {
    return SocialEngagementData(
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
      followers: json['followers'] ?? 0,
    );
  }
}

