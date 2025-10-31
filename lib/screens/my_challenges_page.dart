import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/challenge_video_model.dart';
import '../services/challenge_video_service.dart';
import '../services/video_hide_service.dart';
import 'video_player_screen.dart';
import 'hawn_subscriptions_screen.dart';

class MyChallengesPage extends StatefulWidget {
  const MyChallengesPage({super.key});

  @override
  State<MyChallengesPage> createState() => _MyChallengesPageState();
}

class _MyChallengesPageState extends State<MyChallengesPage> {
  List<ChallengeVideo> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    final allVideos = await ChallengeVideoService.loadChallengeVideos();
    final filteredVideos = await VideoHideService.filterHiddenVideos(
      allVideos, 
      (video) => video.id,
    );
    setState(() {
      _videos = filteredVideos;
      _isLoading = false;
    });
  }

  // 检查VIP状态并跳转
  Future<void> _navigateToVideo(ChallengeVideo video) async {
    // 检查VIP状态
    final prefs = await SharedPreferences.getInstance();
    final isVip = prefs.getBool('isVip') ?? false;
    
    if (isVip) {
      // VIP用户，直接跳转到视频播放
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(video: video),
        ),
      );
      
      // 如果视频被隐藏，刷新列表
      if (result == true) {
        _loadVideos();
      }
    } else {
      // 非VIP用户，显示订阅提示
      final shouldSubscribe = await _showVipRequiredDialog();
      if (shouldSubscribe == true) {
        // 跳转到订阅页面
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SubscriptionsPage(),
          ),
        );
      }
    }
  }

  // 显示VIP要求对话框
  Future<bool?> _showVipRequiredDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('VIP Required'),
          content: const Text(
            'You need VIP access to watch challenge videos. Subscribe to unlock unlimited access to all content.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAB47BC),
              ),
              child: const Text('Subscribe', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/hawn_rankings_bg.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with trophy and title
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    // Trophy icon
                    Image.asset(
                      'assets/hawn_rankings_bg.webp',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.emoji_events,
                          size: 80,
                          color: Colors.amber,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Title image
                    Image.asset(
                      'assets/hawn_rankings_title.webp',
                      height: 42,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              // Video list
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF9355FF),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100), // Add bottom padding for tabbar
                        itemCount: _videos.length,
                        itemBuilder: (context, index) {
                          return _buildVideoCard(_videos[index], index + 1);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    String medalAsset;
    switch (rank) {
      case 1:
        medalAsset = 'assets/hawn_rankings_medal_one.webp';
        break;
      case 2:
        medalAsset = 'assets/hawn_rankings_medal_two.webp';
        break;
      case 3:
        medalAsset = 'assets/hawn_rankings_medal_three.webp';
        break;
      default:
        medalAsset = 'assets/hawn_rankings_medal_one.webp'; // fallback
    }

    return Image.asset(
      medalAsset,
      width: 50,
      height: 50,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to default badge if image fails to load
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$rank',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoCard(ChallengeVideo video, int rank) {
    return GestureDetector(
      onTap: () => _navigateToVideo(video),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF9355FF).withOpacity(0.3),
              const Color(0xFFE91E63).withOpacity(0.3),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Video thumbnail
              AspectRatio(
                aspectRatio: 16 / 9,
                child: VideoThumbnail(videoUrl: video.videoUrl),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // View count badge (top left)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9355FF), Color(0xFFE91E63)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.remove_red_eye, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${video.viewCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Rank badge (top right) - only show for top 3
              if (rank <= 3)
                Positioned(
                  top: 12,
                  right: 12,
                  child: _buildRankBadge(rank),
                ),
              // Play button
              Positioned.fill(
                child: Center(
                  child: Image.asset(
                    'assets/hawn_rankings_play.webp',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to default play button if image fails to load
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 40,
                          color: Color(0xFF9355FF),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Video info (bottom)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Challenge type tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          video.challengeType,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9355FF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Video title
                      Text(
                        video.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3,
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
        ),
      ),
    );
  }
}

// Widget to display video thumbnail (first frame)
class VideoThumbnail extends StatefulWidget {
  final String videoUrl;

  const VideoThumbnail({super.key, required this.videoUrl});

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoUrl);
      await _controller!.initialize();
      
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    } catch (e) {
      print('Error initializing video ${widget.videoUrl}: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
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
            Icons.video_library,
            size: 60,
            color: Colors.white,
          ),
        ),
      );
    }

    if (_initialized && _controller != null) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      );
    }

    // Loading state
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF9355FF).withOpacity(0.3),
            const Color(0xFFE91E63).withOpacity(0.3),
          ],
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      ),
    );
  }
}