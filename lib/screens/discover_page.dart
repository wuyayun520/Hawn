import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/challenge_user_model.dart';
import '../services/challenge_data_service.dart';
import '../services/like_service.dart';
import 'user_detail_screen.dart';
import 'hawn_inapppurchases_screen.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  int _selectedTypeIndex = 0;
  int _currentUserIndex = 0;
  List<ChallengeUser> _currentUsers = [];
  List<ChallengeUser> _groupMembers = []; // 存储群组成员
  bool _isLoading = false;
  Map<String, bool> _likeStatus = {}; // 存储每个用户的点赞状态
  Map<String, bool> _unlockedUsers = {}; // 存储已解锁的用户
  int _goldCoins = 0; // 当前金币余额
  static const int UNLOCK_COST = 88; // 解锁用户所需金币

  final List<String> _typeNormalImages = [
    'assets/type/hawn_home_type1_nor.webp',
    'assets/type/hawn_home_type2_nor.webp',
    'assets/type/hawn_home_type3_nor.webp',
  ];

  final List<String> _typeSelectedImages = [
    'assets/type/hawn_home_type1_selete.webp',
    'assets/type/hawn_home_type2_selete.webp',
    'assets/type/hawn_home_type3_selete.webp',
  ];

  @override
  void initState() {
    super.initState();
    _loadGoldCoins();
    _loadUnlockedUsers();
    _loadUsersForType(0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 每次页面重新显示时刷新金币数据
    _loadGoldCoins();
  }

  Future<void> _loadGoldCoins() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _goldCoins = prefs.getInt('petCoins') ?? 0;
    });
  }

  Future<void> _loadUnlockedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedUsersJson = prefs.getString('unlocked_users') ?? '{}';
    // 这里简化处理，实际项目中可能需要更复杂的JSON解析
    setState(() {
      _unlockedUsers = Map<String, bool>.from(
        unlockedUsersJson.split(',').fold<Map<String, bool>>(
          {},
          (map, userId) {
            if (userId.isNotEmpty) {
              map[userId] = true;
            }
            return map;
          },
        ),
      );
    });
  }

  Future<void> _saveUnlockedUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    _unlockedUsers[userId] = true;
    final unlockedUsersList = _unlockedUsers.keys.toList();
    await prefs.setString('unlocked_users', unlockedUsersList.join(','));
  }

  Future<void> _loadUsersForType(int typeIndex) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await ChallengeDataService.getUsersByType(typeIndex);
      
      // 随机选择3个用户作为群组成员（排除当前用户）
      List<ChallengeUser> availableUsers = List.from(users);
      List<ChallengeUser> groupMembers = [];
      
      // 随机选择3个用户
      for (int i = 0; i < 3 && availableUsers.isNotEmpty; i++) {
        final randomIndex = (DateTime.now().millisecondsSinceEpoch + i) % availableUsers.length;
        groupMembers.add(availableUsers[randomIndex]);
        availableUsers.removeAt(randomIndex);
      }
      
      // 加载每个用户的点赞状态
      Map<String, bool> likeStatus = {};
      for (var user in users) {
        likeStatus[user.userId] = await LikeService.isUserLiked(user.userId);
      }
      
      setState(() {
        _currentUsers = users;
        _groupMembers = groupMembers;
        _currentUserIndex = 0;
        _likeStatus = likeStatus;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading users: $e');
    }
  }

  void _nextUser() {
    if (_currentUsers.isNotEmpty) {
      setState(() {
        _currentUserIndex = (_currentUserIndex + 1) % _currentUsers.length;
      });
    }
  }

  void _previousUser() {
    if (_currentUsers.isNotEmpty) {
      setState(() {
        _currentUserIndex = (_currentUserIndex - 1 + _currentUsers.length) % _currentUsers.length;
      });
    }
  }

  // 检查用户解锁状态并跳转
  Future<void> _navigateToUser(ChallengeUser user) async {
    // 检查用户是否已解锁
    if (_unlockedUsers[user.userId] == true) {
      // 已解锁，直接跳转
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailScreen(user: user),
        ),
      );
    } else {
      // 未解锁，检查金币是否足够
      if (_goldCoins >= UNLOCK_COST) {
        // 金币足够，显示确认对话框
        final shouldUnlock = await _showUnlockConfirmationDialog(user);
        if (shouldUnlock == true) {
          // 用户确认解锁
          await _unlockUser(user);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailScreen(user: user),
            ),
          );
        }
          } else {
            // 金币不足，提示充值
            final shouldRecharge = await _showInsufficientCoinsDialog();
            if (shouldRecharge == true) {
              // 跳转到充值页面，等待返回后刷新金币数据
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InAppPurchasesPage(),
                ),
              );
              // 从充值页面返回后，重新加载金币数据
              await _loadGoldCoins();
            }
          }
    }
  }

  // 随机选择用户并跳转到详情页面
  Future<void> _navigateToRandomUser() async {
    try {
      // 获取所有类型的用户
      List<ChallengeUser> allUsers = [];
      for (int i = 0; i < 3; i++) {
        final users = await ChallengeDataService.getUsersByType(i);
        allUsers.addAll(users);
      }
      
      if (allUsers.isNotEmpty) {
        // 随机选择一个用户
        final randomIndex = DateTime.now().millisecondsSinceEpoch % allUsers.length;
        final selectedUser = allUsers[randomIndex];
        
        // 使用统一的用户跳转逻辑
        await _navigateToUser(selectedUser);
      }
    } catch (e) {
      print('Error navigating to random user: $e');
    }
  }

  // 解锁用户
  Future<void> _unlockUser(ChallengeUser user) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 扣除金币
    final newGoldCoins = _goldCoins - UNLOCK_COST;
    await prefs.setInt('petCoins', newGoldCoins);
    
    // 保存解锁状态
    await _saveUnlockedUser(user.userId);
    
    // 更新本地状态
    setState(() {
      _goldCoins = newGoldCoins;
      _unlockedUsers[user.userId] = true;
    });
  }

  // 显示解锁确认对话框
  Future<bool?> _showUnlockConfirmationDialog(ChallengeUser user) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unlock User'),
          content: Text(
            'Unlock ${user.displayName} for $UNLOCK_COST gold coins?',
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
              child: const Text('Unlock', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // 显示金币不足对话框
  Future<bool?> _showInsufficientCoinsDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Insufficient Coins'),
          content: Text(
            'You need $UNLOCK_COST gold coins to unlock this user. You currently have $_goldCoins coins.',
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
              child: const Text('Recharge', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // 构建群组成员头像（带锁状态）
  Widget _buildGroupMemberAvatar(ChallengeUser user, int index) {
    final isUnlocked = _unlockedUsers[user.userId] == true;
    
    return GestureDetector(
      onTap: () => _navigateToUser(user),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(user.profileImage),
          ),
          // 如果用户未解锁，显示锁图标
          if (!isUnlocked)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFFAB47BC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock,
                  size: 8,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 切换点赞状态
  Future<void> _toggleLike() async {
    if (_currentUsers.isEmpty) return;
    
    final currentUser = _currentUsers[_currentUserIndex];
    final newLikeStatus = await LikeService.toggleUserLike(currentUser.userId);
    
    setState(() {
      _likeStatus[currentUser.userId] = newLikeStatus;
    });
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
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom + 300, // 增加额外高度确保可以滚动，避免被TabBar遮挡
              child: Stack(
                children: [
              // Popular Challenges title
              Positioned(
                left: 20,
                top: 10,
                child: SizedBox(
                  width: 200,
                  height: 30,
                  child: Image.asset(
                    'assets/hawn_home_popular_challenge.webp',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // Three cards row
              Positioned(
                left: 0,
                right: 0,
                top: 50, // Position below the title
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: _navigateToRandomUser,
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/hawn_home_card_one.webp',
                                fit: BoxFit.contain,
                              ),
                              // 随机用户卡片总是显示锁（因为不知道具体用户）
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFAB47BC),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.lock,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: _navigateToRandomUser,
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/hawn_home_card_two.webp',
                                fit: BoxFit.contain,
                              ),
                              // 随机用户卡片总是显示锁（因为不知道具体用户）
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFAB47BC),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.lock,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: _navigateToRandomUser,
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/hawn_home_card_three.webp',
                                fit: BoxFit.contain,
                              ),
                              // 随机用户卡片总是显示锁（因为不知道具体用户）
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFAB47BC),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.lock,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Popular Groups title
              Positioned(
                left: 20,
                top: 200, // Position below the cards
                child: SizedBox(
                  width: 200,
                  height: 30,
                  child: Image.asset(
                    'assets/hawn_home_popular_groups.webp',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // Scrollable type selector
              Positioned(
                left: 0,
                right: 0,
                top: 240, // Position below the Popular Groups title
                child: SizedBox(
                  height: 60, // Fixed height for the scrollable area
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: List.generate(3, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTypeIndex = index;
                            });
                            _loadUsersForType(index);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 16.0),
                            child: Image.asset(
                              _selectedTypeIndex == index
                                  ? _typeSelectedImages[index]
                                  : _typeNormalImages[index],
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              // Background card with user content
              Positioned(
                left: 20,
                right: 20,
                top: 320, // Position below the type selector
                child: GestureDetector(
                  onPanUpdate: (details) {
                    // Simple swipe detection
                    if (details.delta.dx > 10) {
                      _previousUser(); // Swipe right - previous user
                    } else if (details.delta.dx < -10) {
                      _nextUser(); // Swipe left - next user
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // Background card image
                            Image.asset(
                              'assets/hawn_home_card.webp',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 500,
                            ),
                          // User content overlay
                          if (_isLoading)
                            Container(
                              height: 500,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (_currentUsers.isNotEmpty)
                            Container(
                              height: 500,
                              child: Stack(
                                children: [
                                  // Main user image overlay
                                  Positioned(
                                    left: 20,
                                    right: 20,
                                    top: 18,
                                    bottom: 100,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (_currentUsers.isNotEmpty) {
                                          _navigateToUser(_currentUsers[_currentUserIndex]);
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.asset(
                                              _currentUsers[_currentUserIndex].challengePost.images.isNotEmpty
                                                  ? _currentUsers[_currentUserIndex].challengePost.images.first.imagePath
                                                  : 'assets/responseTool/fitness1/fitness1.webp',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          ),
                                          // 锁覆盖层（如果用户未解锁）
                                          if (_currentUsers.isNotEmpty && 
                                              _unlockedUsers[_currentUsers[_currentUserIndex].userId] != true)
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.6),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 60,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white.withOpacity(0.9),
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.3),
                                                            blurRadius: 8,
                                                            offset: const Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: const Icon(
                                                        Icons.lock,
                                                        size: 30,
                                                        color: Color(0xFFAB47BC),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFAB47BC),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: Text(
                                                        'Unlock for $UNLOCK_COST coins',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
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
                                  ),
                                  // Group members overlay (top-left)
                                  Positioned(
                                    left: 32,
                                    top: 32,
                                    child: Row(
                                      children: [
                                        // Stacked profile pictures
                                        Stack(
                                          children: [
                                            // 显示群组成员头像
                                            if (_groupMembers.isNotEmpty)
                                              _buildGroupMemberAvatar(_groupMembers[0], 0),
                                            if (_groupMembers.length > 1)
                                              Positioned(
                                                left: 20, // 增加间距从12到20
                                                child: _buildGroupMemberAvatar(_groupMembers[1], 1),
                                              ),
                                            if (_groupMembers.length > 2)
                                              Positioned(
                                                left: 40, // 增加间距从24到40
                                                child: _buildGroupMemberAvatar(_groupMembers[2], 2),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(width: 8),
                                        // Member count
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${_currentUsers.length}+',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 32,
                                    top: 32,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: _toggleLike,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          
                                          child: Center(
                                            child: Image.asset(
                                              _currentUsers.isNotEmpty && 
                                              _likeStatus[_currentUsers[_currentUserIndex].userId] == true
                                                  ? 'assets/hawn_like_selete.webp'
                                                  : 'assets/hawn_like_nor.webp',
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Challenge title overlay (bottom-center of image)
                                  Positioned(
                                    left: 32,
                                    right: 32,
                                    bottom: 140,
                                    child: Container(
                                      
                                    ),
                                  ),
                                  // Bottom info section overlay
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: 120,
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          // User name only
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  _currentUsers[_currentUserIndex].displayName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              // View button
                                              GestureDetector(
                                                onTap: () {
                                                  if (_currentUsers.isNotEmpty) {
                                                    _navigateToUser(_currentUsers[_currentUserIndex]);
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  
                                                  child: Image.asset(
                                                    'assets/hawn_home_view.webp',
                                                    width: 80,
                                                    height: 33,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Navigation arrows
                          if (_currentUsers.isNotEmpty)
                            Positioned(
                              left: 0, // 往外移动更多
                              top: 200,
                              child: GestureDetector(
                                onTap: _previousUser,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chevron_left,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          if (_currentUsers.isNotEmpty)
                            Positioned(
                              right: 0, // 往外移动更多
                              top: 200,
                              child: GestureDetector(
                                onTap: _nextUser,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
