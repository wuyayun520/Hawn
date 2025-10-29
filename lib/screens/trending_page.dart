import 'package:flutter/material.dart';
import '../models/trending_challenge_model.dart';
import '../services/trending_challenge_service.dart';
import '../services/trending_post_service.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  List<TrendingChallenge> _challenges = [];
  Map<String, List<TrendingChallenge>> _groupedChallenges = {};
  bool _isLoading = true;
  
  // Track like status and counts for each post
  Map<String, bool> _likedPosts = {};
  Map<String, int> _likeCounts = {};

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  Future<void> _loadChallenges() async {
    print('TrendingPage: Starting to load challenges...');
    final allChallenges = await TrendingChallengeService.loadAllChallenges();
    print('TrendingPage: Loaded ${allChallenges.length} challenges');
    
    final lastMonthChallenges = TrendingChallengeService.filterLastMonth(allChallenges);
    print('TrendingPage: After filtering: ${lastMonthChallenges.length} challenges');
    
    // Filter out reported posts
    final reportedIds = await TrendingPostService.getReportedPostIds();
    final visibleChallenges = lastMonthChallenges.where((challenge) => 
      !reportedIds.contains(challenge.challengePost.postId)
    ).toList();
    
    // Initialize like status and counts for each post
    Map<String, bool> likedPosts = {};
    Map<String, int> likeCounts = {};
    
    for (var challenge in visibleChallenges) {
      final postId = challenge.challengePost.postId;
      
      // Set initial like count if not set
      await TrendingPostService.setInitialLikeCount(
        postId, 
        challenge.challengePost.socialEngagement.likes
      );
      
      // Get like status and count
      likedPosts[postId] = await TrendingPostService.isPostLiked(postId);
      likeCounts[postId] = await TrendingPostService.getPostLikeCount(postId);
    }
    
    final grouped = TrendingChallengeService.groupByDate(visibleChallenges);
    print('TrendingPage: Grouped into ${grouped.length} dates');

    if (mounted) {
      setState(() {
        _challenges = visibleChallenges;
        _groupedChallenges = grouped;
        _likedPosts = likedPosts;
        _likeCounts = likeCounts;
        _isLoading = false;
      });
      print('TrendingPage: State updated, isLoading = false');
    }
  }

  Future<void> _toggleLike(String postId) async {
    try {
      final newLikeStatus = await TrendingPostService.togglePostLike(postId);
      final newLikeCount = await TrendingPostService.getPostLikeCount(postId);
      
      if (mounted) {
        setState(() {
          _likedPosts[postId] = newLikeStatus;
          _likeCounts[postId] = newLikeCount;
        });
      }
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  Future<void> _showReportDialog(TrendingChallenge challenge) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Report Post',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Why are you reporting this post?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _buildReportOption(context, 'Spam or Misleading', '🚫'),
              _buildReportOption(context, 'Inappropriate Content', '⚠️'),
              _buildReportOption(context, 'Harassment or Hate Speech', '🛑'),
              _buildReportOption(context, 'False Information', '❌'),
              _buildReportOption(context, 'Other', '📝'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result != null) {
      await _reportPost(challenge, result);
    }
  }

  Widget _buildReportOption(BuildContext context, String text, String emoji) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(text),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _reportPost(TrendingChallenge challenge, String reason) async {
    try {
      final success = await TrendingPostService.reportPost(
        challenge.challengePost.postId,
        reason,
      );
      
      if (success && mounted) {
        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Post reported and hidden successfully',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () async {
                await TrendingPostService.unreportPost(challenge.challengePost.postId);
                _loadChallenges();
              },
            ),
          ),
        );
        
        // Reload challenges to hide the reported post
        _loadChallenges();
      }
    } catch (e) {
      print('Error reporting post: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to report post',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/hawn_all_bg.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF9355FF),
                  ),
                )
              : _challenges.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No trending challenges',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Loaded ${_groupedChallenges.length} date groups',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _groupedChallenges.length,
                      itemBuilder: (context, index) {
                        final dateKey = _groupedChallenges.keys.elementAt(index);
                        final challenges = _groupedChallenges[dateKey]!;
                        return _buildDateSection(dateKey, challenges);
                      },
                    ),
        ),
      ),
    );
  }

  Widget _buildDateSection(String date, List<TrendingChallenge> challenges) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9355FF), Color(0xFFE91E63)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            date,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Challenges for this date
        ...challenges.map((challenge) => _buildChallengeSection(challenge)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildChallengeSection(TrendingChallenge challenge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile image
                ClipOval(
                  child: Image.asset(
                    challenge.profileImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9355FF), Color(0xFFE91E63)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '@${challenge.username}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(challenge.categoryType).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getCategoryName(challenge.categoryType),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getCategoryColor(challenge.categoryType),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Images
          ...challenge.challengePost.images.asMap().entries.map((entry) {
            return _buildImageSection(entry.value, entry.key == challenge.challengePost.images.length - 1);
          }),
          // Social engagement
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Like button
                GestureDetector(
                  onTap: () => _toggleLike(challenge.challengePost.postId),
                  child: Row(
                    children: [
                      Icon(
                        _likedPosts[challenge.challengePost.postId] == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 18,
                        color: _likedPosts[challenge.challengePost.postId] == true
                            ? Colors.red
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_likeCounts[challenge.challengePost.postId] ?? challenge.challengePost.socialEngagement.likes}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _likedPosts[challenge.challengePost.postId] == true
                              ? Colors.red
                              : Colors.black87,
                          fontWeight: _likedPosts[challenge.challengePost.postId] == true
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Followers
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${challenge.challengePost.socialEngagement.followers}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Report button
                GestureDetector(
                  onTap: () => _showReportDialog(challenge),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF5722), Color(0xFFE91E63)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE91E63).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.report_off,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Report',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(ChallengeImageData imageData, bool isLast) {
    final timestamp = imageData.timestamp;
    final dateStr = '${timestamp.month}/${timestamp.day}/${timestamp.year}';
    final timeStr = '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    
    return ClipRRect(
      borderRadius: isLast 
          ? const BorderRadius.vertical(bottom: Radius.circular(16))
          : BorderRadius.zero,
      child: Stack(
        children: [
          // Large image
          Image.asset(
            imageData.imagePath,
            width: double.infinity,
            height: 400,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF9355FF).withOpacity(0.5),
                      const Color(0xFFE91E63).withOpacity(0.5),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          // Gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date and time
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$dateStr $timeStr',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    imageData.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'fitness':
        return const Color(0xFF4CAF50);
      case 'food':
        return const Color(0xFFFF9800);
      case 'hairstyle':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF9355FF);
    }
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'fitness':
        return '💪 Fitness';
      case 'food':
        return '🍽️ Food';
      case 'hairstyle':
        return '💇 Hairstyle';
      default:
        return category;
    }
  }
}
