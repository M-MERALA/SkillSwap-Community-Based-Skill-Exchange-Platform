import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/skill_model.dart';
import '../utils/mock_data.dart';
import '../widgets/app_avatar.dart';
import 'public_profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatModel chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<MessageModel> _messages;

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages = MockData.getMessages(widget.chat.id);
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    final userText = _controller.text;
    setState(() {
      _messages.add(
        MessageModel(
          id: DateTime.now().toString(),
          senderId: MockData.currentUser.id,
          text: userText,
          sentAt: DateTime.now(),
        ),
      );
      _controller.clear();
    });
    _scrollToBottom();

    // Simulate reply
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isTyping = true);
      _scrollToBottom();

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isTyping = false;
          _messages.add(
            MessageModel(
              id: DateTime.now().toString(),
              senderId: widget.chat.otherUserId,
              text: MockData.mockReplies[userText.length % MockData.mockReplies.length],
              sentAt: DateTime.now(),
            ),
          );
        });
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () {
            final otherUser = MockData.users.firstWhere(
              (u) => u.id == widget.chat.otherUserId,
              orElse: () => MockData.users.first,
            );
            Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(user: otherUser)));
          },
          child: Row(
            children: [
              Stack(
                children: [
                  AppAvatar(
                    imageUrl: widget.chat.otherUserAvatar,
                    seed: widget.chat.otherUserName,
                    size: 40,
                  ),
                  if (widget.chat.isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.chat.otherUserName, style: AppTextStyles.titleMedium.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                    widget.chat.isOnline ? 'Online now' : 'Offline',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: widget.chat.isOnline ? AppColors.success : AppColors.textHint,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: AppColors.primary),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video call starting...'))),
          ),
          IconButton(
            icon: const Icon(Icons.call_outlined, color: AppColors.primary),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voice call starting...'))),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.senderId == MockData.currentUser.id;
                
                // Show date separator if needed
                bool showDate = false;
                if (index == 0) {
                  showDate = true;
                } else {
                  final prevMessage = _messages[index - 1];
                  if (message.sentAt.day != prevMessage.sentAt.day) {
                    showDate = true;
                  }
                }

                return Column(
                  children: [
                    if (showDate) _buildDateSeparator(message.sentAt),
                    _buildMessageBubble(message, isMe),
                  ],
                );
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.chat.otherUserName.split(' ')[0]} is typing...',
                          style: AppTextStyles.labelSmall.copyWith(fontStyle: FontStyle.italic, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _formatDate(date),
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day && date.month == now.month && date.year == now.year) return 'Today';
    if (date.day == now.subtract(const Duration(days: 1)).day) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildMessageBubble(MessageModel message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                AppAvatar(imageUrl: widget.chat.otherUserAvatar, seed: widget.chat.otherUserName, size: 28),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                  decoration: BoxDecoration(
                    gradient: isMe 
                      ? const LinearGradient(colors: [Color(0xFF7153B8), Color(0xFF5500FF)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                      : null,
                    color: isMe ? null : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isMe ? Colors.white : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(left: isMe ? 0 : 36, right: isMe ? 4 : 0),
            child: Text(
              '${message.sentAt.hour}:${message.sentAt.minute.toString().padLeft(2, '0')}',
              style: AppTextStyles.labelSmall.copyWith(fontSize: 10, color: AppColors.textHint),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add_rounded, color: AppColors.primary, size: 24),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Media picker coming soon'))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextFormField(
                controller: _controller,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(fontSize: 14, color: AppColors.textHint),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onFieldSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              height: 44,
              width: 44,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF7153B8), Color(0xFF5500FF)]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

