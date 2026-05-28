import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/mock_data.dart';
import '../widgets/skill_card.dart';
import 'skill_details_screen.dart';

class SavedSkillsScreen extends StatelessWidget {
  const SavedSkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savedSkills = MockData.skills.where((s) => MockData.savedSkillIds.contains(s.id)).toList();

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
          'Legacy Store', // Renamed from Saved Skills to match user terminology
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 27,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 4,
        shadowColor: Colors.black26,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFEDEBF3),
        ),
        child: savedSkills.isEmpty
            ? _buildEmptyState(context)
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: savedSkills.length,
                itemBuilder: (context, index) {
                  final skill = savedSkills[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SkillCard(
                      skill: skill,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SkillDetailsScreen(skill: skill)),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80, color: const Color(0xFFC9AAFF).withValues(alpha: 0.5)),
          const SizedBox(height: 20),
          Text(
            'No saved skills yet',
            style: GoogleFonts.raleway(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF555454),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Bookmark skills you\'re interested in to find them easily.',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(color: const Color(0xFF707070)),
          ),
        ],
      ),
    );
  }
}
