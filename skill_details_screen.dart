import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_avatar.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/mock_data.dart';
import '../models/skill_model.dart';
import 'course_study_screen.dart';
import 'public_profile_screen.dart';

class SkillDetailsScreen extends StatefulWidget {
  final SkillModel skill;
  const SkillDetailsScreen({super.key, required this.skill});

  @override
  State<SkillDetailsScreen> createState() => _SkillDetailsScreenState();
}

class _SkillDetailsScreenState extends State<SkillDetailsScreen> {
  bool _isFavorite = false;
  late bool _isJoined;

  @override
  void initState() {
    super.initState();
    _isFavorite = MockData.savedSkillIds.contains(widget.skill.id);
    _isJoined = MockData.joinedCourseIds.contains(widget.skill.id);
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    MockData.toggleFavorite(widget.skill.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isFavorite ? 'Skill saved!' : 'Skill removed from saved.')),
    );
  }

  void _joinCourse() {
    setState(() => _isJoined = true);
    MockData.joinCourse(widget.skill.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Welcome to the course! Lesson content is now unlocked.'),
        backgroundColor: Colors.green,
      ),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => CourseStudyScreen(skill: widget.skill)));
      }
    });
  }

  void _showSwapRequestDialog() {
    final existingRequest = MockData.swapRequests.any((r) => 
      r.wantedSkill == widget.skill.title && r.fromUserId == MockData.currentUser.id);

    if (existingRequest) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have already sent a request for this skill.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Skill Swap'),
        content: Text('Do you want to request a swap with ${widget.skill.teacherName}? You will offer your top skills in exchange.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              
              MockData.addSwapRequest(SwapRequestModel(
                id: 'sr_${DateTime.now().millisecondsSinceEpoch}',
                fromUserId: MockData.currentUser.id,
                fromUserName: MockData.currentUser.name,
                fromUserAvatar: MockData.currentUser.avatarUrl,
                toUserId: widget.skill.teacherId,
                toUserName: widget.skill.teacherName,
                toUserAvatar: widget.skill.teacherAvatar,
                offeredSkill: 'UI/UX Design',
                wantedSkill: widget.skill.title,
                status: 'pending',
                createdAt: DateTime.now(),
              ));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Swap request sent successfully!')),
              );
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Premium Hero Section
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF5500FF),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppAvatar(
                    imageUrl: widget.skill.thumbnailUrl,
                    seed: widget.skill.title,
                    type: AvatarType.course,
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
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE272),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.skill.category.toUpperCase(),
                            style: GoogleFonts.publicSans(
                              color: const Color(0xFF370F0F),
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.skill.title,
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: _toggleFavorite,
              ),
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: Icon(Icons.share_rounded, color: Colors.white, size: 20),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
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
                        _buildStatItem(Icons.star_rounded, widget.skill.rating.toString(), 'Rating'),
                        _buildStatItem(Icons.people_alt_rounded, '${widget.skill.studentCount}', 'Students'),
                        _buildStatItem(Icons.timer_rounded, widget.skill.duration, 'Duration'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Mentor Section
                  Text('Your Mentor', style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFEDEBF3)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        AppAvatar(
                          imageUrl: widget.skill.teacherAvatar,
                          seed: widget.skill.teacherName,
                          size: 56,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.skill.teacherName, style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text('Expert Instructor', style: GoogleFonts.lato(color: Colors.grey[600], fontSize: 13)),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            final teacher = MockData.users.firstWhere((u) => u.id == widget.skill.teacherId, orElse: () => MockData.users.first);
                            Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(user: teacher)));
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF5500FF)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text('View', style: GoogleFonts.publicSans(color: const Color(0xFF5500FF), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Description
                  Text('About the Course', style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Text(
                    widget.skill.description,
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Curriculum
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Curriculum', style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.w800)),
                      Text('${widget.skill.modules.length} Sections', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF5500FF), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...widget.skill.modules.map((m) => _buildModulePreview(m)),
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: Row(
          children: [
            // Message Button
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFEDEBF3)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF5500FF)),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16),
            // Join/Swap Button
            Expanded(
              child: SizedBox(
                height: 56,
                child: _isJoined
                    ? ElevatedButton(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CourseStudyScreen(skill: widget.skill))),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5500FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text('CONTINUE LEARNING', style: GoogleFonts.publicSans(fontWeight: FontWeight.w900, letterSpacing: 1)),
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: _joinCourse,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF423061),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              child: Text('JOIN', style: GoogleFonts.publicSans(fontWeight: FontWeight.w900, letterSpacing: 1)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              onPressed: _showSwapRequestDialog,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF423061), width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                minimumSize: const Size(0, 56),
                              ),
                              child: Text('SWAP', style: GoogleFonts.publicSans(fontWeight: FontWeight.w900, color: const Color(0xFF423061))),
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

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        SizedBox(height: 4),
        Text(value, style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildModulePreview(ModuleModel module) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(module.title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
          SizedBox(height: 8),
          ...module.lessons.map((l) => Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(Icons.play_circle_outline, size: 16, color: AppColors.textSecondary),
                SizedBox(width: 8),
                Text(l.title, style: AppTextStyles.bodySmall.copyWith(fontSize: 12)),
                const Spacer(),
                Text(l.duration, style: AppTextStyles.labelSmall.copyWith(fontSize: 11)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

