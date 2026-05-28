import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../utils/mock_data.dart';
import '../widgets/app_avatar.dart';
import '../models/skill_model.dart';
import 'skill_details_screen.dart';
import '../widgets/scheduling_sheet.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? user;
  const ProfileScreen({super.key, this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF423061),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user ?? MockData.currentUser;
    final isCurrentUser = user.id == MockData.currentUser.id;

    // Find related courses/skills taught by this user
    final relatedSkills = MockData.skills.where((s) => s.teacherId == user.id).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Professional Hero Section
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF423061),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppAvatar(
                    imageUrl: user.avatarUrl,
                    seed: user.name,
                    size: double.infinity,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.zero,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.2),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
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
                            Text(
                              user.name,
                              style: GoogleFonts.raleway(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            if (user.isVerified) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.verified, color: Color(0xFFC9AAFF), size: 24),
                            ],
                          ],
                        ),
                        Text(
                          user.username.isNotEmpty ? '@${user.username}' : user.location,
                          style: GoogleFonts.lato(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (user.location.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, color: Colors.white54, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                user.location,
                                style: GoogleFonts.lato(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black26,
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (isCurrentUser)
                IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.black26,
                    child: Icon(Icons.settings, color: Colors.white, size: 20),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                ),
              const SizedBox(width: 8),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEBF3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(user.rating.toStringAsFixed(1), 'Rating', Icons.star_rounded),
                        _buildStatItem(user.swapsCompleted.toString(), 'Swaps', Icons.swap_horiz_rounded),
                        _buildStatItem(user.reviewCount.toString(), 'Reviews', Icons.chat_bubble_outline_rounded),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Bio Section
                  Text('About', style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Text(
                    user.bio,
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Social Links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Social Profiles', style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.w800)),
                      if (isCurrentUser)
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/social_links').then((_) => setState(() {})),
                          child: const Text('Edit'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (user.socialLinks.isEmpty)
                    Text('No social profiles connected.', style: GoogleFonts.lato(color: Colors.grey))
                  else
                    Wrap(
                      spacing: 12,
                      children: user.socialLinks.entries.map((entry) {
                        return IconButton(
                          icon: Icon(_getIconForPlatform(entry.key), color: const Color(0xFF423061)),
                          onPressed: () => _showFeedback('Opening ${entry.key}: ${entry.value}'),
                          tooltip: entry.key,
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 32),

                  // Schedule Button
                  if (isCurrentUser) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
                            builder: (context) => SchedulingSheet(personName: 'your students'),
                          );
                        },
                        icon: const Icon(Icons.calendar_month_rounded),
                        label: Text('MANAGE SCHEDULE', style: GoogleFonts.publicSans(fontWeight: FontWeight.w900, letterSpacing: 1)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC9AAFF),
                          foregroundColor: const Color(0xFF423061),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Skill Level
                  if (user.skillsOffered.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(Icons.bar_chart_rounded, color: Color(0xFF5500FF), size: 20),
                        const SizedBox(width: 8),
                        Text('Skill Level', style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.skillsOffered.first.level,
                      style: GoogleFonts.lato(fontSize: 15, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Skills Teaching
                  Row(
                    children: [
                      const Icon(Icons.school_rounded, color: Color(0xFF5500FF), size: 20),
                      const SizedBox(width: 8),
                      Text('Skills I Teach', style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: user.skillsOffered.map((s) => _buildSkillChip(s, true)).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Skills Wanting
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Color(0xFFC9AAFF), size: 20),
                      const SizedBox(width: 8),
                      Text('Skills I Want to Learn', style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: user.skillsWanted.map((s) => _buildSkillChip(s, false)).toList(),
                  ),

                  // Related Courses / Skills
                  if (relatedSkills.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        const Icon(Icons.play_circle_fill_rounded, color: Color(0xFF5500FF), size: 20),
                        const SizedBox(width: 8),
                        Text('Courses by ${user.name.split(' ')[0]}', style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...relatedSkills.map((skill) => _buildRelatedCourseCard(context, skill)),
                  ],

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: isCurrentUser
          ? null
          : Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showFeedback('Opening chat with ${user.name}...');
                      },
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                      label: Text('MESSAGE', style: GoogleFonts.publicSans(fontWeight: FontWeight.w900, letterSpacing: 1)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF423061),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showFeedback('Swap request sent to ${user.name}!');
                      },
                      icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                      label: Text('SWAP', style: GoogleFonts.publicSans(fontWeight: FontWeight.w900, letterSpacing: 1)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF423061), width: 2),
                        foregroundColor: const Color(0xFF423061),
                        minimumSize: const Size(0, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF5500FF), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFF001129)),
        ),
        Text(
          label,
          style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildSkillChip(UserSkill skill, bool isOffered) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isOffered ? const Color(0xFF5500FF).withValues(alpha: 0.1) : const Color(0xFFEDEBF3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOffered ? const Color(0xFF5500FF).withValues(alpha: 0.2) : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            skill.name,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isOffered ? const Color(0xFF5500FF) : const Color(0xFF423061),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            skill.level,
            style: GoogleFonts.lato(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isOffered ? const Color(0xFF5500FF).withValues(alpha: 0.7) : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedCourseCard(BuildContext context, SkillModel skill) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SkillDetailsScreen(skill: skill))),
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
                size: 60,
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
                    style: GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF001129)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    skill.category,
                    style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFB800)),
                      const SizedBox(width: 2),
                      Text(
                        skill.rating.toStringAsFixed(1),
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.people_alt_rounded, size: 13, color: Colors.grey),
                      const SizedBox(width: 2),
                      Text(
                        '${skill.studentCount}',
                        style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF5500FF)),
          ],
        ),
      ),
    );
  }

  IconData _getIconForPlatform(String platform) {
    switch (platform) {
      case 'LinkedIn': return Icons.business_center_outlined;
      case 'GitHub': return Icons.code_rounded;
      case 'Behance': return Icons.brush_outlined;
      case 'Instagram': return Icons.camera_alt_outlined;
      case 'Twitter': return Icons.alternate_email;
      case 'Website': return Icons.language_rounded;
      default: return Icons.link;
    }
  }
}
