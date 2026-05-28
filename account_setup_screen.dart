import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'skills_setup_screen.dart';
import '../widgets/app_avatar.dart';

class AccountSetupScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;

  const AccountSetupScreen({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialPhone,
  });

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _userCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _userCtrl = TextEditingController(text: widget.initialName.toLowerCase().replaceAll(' ', '_'));
    _emailCtrl = TextEditingController(text: widget.initialEmail);
    _phoneCtrl = TextEditingController(text: widget.initialPhone);
    _bioCtrl = TextEditingController();
  }

  void _next() {
    if (_nameCtrl.text.isEmpty || _userCtrl.text.isEmpty || _emailCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in required fields.')));
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SkillsSetupScreen(
          name: _nameCtrl.text,
          username: _userCtrl.text,
          email: _emailCtrl.text,
          phone: _phoneCtrl.text,
          bio: _bioCtrl.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Account Setup'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  AppAvatar(
                    seed: widget.initialName,
                    size: 120,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text('Personal Details', style: AppTextStyles.headlineMedium.copyWith(fontSize: 24)),
            SizedBox(height: 8),
            Text(
              'Let\'s build your profile to start swapping skills!',
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 16),
            ),
            SizedBox(height: 30),
            _buildField('Full Name*', _nameCtrl),
            _buildField('Username*', _userCtrl),
            _buildField('Email*', _emailCtrl),
            _buildField('Phone Number', _phoneCtrl),
            _buildField('Bio / Description', _bioCtrl, maxLines: 3),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 51,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Next: Skills Setup', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLarge.copyWith(fontSize: 14)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF8E8383)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(fontSize: 16),
            decoration: EdgeInsets.symmetric(horizontal: 15, vertical: 12).let((p) => InputDecoration(
              border: InputBorder.none,
              contentPadding: p,
            )),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

extension LetExtension<T> on T {
  R let<R>(R Function(T) block) => block(this);
}

