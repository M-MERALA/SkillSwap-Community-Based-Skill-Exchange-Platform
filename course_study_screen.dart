import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/skill_model.dart';
import '../models/user_model.dart';
import '../utils/mock_data.dart';
import '../widgets/app_button.dart';
import '../widgets/app_avatar.dart';

class CourseStudyScreen extends StatefulWidget {
  final SkillModel skill;
  const CourseStudyScreen({super.key, required this.skill});

  @override
  State<CourseStudyScreen> createState() => _CourseStudyScreenState();
}

class _CourseStudyScreenState extends State<CourseStudyScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ModuleModel> _modules;
  LessonModel? _activeLesson;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _modules = widget.skill.modules;
    _activeLesson = _modules.first.lessons.first;
  }

  void _completeLesson(LessonModel lesson) {
    setState(() {
      for (var m in _modules) {
        final index = m.lessons.indexWhere((l) => l.id == lesson.id);
        if (index != -1) {
          m.lessons[index] = m.lessons[index].copyWith(isCompleted: true);
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lesson "${lesson.title}" completed!')),
    );
  }

  double _calculateProgress() {
    int total = 0;
    int completed = 0;
    for (var m in _modules) {
      total += m.lessons.length;
      completed += m.lessons.where((l) => l.isCompleted).length;
    }
    return total == 0 ? 0 : completed / total;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.skill.title, style: AppTextStyles.titleMedium.copyWith(fontSize: 18)),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Video Player Placeholder
          Container(
            width: double.infinity,
            height: 220,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_activeLesson != null)
                  Center(
                    child: Text(
                      'Playing: ${_activeLesson!.title}',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                Icon(Icons.play_circle_fill, size: 64, color: Colors.white70),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      Icon(Icons.volume_up, color: Colors.white, size: 20),
                      const Spacer(),
                      Icon(Icons.fullscreen, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Lessons'),
              Tab(text: 'Community'),
              Tab(text: 'Resources'),
            ],
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLessonsTab(progress),
                _buildCommunityTab(),
                _buildResourcesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsTab(double progress) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your Progress', style: AppTextStyles.labelLarge.copyWith(fontSize: 14)),
                  Text('${(progress * 100).toInt()}%', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary, fontSize: 14)),
                ],
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _modules.length,
            itemBuilder: (context, modIdx) {
              final module = _modules[modIdx];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Module ${modIdx + 1}: ${module.title}',
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  ...module.lessons.map((lesson) => _buildLessonTile(lesson)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLessonTile(LessonModel lesson) {
    final isActive = _activeLesson?.id == lesson.id;
    return ListTile(
      onTap: () => setState(() => _activeLesson = lesson),
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: lesson.isCompleted ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary),
        ),
        child: Icon(
          lesson.isCompleted ? Icons.check : Icons.play_arrow,
          size: 16,
          color: lesson.isCompleted ? Colors.white : AppColors.primary,
        ),
      ),
      title: Text(
        lesson.title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isActive ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
      subtitle: Text(lesson.duration, style: AppTextStyles.labelSmall.copyWith(fontSize: 12)),
      trailing: !lesson.isCompleted 
        ? TextButton(
            onPressed: () => _completeLesson(lesson),
            child: Text('Mark Done', style: TextStyle(fontSize: 12)),
          )
        : Icon(Icons.check_circle, color: Colors.green, size: 20),
    );
  }

  Widget _buildCommunityTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text('Active Learners', style: AppTextStyles.titleMedium.copyWith(fontSize: 16)),
        SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: MockData.users.length,
            itemBuilder: (context, index) {
              final user = MockData.users[index];
              return Padding(
                padding: EdgeInsets.only(right: 12),
                child: Stack(
                  children: [
                    AppAvatar(
                      imageUrl: user.avatarUrl,
                      seed: user.name,
                      size: 50,
                    ),
                    if (user.isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 24),
        Text('Discussions', style: AppTextStyles.titleMedium.copyWith(fontSize: 16)),
        SizedBox(height: 12),
        _buildDiscussionItem(
          user: MockData.users[0],
          text: "Does anyone have a good resource for learning more about Python decorators?",
          replies: 4,
        ),
        _buildDiscussionItem(
          user: MockData.users[1],
          text: "I just finished the first project! It was challenging but fun.",
          replies: 2,
        ),
        SizedBox(height: 20),
        AppButton(
          label: 'Ask a Question',
          isOutlined: true,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDiscussionItem({required UserModel user, required String text, required int replies}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(
                imageUrl: user.avatarUrl,
                seed: user.name,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(user.name, style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
              const Spacer(),
              Text('2h ago', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
            ],
          ),
          SizedBox(height: 8),
          Text(text, style: AppTextStyles.bodySmall.copyWith(fontSize: 13)),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.chat_bubble_outline, size: 14, color: AppColors.textSecondary),
              SizedBox(width: 4),
              Text('$replies replies', style: AppTextStyles.labelSmall.copyWith(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildResourceTile('Course Syllabus.pdf', Icons.picture_as_pdf),
        _buildResourceTile('Python Basics Cheat Sheet.jpg', Icons.image),
        _buildResourceTile('Assignment 1: Data Types', Icons.assignment_outlined),
        _buildResourceTile('Source Code Repository', Icons.code),
      ],
    );
  }

  Widget _buildResourceTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 24),
      title: Text(title, style: AppTextStyles.bodyMedium.copyWith(fontSize: 14)),
      trailing: Icon(Icons.download, size: 20),
      onTap: () {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading $title...')),
        );
      },
    );
  }
}

