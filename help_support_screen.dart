import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7153B8), Color(0xFF5500FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Help & Support',
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 27,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frequently Asked Questions',
                    style: GoogleFonts.raleway(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFAQ(context, 'How do I start a swap?', 'Find a skill you want to learn, click "Swap", and select a skill you can offer in return. Once the other user accepts, you can start chatting!'),
                  _buildFAQ(context, 'Is Skill Swap free?', 'Yes, the core experience is free. We believe in knowledge sharing without barriers.'),
                  _buildFAQ(context, 'How do I report a user?', 'Go to the user\'s profile, tap the three dots in the corner, and select "Report User".'),
                ],
              ),
            ),
            
            const Divider(thickness: 2, color: Colors.black12),
            
            // Links as per Figma CSS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLink(context, 'Privacy Policy'),
                      const SizedBox(width: 8),
                      const CircleAvatar(radius: 1.5, backgroundColor: Colors.black),
                      const SizedBox(width: 8),
                      _buildLink(context, 'Terms of Service'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildMenuButton(context, 'Help and feedback', Icons.help_outline),
                  const SizedBox(height: 15),
                  _buildMenuButton(context, 'Log out', Icons.logout, isLogout: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLink(BuildContext context, String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11,
        color: Colors.black,
        letterSpacing: -0.01,
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String label, IconData icon, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      onTap: () {
        if (isLogout) {
          Navigator.of(context).pushNamedAndRemoveUntil('/intro', (route) => false);
        }
      },
    );
  }

  Widget _buildFAQ(BuildContext context, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: GoogleFonts.lato(color: AppColors.textSecondary, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
