import 'package:flutter/material.dart';

enum ChallengeStatus {
  active,
  completed,
  expired,
  draft,
}

enum ChallengeDifficulty {
  beginner,
  intermediate,
  advanced,
  expert,
}

class Challenge {
  final String id;
  final String title;
  final String description;
  final String category;
  final ChallengeDifficulty difficulty;
  final int durationDays;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime endDate;
  final ChallengeStatus status;
  final String creatorId;
  final String creatorName;
  final String? creatorAvatar;
  final List<String> tags;
  final int participantCount;
  final int submissionCount;
  final String? coverImage;
  final List<String> requirements;
  final Map<String, dynamic>? rewards;
  final bool isPublic;
  final int maxParticipants;

  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.durationDays,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.creatorId,
    required this.creatorName,
    this.creatorAvatar,
    required this.tags,
    required this.participantCount,
    required this.submissionCount,
    this.coverImage,
    required this.requirements,
    this.rewards,
    required this.isPublic,
    required this.maxParticipants,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      difficulty: ChallengeDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => ChallengeDifficulty.beginner,
      ),
      durationDays: json['durationDays'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      status: ChallengeStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ChallengeStatus.active,
      ),
      creatorId: json['creatorId'] as String,
      creatorName: json['creatorName'] as String,
      creatorAvatar: json['creatorAvatar'] as String?,
      tags: List<String>.from(json['tags'] as List),
      participantCount: json['participantCount'] as int,
      submissionCount: json['submissionCount'] as int,
      coverImage: json['coverImage'] as String?,
      requirements: List<String>.from(json['requirements'] as List),
      rewards: json['rewards'] as Map<String, dynamic>?,
      isPublic: json['isPublic'] as bool,
      maxParticipants: json['maxParticipants'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty.name,
      'durationDays': durationDays,
      'createdAt': createdAt.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.name,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'creatorAvatar': creatorAvatar,
      'tags': tags,
      'participantCount': participantCount,
      'submissionCount': submissionCount,
      'coverImage': coverImage,
      'requirements': requirements,
      'rewards': rewards,
      'isPublic': isPublic,
      'maxParticipants': maxParticipants,
    };
  }

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    ChallengeDifficulty? difficulty,
    int? durationDays,
    DateTime? createdAt,
    DateTime? startDate,
    DateTime? endDate,
    ChallengeStatus? status,
    String? creatorId,
    String? creatorName,
    String? creatorAvatar,
    List<String>? tags,
    int? participantCount,
    int? submissionCount,
    String? coverImage,
    List<String>? requirements,
    Map<String, dynamic>? rewards,
    bool? isPublic,
    int? maxParticipants,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      durationDays: durationDays ?? this.durationDays,
      createdAt: createdAt ?? this.createdAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      creatorAvatar: creatorAvatar ?? this.creatorAvatar,
      tags: tags ?? this.tags,
      participantCount: participantCount ?? this.participantCount,
      submissionCount: submissionCount ?? this.submissionCount,
      coverImage: coverImage ?? this.coverImage,
      requirements: requirements ?? this.requirements,
      rewards: rewards ?? this.rewards,
      isPublic: isPublic ?? this.isPublic,
      maxParticipants: maxParticipants ?? this.maxParticipants,
    );
  }

  bool get isActive => status == ChallengeStatus.active;
  bool get isCompleted => status == ChallengeStatus.completed;
  bool get isExpired => status == ChallengeStatus.expired;
  bool get isDraft => status == ChallengeStatus.draft;

  Duration get timeRemaining => endDate.difference(DateTime.now());
  bool get isExpiredByTime => DateTime.now().isAfter(endDate);

  String get difficultyText {
    switch (difficulty) {
      case ChallengeDifficulty.beginner:
        return 'Beginner';
      case ChallengeDifficulty.intermediate:
        return 'Intermediate';
      case ChallengeDifficulty.advanced:
        return 'Advanced';
      case ChallengeDifficulty.expert:
        return 'Expert';
    }
  }

  Color get difficultyColor {
    switch (difficulty) {
      case ChallengeDifficulty.beginner:
        return Colors.green;
      case ChallengeDifficulty.intermediate:
        return Colors.orange;
      case ChallengeDifficulty.advanced:
        return Colors.red;
      case ChallengeDifficulty.expert:
        return Colors.purple;
    }
  }

  String get statusText {
    switch (status) {
      case ChallengeStatus.active:
        return 'Active';
      case ChallengeStatus.completed:
        return 'Completed';
      case ChallengeStatus.expired:
        return 'Expired';
      case ChallengeStatus.draft:
        return 'Draft';
    }
  }

  Color get statusColor {
    switch (status) {
      case ChallengeStatus.active:
        return Colors.green;
      case ChallengeStatus.completed:
        return Colors.blue;
      case ChallengeStatus.expired:
        return Colors.grey;
      case ChallengeStatus.draft:
        return Colors.orange;
    }
  }
}

class ChallengeSubmission {
  final String id;
  final String challengeId;
  final String participantId;
  final String participantName;
  final String? participantAvatar;
  final String title;
  final String description;
  final List<String> mediaUrls;
  final DateTime submittedAt;
  final int likesCount;
  final int commentsCount;
  final bool isWinner;
  final Map<String, dynamic>? metadata;

  const ChallengeSubmission({
    required this.id,
    required this.challengeId,
    required this.participantId,
    required this.participantName,
    this.participantAvatar,
    required this.title,
    required this.description,
    required this.mediaUrls,
    required this.submittedAt,
    required this.likesCount,
    required this.commentsCount,
    required this.isWinner,
    this.metadata,
  });

  factory ChallengeSubmission.fromJson(Map<String, dynamic> json) {
    return ChallengeSubmission(
      id: json['id'] as String,
      challengeId: json['challengeId'] as String,
      participantId: json['participantId'] as String,
      participantName: json['participantName'] as String,
      participantAvatar: json['participantAvatar'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      mediaUrls: List<String>.from(json['mediaUrls'] as List),
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      likesCount: json['likesCount'] as int,
      commentsCount: json['commentsCount'] as int,
      isWinner: json['isWinner'] as bool,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengeId': challengeId,
      'participantId': participantId,
      'participantName': participantName,
      'participantAvatar': participantAvatar,
      'title': title,
      'description': description,
      'mediaUrls': mediaUrls,
      'submittedAt': submittedAt.toIso8601String(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isWinner': isWinner,
      'metadata': metadata,
    };
  }
}
