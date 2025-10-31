import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/profile_service.dart';
import 'about_page.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'message_list_screen.dart';
import 'hawn_inapppurchases_screen.dart';
import 'hawn_subscriptions_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = 'Username';
  String _signature = 'Signature';
  String? _avatarPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final username = await ProfileService.getUsername();
    final signature = await ProfileService.getSignature();
    final avatarPath = await ProfileService.getAvatarPath();
    
    setState(() {
      _username = username;
      _signature = signature;
      _avatarPath = avatarPath;
    });
  }

  // 检查VIP状态并处理头像选择
  Future<void> _handleAvatarSelection() async {
    // 检查VIP状态
    final prefs = await SharedPreferences.getInstance();
    final isVip = prefs.getBool('isVip') ?? false;
    
    if (isVip) {
      // VIP用户，直接选择头像
      _selectAvatar();
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

  // 检查月订阅VIP状态并处理消息列表跳转
  Future<void> _handleMessageListNavigation() async {
    // 检查VIP状态和订阅类型
    final prefs = await SharedPreferences.getInstance();
    final isVip = prefs.getBool('isVip') ?? false;
    final vipType = prefs.getString('vip_type') ?? '';
    
    if (isVip && vipType == 'monthly') {
      // 月订阅VIP用户，直接跳转到消息列表
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MessageListScreen()),
      );
    } else {
      // 非月订阅用户，显示订阅提示
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
          title: const Text('Monthly VIP Required'),
          content: const Text(
            'You need monthly VIP subscription to access message list. Weekly subscription is not sufficient for this feature.',
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE1BEE7), // Light purple
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // 增加底部padding避免被tabbar遮挡
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Profile Header
                _buildProfileHeader(),
                const SizedBox(height: 30),
                // Asset Cards (Wallet & VIP)
                _buildAssetCards(),
                const SizedBox(height: 30),
                // Menu Items
                _buildMenuItems(),
                const SizedBox(height: 40), // 底部间距
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Profile Picture
        GestureDetector(
          onTap: _handleAvatarSelection,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: _avatarPath != null
                  ? Image.file(
                      File(_avatarPath!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    )
                  : Image.asset(
                      'assets/responseTool/fitness1/usericon.webp',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Name
        GestureDetector(
          onTap: _editUsername,
          child: Text(
            _username,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Description
        GestureDetector(
          onTap: _editSignature,
          child: Text(
            _signature,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssetCards() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Wallet Card
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InAppPurchasesPage(),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/hawn_user_wallet.webp',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.account_balance_wallet,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // VIP Card
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionsPage(),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/hawn_user_vip.webp',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.workspace_premium,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.info_outline,
            iconColor: const Color(0xFF2196F3),
            title: 'About us',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildMenuItem(
            icon: Icons.message_outlined,
            iconColor: const Color(0xFFE91E63),
            title: 'Message',
            onTap: _handleMessageListNavigation,
          ),
          const SizedBox(height: 16),
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            iconColor: const Color(0xFF4CAF50),
            title: 'Privacy Policy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildMenuItem(
            icon: Icons.description_outlined,
            iconColor: const Color(0xFFFF9800),
            title: 'User Agreement',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF9355FF), Color(0xFFE91E63)],
        ),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _selectAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        final sourceFile = File(image.path);
        final fileName = await ProfileService.saveAvatarFile(sourceFile);
        
        if (fileName != null) {
          await _loadProfileData();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Avatar updated successfully!'),
                backgroundColor: Color(0xFF4CAF50),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to save avatar'),
                backgroundColor: Color(0xFFE91E63),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting avatar: $e'),
            backgroundColor: const Color(0xFFE91E63),
          ),
        );
      }
    }
  }

  Future<void> _editUsername() async {
    final TextEditingController controller = TextEditingController(text: _username);
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Username'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your username',
            border: OutlineInputBorder(),
          ),
          maxLength: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9355FF),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && result != _username) {
      await ProfileService.saveUsername(result);
      setState(() {
        _username = result;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username updated successfully!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    }
  }

  Future<void> _editSignature() async {
    final TextEditingController controller = TextEditingController(text: _signature);
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Signature'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your signature',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          maxLength: 100,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9355FF),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result != null && result != _signature) {
      await ProfileService.saveSignature(result);
      setState(() {
        _signature = result;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signature updated successfully!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    }
  }
}
