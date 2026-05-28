import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              '1. Acceptance of Terms',
              'By accessing or using the Skill Swap application, you agree to be bound by these Terms and Conditions and our Privacy Policy.',
            ),
            _buildSection(
              context,
              '2. User Eligibility',
              'You must be at least 13 years old to use this service. By creating an account, you represent that you meet this requirement.',
            ),
            _buildSection(
              context,
              '3. User Conduct',
              'You are responsible for your conduct and any content you post. You agree not to engage in harassment, spamming, or sharing illegal content. Skill swaps are conducted at your own risk.',
            ),
            _buildSection(
              context,
              '4. Intellectual Property',
              'All content and materials available on Skill Swap are the property of Skill Swap or its licensors. You may not use our branding without permission.',
            ),
            _buildSection(
              context,
              '5. Termination',
              'We reserve the right to terminate or suspend your account at our sole discretion, without notice, for conduct that we believe violates these Terms.',
            ),
            _buildSection(
              context,
              '6. Limitation of Liability',
              'Skill Swap is provided "as is" without warranties of any kind. We are not liable for any damages arising from your use of the application.',
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

