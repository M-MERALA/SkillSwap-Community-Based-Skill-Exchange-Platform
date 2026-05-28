import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/user_model.dart';
import '../utils/mock_data.dart';
import '../widgets/app_button.dart';
import '../widgets/app_avatar.dart';
import 'main_shell.dart';

class SkillsSetupScreen extends StatefulWidget {
  final String name;
  final String username;
  final String email;
  final String phone;
  final String bio;

  const SkillsSetupScreen({
    super.key,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.bio,
  });

  @override
  State<SkillsSetupScreen> createState() => _SkillsSetupScreenState();
}

class _SkillsSetupScreenState extends State<SkillsSetupScreen> {
  final List<UserSkill> _teachSkills = [];
  final List<UserSkill> _learnSkills = [];
  
  final List<String> _availableSkills = [
    'Python', 'Web Design', 'Graphic Design', 'English', 
    'Flutter', 'UI/UX', 'Marketing', 'Photography', 'Music', 'Cooking'
  ];
  
  final List<String> _levels = ['Beginner', 'Intermediate', 'Advanced', 'Expert'];

  void _addSkill(bool isTeach) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        String selectedSkill = _availableSkills.first;
        String selectedLevel = _levels.first;
        
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isTeach ? 'Skill to Teach' : 'Skill to Learn', style: AppTextStyles.headlineSmall.copyWith(fontSize: 20)),
                  SizedBox(height: 20),
                  Text('Select Skill', style: AppTextStyles.labelLarge.copyWith(fontSize: 14)),
                  DropdownButton<String>(
                    value: selectedSkill,
                    isExpanded: true,
                    items: _availableSkills.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) => setModalState(() => selectedSkill = val!),
                  ),
                  SizedBox(height: 20),
                  Text('Select Level', style: AppTextStyles.labelLarge.copyWith(fontSize: 14)),
                  DropdownButton<String>(
                    value: selectedLevel,
                    isExpanded: true,
                    items: _levels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                    onChanged: (val) => setModalState(() => selectedLevel = val!),
                  ),
                  SizedBox(height: 30),
                  AppButton(
                    label: 'Add Skill',
                    onPressed: () {
                      setState(() {
                        if (isTeach) {
                          _teachSkills.add(UserSkill(name: selectedSkill, level: selectedLevel));
                        } else {
                          _learnSkills.add(UserSkill(name: selectedSkill, level: selectedLevel));
                        }
                      });
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _finish() {
    if (_teachSkills.isEmpty || _learnSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one skill to teach and one to learn.')));
      return;
    }

    final newUser = MockData.currentUser.copyWith(
      name: widget.name,
      username: widget.username,
      email: widget.email,
      phoneNumber: widget.phone,
      bio: widget.bio,
      skillsOffered: _teachSkills,
      skillsWanted: _learnSkills,
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=${widget.username}&backgroundColor=b6e3f4',
    );

    MockData.updateCurrentUser(newUser);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Skills & Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Mock
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      AppAvatar(
                        seed: widget.name,
                        size: 120,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text('Upload Profile Picture', style: AppTextStyles.labelLarge.copyWith(fontSize: 14)),
                ],
              ),
            ),
            SizedBox(height: 40),
            
            // Skills to Teach
            _buildSkillSection('Skills I Can Teach', _teachSkills, true),
            SizedBox(height: 30),
            
            // Skills to Learn
            _buildSkillSection('Skills I Want to Learn', _learnSkills, false),
            
            SizedBox(height: 50),
            AppButton(
              label: 'Complete Setup',
              onPressed: _finish,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillSection(String title, List<UserSkill> skills, bool isTeach) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.headlineSmall),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.primary),
              onPressed: () => _addSkill(isTeach),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (skills.isEmpty)
          Text('No skills added yet.', style: AppTextStyles.bodySmall)
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((s) => _buildSkillChip(s, isTeach)).toList(),
          ),
      ],
    );
  }

  Widget _buildSkillChip(UserSkill skill, bool isTeach) {
    return Chip(
      label: Text('${skill.name} (${skill.level})'),
      onDeleted: () {
        setState(() {
          if (isTeach) {
            _teachSkills.remove(skill);
          } else {
            _learnSkills.remove(skill);
          }
        });
      },
      backgroundColor: isTeach ? AppColors.primaryLight : AppColors.primary.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: isTeach ? AppColors.primary : AppColors.accent, fontSize: 12),
      deleteIconColor: isTeach ? AppColors.primary : AppColors.accent,
    );
  }
}

