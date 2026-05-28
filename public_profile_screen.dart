import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../models/skill_model.dart';
import '../utils/mock_data.dart';
import '../widgets/app_avatar.dart';
import 'skill_details_screen.dart';
import 'chat_screen.dart';
import '../widgets/scheduling_sheet.dart';

/// Public profile screen shown when tapping any user/mentor/teacher card or avatar.
/// Shows: profile image, name, role/title, bio, skills teach, skills learn,
/// skill level, rating/reviews, related courses/swaps, Message + Request Swap buttons.
class PublicProfileScreen extends StatefulWidget {
  final UserModel user;
  const PublicProfileScreen({super.key, required this.user});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showFeedback(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF423061),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String get _roleTitle {
    if (widget.user.skillsOffered.isEmpty) return 'Skill Swapper';
    final topSkill = widget.user.skillsOffered.first;
    final level = topSkill.level;
    return '$level ${topSkill.name} Teacher';
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final relatedSkills = MockData.skills.where((s) => s.teacherId == user.id).toList();
    final relatedSwaps = MockData.swapRequests
        .where((r) => r.fromUserId == user.id || r.toUserId == user.id)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            // ── Hero Section ─────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 340,
              pinned: true,
              elevation: 0,
              backgroundColor: const Color(0xFF423061),
              leading: IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background avatar image (full bleed)
                    AppAvatar(
                      imageUrl: user.avatarUrl,
                      seed: user.name,
                      size: double.infinity,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                    ),
                    // Gradient overlay
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.85),
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                    // Name + role info overlay at bottom
                    Positioned(
                      bottom: 24,
                      left: 24,
                      right: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  user.name,
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              if (user.isVerified)
                                const Icon(Icons.verified_rounded,
                                    color: Color(0xFFC9AAFF), size: 24),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Role/title badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5500FF).withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _roleTitle,
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (user.location.isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded,
                                    color: Colors.white60, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  user.location,
                                  style: GoogleFonts.lato(
                                      color: Colors.white70, fontSize: 13),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Body Content ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Stats Row ──────────────────────────────────────
                    _buildStatsRow(user),

                    const SizedBox(height: 28),

                    // ── About / Bio ────────────────────────────────────
                    _sectionHeader(Icons.person_outline_rounded, 'About'),
                    const SizedBox(height: 10),
                    Text(
                      user.bio,
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        color: Colors.grey[700],
                        height: 1.65,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Skill Level ────────────────────────────────────
                    if (user.skillsOffered.isNotEmpty) ...[
                      _sectionHeader(Icons.bar_chart_rounded, 'Skill Level'),
                      const SizedBox(height: 10),
                      _buildLevelIndicator(user.skillsOffered.first.level),
                      const SizedBox(height: 28),
                    ],

                    // ── Skills I Teach ─────────────────────────────────
                    _sectionHeader(Icons.school_rounded, 'Skills I Teach'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: user.skillsOffered
                          .map((s) => _buildSkillChip(s, true))
                          .toList(),
                    ),

                    const SizedBox(height: 24),

                    // ── Skills I Want to Learn ─────────────────────────
                    _sectionHeader(Icons.auto_awesome_rounded, 'Skills I Want to Learn'),
                    const SizedBox(height: 12),
                    user.skillsWanted.isEmpty
                        ? Text('Not specified',
                            style: GoogleFonts.lato(color: Colors.grey))
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: user.skillsWanted
                                .map((s) => _buildSkillChip(s, false))
                                .toList(),
                          ),

                    const SizedBox(height: 28),

                    // ── Ratings & Reviews ──────────────────────────────
                    _sectionHeader(Icons.star_rounded, 'Rating & Reviews'),
                    const SizedBox(height: 12),
                    _buildRatingCard(user),

                    const SizedBox(height: 28),

                    // ── Related Courses ────────────────────────────────
                    if (relatedSkills.isNotEmpty) ...[
                      _sectionHeader(
                          Icons.play_circle_fill_rounded,
                          'Courses by ${user.name.split(' ')[0]}'),
                      const SizedBox(height: 12),
                      ...relatedSkills
                          .map((s) => _buildRelatedCourseCard(context, s)),
                      const SizedBox(height: 28),
                    ],

                    // ── Related Swaps ──────────────────────────────────
                    if (relatedSwaps.isNotEmpty) ...[
                      _sectionHeader(Icons.swap_horiz_rounded, 'Swap Activity'),
                      const SizedBox(height: 12),
                      ...relatedSwaps.take(3).map((r) => _buildSwapChip(r, user.id)),
                      const SizedBox(height: 28),
                    ],

                    // bottom padding for bottom sheet
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Bottom Action Sheet ──────────────────────────────────────────
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
                    builder: (context) => SchedulingSheet(personName: user.name),
                  );
                },
                icon: const Icon(Icons.calendar_month_rounded, size: 20),
                label: Text('SCHEDULE SESSION', style: GoogleFonts.publicSans(fontWeight: FontWeight.w900, letterSpacing: 1)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC9AAFF),
                  foregroundColor: const Color(0xFF423061),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Message button
                Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Try to navigate to existing chat, else show feedback
                  try {
                    final chat = MockData.chats
                        .firstWhere((c) => c.otherUserId == user.id);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ChatScreen(chat: chat)));
                  } catch (_) {
                    _showFeedback('Opening chat with ${user.name}...');
                  }
                },
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                label: Text(
                  'MESSAGE',
                  style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w900, letterSpacing: 0.8),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF423061),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 54),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Request Swap button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  final newRequest = SwapRequestModel(
                    id: 'r_${DateTime.now().millisecondsSinceEpoch}',
                    fromUserId: MockData.currentUser.id,
                    fromUserName: MockData.currentUser.name,
                    fromUserAvatar: MockData.currentUser.avatarUrl,
                    toUserId: user.id,
                    toUserName: user.name,
                    toUserAvatar: user.avatarUrl,
                    offeredSkill: MockData.currentUser.skillsOffered.isNotEmpty ? MockData.currentUser.skillsOffered.first.name : 'Unknown',
                    wantedSkill: user.skillsOffered.isNotEmpty ? user.skillsOffered.first.name : 'Unknown',
                    status: 'pending',
                    createdAt: DateTime.now(),
                    message: 'Hey ${user.name}! I would love to swap skills with you.',
                  );
                  setState(() {
                    MockData.addSwapRequest(newRequest);
                  });
                  _showFeedback('Swap request sent to ${user.name}!');
                },
                icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                label: Text(
                  'REQUEST SWAP',
                  style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w900, letterSpacing: 0.5),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF423061), width: 2),
                  foregroundColor: const Color(0xFF423061),
                  minimumSize: const Size(0, 54),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            ],
          ),
        ],
      ),
    ),
  );
}

  // ── Helper Widgets ────────────────────────────────────────────────────

  Widget _buildStatsRow(UserModel user) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEBF3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(
            user.rating.toStringAsFixed(1),
            'Rating',
            Icons.star_rounded,
            const Color(0xFFFFB800),
          ),
          _divider(),
          _statItem(
            user.swapsCompleted.toString(),
            'Swaps',
            Icons.swap_horiz_rounded,
            const Color(0xFF5500FF),
          ),
          _divider(),
          _statItem(
            user.reviewCount.toString(),
            'Reviews',
            Icons.chat_bubble_outline_rounded,
            const Color(0xFF059669),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.inter(
              fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFF001129)),
        ),
        Text(
          label,
          style: GoogleFonts.lato(
              fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _divider() => Container(
        height: 40,
        width: 1,
        color: Colors.grey.withValues(alpha: 0.3),
      );

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF5500FF), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }

  Widget _buildLevelIndicator(String level) {
    const levels = ['Beginner', 'Intermediate', 'Advanced', 'Expert'];
    final idx = levels.indexOf(level).clamp(0, 3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(level, style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[700])),
        const SizedBox(height: 8),
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: Container(
                height: 6,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: i <= idx ? const Color(0xFF5500FF) : const Color(0xFFEDEBF3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSkillChip(UserSkill skill, bool isOffered) {
    final bg = isOffered
        ? const Color(0xFF5500FF).withValues(alpha: 0.1)
        : const Color(0xFFEDEBF3);
    final border = isOffered
        ? const Color(0xFF5500FF).withValues(alpha: 0.25)
        : Colors.transparent;
    final textColor =
        isOffered ? const Color(0xFF5500FF) : const Color(0xFF423061);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            skill.name,
            style: GoogleFonts.inter(
                fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              skill.level,
              style: GoogleFonts.lato(
                  fontSize: 10, fontWeight: FontWeight.w700, color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEBF3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5500FF).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                user.rating.toStringAsFixed(1),
                style: GoogleFonts.inter(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF001129),
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < user.rating.round()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: const Color(0xFFFFB800),
                    size: 18,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                '${user.reviewCount} reviews',
                style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [4, 3, 2, 1, 0].map((i) {
                final fraction = i == 4 ? 0.75 : i == 3 ? 0.15 : i == 2 ? 0.06 : 0.02;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text('${i + 1}',
                          style: GoogleFonts.lato(fontSize: 11, color: Colors.grey)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: fraction,
                            backgroundColor: const Color(0xFFEDEBF3),
                            valueColor: const AlwaysStoppedAnimation(Color(0xFFFFB800)),
                            minHeight: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedCourseCard(BuildContext context, SkillModel skill) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => SkillDetailsScreen(skill: skill))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEDEBF3)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5500FF).withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AppAvatar(
                imageUrl: skill.thumbnailUrl,
                seed: skill.title,
                type: AvatarType.course,
                size: 64,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill.title,
                    style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF001129)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(skill.category,
                      style:
                          GoogleFonts.lato(fontSize: 12, color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 13, color: Color(0xFFFFB800)),
                      const SizedBox(width: 2),
                      Text(skill.rating.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      Text('${skill.studentCount} students',
                          style: GoogleFonts.lato(
                              fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Color(0xFF5500FF)),
          ],
        ),
      ),
    );
  }

  Widget _buildSwapChip(dynamic swap, String userId) {
    final isSent = swap.fromUserId == userId;
    final counterpart = isSent ? swap.toUserName : swap.fromUserName;
    final statusColor = swap.status == 'accepted'
        ? const Color(0xFF059669)
        : swap.status == 'declined'
            ? Colors.red
            : const Color(0xFFD97706);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.swap_horiz_rounded, color: statusColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isSent
                  ? '${swap.offeredSkill} → ${swap.wantedSkill} (with $counterpart)'
                  : '${swap.wantedSkill} ← ${swap.offeredSkill} (with $counterpart)',
              style: GoogleFonts.lato(fontSize: 13, color: Colors.grey[800]),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              swap.status[0].toUpperCase() + swap.status.substring(1),
              style: GoogleFonts.lato(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: statusColor),
            ),
          ),
        ],
      ),
    );
  }
}
