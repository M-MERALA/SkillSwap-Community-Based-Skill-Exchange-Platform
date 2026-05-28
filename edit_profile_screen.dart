import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/user_model.dart';
import '../utils/mock_data.dart';
import '../widgets/app_button.dart';
import '../widgets/app_avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _userCtrl;
  late TextEditingController _bioCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  
  late List<UserSkill> _teachSkills;
  late List<UserSkill> _learnSkills;
  String? _tempAvatarPath;
  final ImagePicker _picker = ImagePicker();

  final List<String> _availableSkills = [
    'Python', 'Web Design', 'Graphic Design', 'English', 
    'Flutter', 'UI/UX', 'Marketing', 'Photography', 'Music', 'Cooking'
  ];
  
  final List<String> _levels = ['Beginner', 'Intermediate', 'Advanced', 'Expert'];

  @override
  void initState() {
    super.initState();
    final user = MockData.currentUser;
    _nameCtrl = TextEditingController(text: user.name);
    _userCtrl = TextEditingController(text: user.username);
    _bioCtrl = TextEditingController(text: user.bio);
    _phoneCtrl = TextEditingController(text: user.phoneNumber);
    _emailCtrl = TextEditingController(text: user.email);
    
    _teachSkills = List.from(user.skillsOffered);
    _learnSkills = List.from(user.skillsWanted);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _tempAvatarPath = image.path;
      });
    }
  }

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
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isTeach ? 'Skill to Teach' : 'Skill to Learn', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 20),
                  Text('Select Skill', style: AppTextStyles.labelLarge),
                  DropdownButton<String>(
                    value: selectedSkill,
                    isExpanded: true,
                    items: _availableSkills.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) => setModalState(() => selectedSkill = val!),
                  ),
                  const SizedBox(height: 20),
                  Text('Select Level', style: AppTextStyles.labelLarge),
                  DropdownButton<String>(
                    value: selectedLevel,
                    isExpanded: true,
                    items: _levels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                    onChanged: (val) => setModalState(() => selectedLevel = val!),
                  ),
                  const SizedBox(height: 30),
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
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _save() {
    final updatedUser = MockData.currentUser.copyWith(
      name: _nameCtrl.text,
      username: _userCtrl.text,
      bio: _bioCtrl.text,
      phoneNumber: _phoneCtrl.text,
      email: _emailCtrl.text,
      avatarUrl: _tempAvatarPath ?? MockData.currentUser.avatarUrl,
      skillsOffered: _teachSkills,
      skillsWanted: _learnSkills,
    );

    MockData.updateCurrentUser(updatedUser);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _save),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Changed to center for avatar
          children: [
            Stack(
              children: [
                _tempAvatarPath != null 
                  ? CircleAvatar(
                      radius: 60,
                      backgroundImage: FileImage(File(_tempAvatarPath!)),
                    )
                  : AppAvatar(
                      imageUrl: MockData.currentUser.avatarUrl,
                      seed: MockData.currentUser.name,
                      size: 120,
                    ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _pickImage,
              child: const Text('Change Profile Photo', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 30),
            
            _buildField('Full Name', _nameCtrl),
            _buildField('Username', _userCtrl),
            _buildField('Email', _emailCtrl),
            _buildField('Phone', _phoneCtrl),
            _buildField('Bio', _bioCtrl, maxLines: 3),
            const SizedBox(height: 30),
            
            _buildSkillSection('Skills I Can Teach', _teachSkills, true),
            const SizedBox(height: 30),
            _buildSkillSection('Skills I Want to Learn', _learnSkills, false),
            
            const SizedBox(height: 30),
            _buildSocialLinksButton(),

            const SizedBox(height: 40),
            AppButton(label: 'Save Changes', onPressed: _save),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinksButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: () => Navigator.pushNamed(context, '/social_links'),
        leading: const Icon(Icons.link_rounded, color: AppColors.primary),
        title: const Text('Social Links', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${MockData.currentUser.socialLinks.length} profiles connected'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
        const SizedBox(height: 20),
      ],
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.map((s) => Chip(
            label: Text('${s.name} (${s.level})'),
            onDeleted: () => setState(() => skills.remove(s)),
            backgroundColor: isTeach ? AppColors.primaryLight : AppColors.primary.withValues(alpha: 0.1),
            labelStyle: TextStyle(color: isTeach ? AppColors.primary : AppColors.accent, fontSize: 12),
          )).toList(),
        ),
      ],
    );
  }
}

