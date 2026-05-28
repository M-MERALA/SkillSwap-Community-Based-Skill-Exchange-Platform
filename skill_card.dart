import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/skill_model.dart';
import '../widgets/app_avatar.dart';
import '../screens/profile_screen.dart';
import '../screens/public_profile_screen.dart';
import '../utils/mock_data.dart';

class SkillCard extends StatelessWidget {
  final SkillModel skill;
  final VoidCallback? onTap;

  const SkillCard({super.key, required this.skill, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5500FF).withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail with Overlays
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: AppAvatar(
                      imageUrl: skill.thumbnailUrl,
                      seed: skill.title,
                      type: AvatarType.course,
                      size: double.infinity,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  // Gradient Overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Category Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Text(
                        skill.category.toUpperCase(),
                        style: GoogleFonts.publicSans(
                          color: const Color(0xFF5500FF),
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  // Rating Badge
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE272),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Color(0xFF370F0F)),
                          const SizedBox(width: 2),
                          Text(
                            skill.rating.toStringAsFixed(1),
                            style: GoogleFonts.inter(
                              color: const Color(0xFF370F0F),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skill.title,
                      style: GoogleFonts.raleway(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF001129),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Teacher & Level
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            final teacher = MockData.users.firstWhere((u) => u.id == skill.teacherId, orElse: () => MockData.users.first);
                            Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(user: teacher)));
                          },
                          child: AppAvatar(
                            imageUrl: skill.teacherAvatar,
                            seed: skill.teacherName,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final teacher = MockData.users.firstWhere((u) => u.id == skill.teacherId, orElse: () => MockData.users.first);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(user: teacher)));
                            },
                            child: Text(
                              skill.teacherName,
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF575757),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDEBF3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            skill.level,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF5500FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Stats
                    Row(
                      children: [
                        Icon(Icons.people_alt_rounded, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${skill.studentCount} students',
                          style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.timer_rounded, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          skill.duration,
                          style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Main Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => onTap?.call(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF423061),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'View Course',
                          style: GoogleFonts.publicSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


// ── Swap Request Card ────────────────────────────────────────────────────────
class SwapRequestCard extends StatelessWidget {
  final SwapRequestModel request;
  final bool isSent;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onMessage;

  const SwapRequestCard({
    super.key,
    required this.request,
    required this.isSent,
    this.onAccept,
    this.onDecline,
    this.onMessage,
  });

  Color get _statusColor {
    switch (request.status) {
      case 'pending':
        return AppColors.warning;
      case 'accepted':
        return AppColors.success;
      case 'declined':
        return AppColors.error;
      case 'completed':
        return AppColors.primary;
      default:
        return AppColors.textHint;
    }
  }

  String get _statusLabel {
    switch (request.status) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'declined':
        return 'Declined';
      case 'completed':
        return 'Completed';
      default:
        return request.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final otherName = isSent ? request.toUserName : request.fromUserName;
    final otherAvatar = isSent ? request.toUserAvatar : request.fromUserAvatar;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final otherUserId = isSent ? request.toUserId : request.fromUserId;
                    final otherUser = MockData.users.firstWhere((u) => u.id == otherUserId, orElse: () => MockData.users.first);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(user: otherUser)));
                  },
                  child: AppAvatar(
                    imageUrl: otherAvatar,
                    seed: otherName,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final otherUserId = isSent ? request.toUserId : request.fromUserId;
                      final otherUser = MockData.users.firstWhere((u) => u.id == otherUserId, orElse: () => MockData.users.first);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(user: otherUser)));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(otherName, style: AppTextStyles.titleMedium),
                        Text(
                          _timeAgo(request.createdAt),
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: _statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Swap info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _swapChip(
                      label: 'Offers',
                      skill: request.offeredSkill,
                      color: AppColors.success,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.swap_horiz_rounded,
                        color: AppColors.primary, size: 22),
                  ),
                  Expanded(
                    child: _swapChip(
                      label: 'Wants',
                      skill: request.wantedSkill,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            if (request.message != null && request.message!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                '"${request.message}"',
                style: AppTextStyles.bodySmall.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (!isSent && request.status == 'pending') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDecline,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text('Decline',
                          style: AppTextStyles.labelLarge
                              .copyWith(color: AppColors.error)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 0,
                      ),
                      child: Text('Accept',
                          style: AppTextStyles.labelLarge
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
            if (request.status == 'accepted') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onMessage,
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                  label: Text('Message', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _swapChip({
    required String label,
    required String skill,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            skill,
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ── Chat Tile ─────────────────────────────────────────────────────────────────
class ChatTile extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback? onTap;

  const ChatTile({super.key, required this.chat, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: chat.unreadCount > 0 ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                final otherUser = MockData.users.firstWhere((u) => u.id == chat.otherUserId, orElse: () => MockData.users.first);
                Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(user: otherUser)));
              },
              child: AppAvatar(
                imageUrl: chat.otherUserAvatar,
                seed: chat.otherUserName,
                size: 52,
              ),
            ),
          ),
          if (chat.isOnline)
            Positioned(
              bottom: 4,
              right: 4,
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
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.otherUserName,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
          Text(
            _formatTime(chat.lastMessageTime),
            style: AppTextStyles.labelSmall.copyWith(
              color: chat.unreadCount > 0 ? AppColors.primary : AppColors.textHint,
              fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                chat.lastMessage,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                  color: chat.unreadCount > 0 ? AppColors.textPrimary : AppColors.textSecondary,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (chat.unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF7153B8), Color(0xFF5500FF)]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${chat.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

