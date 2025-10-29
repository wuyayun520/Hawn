class ChallengeVideo {
  final int id;
  final String title;
  final int viewCount;
  final int likeCount;
  final String challengeType;
  final String videoUrl;
  final String description;

  ChallengeVideo({
    required this.id,
    required this.title,
    required this.viewCount,
    required this.likeCount,
    required this.challengeType,
    required this.videoUrl,
    required this.description,
  });

  factory ChallengeVideo.fromJson(Map<String, dynamic> json) {
    return ChallengeVideo(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      viewCount: json['view_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      challengeType: json['challenge_type'] ?? '',
      videoUrl: json['video_url'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'view_count': viewCount,
      'like_count': likeCount,
      'challenge_type': challengeType,
      'video_url': videoUrl,
      'description': description,
    };
  }
}

