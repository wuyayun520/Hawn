import 'package:flutter/material.dart';
import '../models/challenge_user_model.dart';
import '../services/challenge_like_service.dart';
import '../services/follow_service.dart';
import '../services/block_service.dart';
import 'hawn_videocall_screen.dart';
import 'hawn_chat_screen.dart';

class UserDetailScreen extends StatefulWidget {
  final ChallengeUser user;

  const UserDetailScreen({
    super.key,
    required this.user,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  // 存储每个卡片的点赞状态和数量
  Map<int, bool> _likedStatus = {};
  Map<int, int> _likesCount = {};
  
  // 存储用户的关注状态和粉丝数量
  bool _isFollowed = false;
  int _followersCount = 0;
  
  // 存储用户的拉黑状态
  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();
    _loadLikesData();
    _loadFollowData();
    _loadBlockStatus();
  }

  // 加载所有卡片的点赞数据
  Future<void> _loadLikesData() async {
    for (int i = 0; i < widget.user.challengePost.images.length; i++) {
      final isLiked = await ChallengeLikeService.isChallengeLiked(widget.user.userId, i);
      final count = await ChallengeLikeService.getChallengeLikesCount(widget.user.userId, i);
      setState(() {
        _likedStatus[i] = isLiked;
        _likesCount[i] = count;
      });
    }
  }

  // 加载用户的关注数据
  Future<void> _loadFollowData() async {
    final isFollowed = await FollowService.isUserFollowed(widget.user.userId);
    final count = await FollowService.getUserFollowersCount(widget.user.userId);
    setState(() {
      _isFollowed = isFollowed;
      _followersCount = count;
    });
  }

  // 切换点赞状态
  Future<void> _toggleLike(int index) async {
    final result = await ChallengeLikeService.toggleChallengeLike(widget.user.userId, index);
    setState(() {
      _likedStatus[index] = result['isLiked'];
      _likesCount[index] = result['likesCount'];
    });
  }

  // 加载用户的拉黑状态
  Future<void> _loadBlockStatus() async {
    final isBlocked = await BlockService.isUserBlocked(widget.user.userId);
    setState(() {
      _isBlocked = isBlocked;
    });
  }

  // 切换关注状态
  Future<void> _toggleFollow() async {
    final result = await FollowService.toggleUserFollow(widget.user.userId);
    setState(() {
      _isFollowed = result['isFollowed'];
      _followersCount = result['followersCount'];
    });
  }

  // 切换拉黑状态
  Future<void> _toggleBlock() async {
    final newBlockStatus = await BlockService.toggleUserBlock(widget.user.userId);
    setState(() {
      _isBlocked = newBlockStatus;
    });
    
    // 显示提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newBlockStatus ? 'User blocked successfully' : 'User unblocked successfully',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: newBlockStatus ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 举报用户
  void _reportUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Report ${widget.user.displayName}?'),
              const SizedBox(height: 16),
              const Text(
                'Please select a reason:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildReportOption('Inappropriate content'),
              _buildReportOption('Spam or scam'),
              _buildReportOption('Harassment'),
              _buildReportOption('Fake account'),
              _buildReportOption('Other'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // 构建举报选项
  Widget _buildReportOption(String reason) {
    return ListTile(
      title: Text(reason),
      dense: true,
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report submitted: $reason'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  // 显示更多选项菜单
  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(
                  _isBlocked ? Icons.block : Icons.block_outlined,
                  color: Colors.red,
                ),
                title: Text(
                  _isBlocked ? 'Unblock User' : 'Block User',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  _isBlocked 
                      ? 'Remove user from block list'
                      : 'Hide all content from this user',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _toggleBlock();
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.flag_outlined,
                  color: Colors.orange,
                ),
                title: const Text(
                  'Report User',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Report inappropriate behavior',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _reportUser();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/hawn_all_bg.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // User's challenge image at the top (blurred if blocked)
            if (widget.user.challengePost.images.isNotEmpty)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Opacity(
                  opacity: _isBlocked ? 0.3 : 1.0,
                  child: ColorFiltered(
                    colorFilter: _isBlocked 
                        ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                        : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                    child: Image.asset(
                      widget.user.challengePost.images.first.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            // Gradient overlay on challenge image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            ),
          // Main content
          Column(
            children: [
              // Top navigation bar with status bar padding
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Data Details',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    // More options button
                    GestureDetector(
                      onTap: _showMoreOptions,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content area - replaces all content when blocked
              Expanded(
                child: _isBlocked
                    ? Center(
                        child: Container(
                          margin: const EdgeInsets.all(40),
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.block,
                                size: 60,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'User Blocked',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'You have blocked this user.\nContent is hidden.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _toggleBlock,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  'Unblock User',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                          // Profile info section
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: Row(
                              children: [
                                // Profile picture
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(widget.user.profileImage),
                                ),
                                const SizedBox(width: 15),
                                // Name and bio
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.user.displayName,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      if (widget.user.bio.isNotEmpty)
                                        Text(
                                          widget.user.bio,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white70,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                                // Follow button
                                GestureDetector(
                                  onTap: _toggleFollow,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: _isFollowed
                                          ? null
                                          : const LinearGradient(
                                              colors: [Color(0xFF9355FF), Color(0xFFE91E63)],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                      color: _isFollowed ? Colors.grey[400] : null,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _isFollowed ? 'Following' : 'Follow',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // hawn_user_post image - directly after profile
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Image.asset(
                              'assets/hawn_user_post.webp',
                              fit: BoxFit.contain,
                              height: 45,
                            ),
                          ),
                          // Content grid section
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: GridView.builder(
                                padding: const EdgeInsets.only(top: 12, bottom: 16),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.8,
                                ),
                                itemCount: widget.user.challengePost.images.length,
                                itemBuilder: (context, index) {
                                  return _buildChallengeCard(index);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
          // Floating action buttons at bottom - hidden when blocked
          if (!_isBlocked)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Video call button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Convert ChallengeUser to HawnVideoCallUser and navigate
                          final hawnUser = HawnVideoCallUser(
                            id: widget.user.userId,
                            name: widget.user.displayName,
                            displayName: widget.user.displayName,
                            avatar: widget.user.profileImage,
                            background: widget.user.challengePost.images.isNotEmpty
                                ? widget.user.challengePost.images.first.imagePath
                                : 'assets/responseTool/fitness1/fitness1.webp',
                          );
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HawnVideoCallScreen(user: hawnUser),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/hawn_user_videocall.webp',
                          fit: BoxFit.contain,
                          height: 50,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Chat button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to HawnChatScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HawnChatScreen(
                                userId: widget.user.userId,
                                userName: widget.user.displayName,
                                userAvatar: widget.user.profileImage,
                              ),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/hawn_user_chat.webp',
                          fit: BoxFit.contain,
                          height: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(int index) {
    final image = widget.user.challengePost.images[index];
    final likes = _likesCount[index] ?? 100;
    final isLiked = _likedStatus[index] ?? false;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Main image
          Image.asset(
            image.imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Likes badge - clickable
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => _toggleLike(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isLiked 
                      ? Colors.blue.withValues(alpha: 0.9)
                      : Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.thumb_up,
                      color: isLiked ? Colors.white : Colors.blue,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$likes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isLiked ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Hashtag
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Text(
              '#${widget.user.challengePost.title.replaceAll(' ', '')}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
