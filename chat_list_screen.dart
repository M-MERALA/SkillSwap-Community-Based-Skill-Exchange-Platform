import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/mock_data.dart';
import '../widgets/skill_card.dart';
import '../widgets/app_avatar.dart';
import 'chat_screen.dart';
import 'public_profile_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredChats = MockData.chats.where((chat) {
      return chat.otherUserName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             chat.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7153B8), Color(0xFF5500FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Messages',
          style: AppTextStyles.headlineSmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          
          // Active now
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('Active Now', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text('See All', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: MockData.users.where((u) => u.isOnline).length,
              itemBuilder: (context, index) {
                final onlineUsers = MockData.users.where((u) => u.isOnline).toList();
                final user = onlineUsers[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () {
                      try {
                        final chat = MockData.chats.firstWhere((c) => c.otherUserId == user.id);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(chat: chat))).then((_) => setState(() {}));
                      } catch (e) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(user: user)));
                      }
                    },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primary, width: 2),
                              ),
                              child: AppAvatar(
                                imageUrl: user.avatarUrl,
                                seed: user.name,
                                size: 54,
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user.name.split(' ')[0],
                          style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          
          // Chat list
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: filteredChats.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, size: 64, color: AppColors.textHint.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty ? 'No messages yet' : 'No results found',
                            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                          ),
                          if (_searchQuery.isEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Start a skill swap to chat!',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                            ),
                          ],
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      itemCount: filteredChats.length,
                      separatorBuilder: (context, index) => const Divider(indent: 84, height: 1, color: Color(0xFFF1F1F1)),
                      itemBuilder: (context, index) {
                        final chat = filteredChats[index];
                        return ChatTile(
                          chat: chat,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ChatScreen(chat: chat)),
                          ).then((_) => setState(() {})),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

