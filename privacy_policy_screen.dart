import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              '1. Information We Collect',
              'We collect information you provide directly to us, such as when you create an account, update your profile, or communicate with other users. This includes your name, email address, profile picture, and skill interests.',
            ),
            _buildSection(
              context,
              '2. How We Use Your Information',
              'We use the information we collect to provide, maintain, and improve our services, to facilitate skill swaps between users, and to send you technical notices and support messages.',
            ),
            _buildSection(
              context,
              '3. Sharing of Information',
              'Your profile information (name, bio, skills) is visible to other users to facilitate connections. We do not sell your personal data to third parties. We may share information if required by law.',
            ),
            _buildSection(
              context,
              '4. Data Security',
              'We take reasonable measures to help protect information about you from loss, theft, misuse, and unauthorized access. However, no internet transmission is ever fully secure.',
            ),
            _buildSection(
              context,
              '5. Your Choices',
              'You may update or delete your account information at any time through the Settings menu. You can also manage your notification preferences.',
            ),
            SizedBox(height: 40),
            Center(
              child: Text(
                'Last Updated: May 2026',
                style: GoogleFonts.lato(color: AppColors.textSecondary, fontSize: 14),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.raleway(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.lato(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

