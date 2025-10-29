import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'hawn_chat_screen.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  List<ChatConversation> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final conversations = <ChatConversation>[];

      // 扫描所有聊天历史文件
      final files = dir.listSync().where((file) => 
        file.path.contains('hawn_chat_history_') && file.path.endsWith('.json')
      ).toList();

      for (final file in files) {
        try {
          final jsonStr = await File(file.path).readAsString();
          final List<dynamic> jsonList = json.decode(jsonStr);
          
          if (jsonList.isNotEmpty) {
            final messages = jsonList.map((e) => ChatMessage.fromJson(e)).toList();
            final lastMessage = messages.last;
            
            // 从文件名提取用户ID
            final fileName = file.path.split('/').last;
            final userId = fileName.replaceAll('hawn_chat_history_', '').replaceAll('.json', '');
            
            conversations.add(ChatConversation(
              userId: userId,
              userName: _getUserNameById(userId),
              userAvatar: _getUserAvatarById(userId),
              lastMessage: lastMessage.text ?? (lastMessage.imagePath != null ? 'Image' : 'Voice message'),
              lastMessageTime: lastMessage.time,
              unreadCount: 0, // 可以后续添加未读消息计数
            ));
          }
        } catch (e) {
          debugPrint('Error loading conversation from ${file.path}: $e');
        }
      }

      // 按最后消息时间排序
      conversations.sort((a, b) => _parseTime(b.lastMessageTime).compareTo(_parseTime(a.lastMessageTime)));

      setState(() {
        _conversations = conversations;
      });
    } catch (e) {
      debugPrint('Error loading conversations: $e');
    }
  }

  String _getUserNameById(String userId) {
    // 模拟用户数据，实际项目中可以从用户服务获取
    final userNames = {
      '1': 'Sarah Martinez',
      '2': 'Alex Johnson',
      '3': 'Emma Wilson',
      '4': 'Michael Brown',
      '5': 'Lisa Davis',
      '6': 'David Lee',
      '7': 'Anna Taylor',
      '8': 'James Wilson',
      '9': 'Sophie Chen',
      '10': 'Ryan Kim',
    };
    return userNames[userId] ?? 'User $userId';
  }

  String _getUserAvatarById(String userId) {
    // 模拟头像数据
    final avatars = {
      '1': 'assets/responseTool/fitness1/usericon.webp',
      '2': 'assets/responseTool/fitness2/usericon.webp',
      '3': 'assets/responseTool/fitness3/usericon.webp',
      '4': 'assets/responseTool/fitness4/usericon.webp',
      '5': 'assets/responseTool/fitness5/usericon.webp',
      '6': 'assets/responseTool/food1/usericon.webp',
      '7': 'assets/responseTool/food2/usericon.webp',
      '8': 'assets/responseTool/food3/usericon.webp',
      '9': 'assets/responseTool/hairstyle1/usericon.webp',
      '10': 'assets/responseTool/hairstyle2/usericon.webp',
    };
    return avatars[userId] ?? 'assets/responseTool/fitness1/usericon.webp';
  }

  DateTime _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, hour, minute);
      }
    } catch (e) {
      debugPrint('Error parsing time: $e');
    }
    return DateTime.now();
  }

  String _formatTime(String timeStr) {
    final time = _parseTime(timeStr);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);
    
    if (messageDate == today) {
      return timeStr; // 今天显示时间
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday'; // 昨天显示Yesterday
    } else {
      return '${time.month}/${time.day}'; // 其他显示月/日
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF9355FF),
                Color(0xFFE91E63),
              ],
            ),
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 装饰条
          Container(
            height: 8,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF9355FF),
                  Color(0xFFE91E63),
                ],
              ),
            ),
          ),
          // 消息列表
          Expanded(
            child: Container(
              color: const Color(0xFF1A1A1A),
              child: _conversations.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = _conversations[index];
                        return _buildConversationItem(conversation);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF9355FF).withOpacity(0.15),
                  const Color(0xFFE91E63).withOpacity(0.15),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF9355FF).withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9355FF).withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.message_outlined,
              size: 70,
              color: Color(0xFF9355FF),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'No Messages Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start chatting with your friends',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationItem(ChatConversation conversation) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HawnChatScreen(
              userId: conversation.userId,
              userName: conversation.userName,
              userAvatar: conversation.userAvatar,
            ),
          ),
        ).then((_) {
          // 返回时刷新消息列表
          _loadConversations();
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 头像
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(conversation.userAvatar),
              ),
            ),
            const SizedBox(width: 16),
            // 消息内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _formatTime(conversation.lastMessageTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation.lastMessage,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 未读消息数量
            if (conversation.unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9355FF), Color(0xFFE91E63)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  conversation.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ChatConversation {
  final String userId;
  final String userName;
  final String userAvatar;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;

  ChatConversation({
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });
}

class ChatMessage {
  final String? text;
  final String? imagePath;
  final String? audioPath;
  final bool isMe;
  final String time;
  final String type;

  ChatMessage({
    this.text,
    this.imagePath,
    this.audioPath,
    required this.isMe,
    required this.time,
    required this.type,
  });

  static ChatMessage fromJson(Map<String, dynamic> json) => ChatMessage(
    text: json['text'],
    imagePath: json['imagePath'],
    audioPath: json['audioPath'],
    isMe: json['isMe'] ?? true,
    time: json['time'] ?? '',
    type: json['type'] ?? 'text',
  );
}
