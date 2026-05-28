import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'main_shell.dart';
import 'search_results_screen.dart';
import 'skill_details_screen.dart';
import 'profile_screen.dart';
import 'public_profile_screen.dart';
import '../utils/mock_data.dart';
import '../models/skill_model.dart';
import '../widgets/skill_card.dart';
import '../widgets/app_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';

  List<SkillModel> get _filteredSkills {
    if (_selectedCategory == 'All') return MockData.skills;
    return MockData.skills.where((s) => s.category == _selectedCategory).toList();
  }


  Widget _buildCategoryItem(Map<String, dynamic> category) {
    final isSelected = _selectedCategory == category['name'];
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category['name']),
      child: Container(
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
          boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
        ),
        child: Row(
          children: [
            Text(category['icon'], style: TextStyle(fontSize: 16)),
            SizedBox(width: 8),
            Text(
              category['name'],
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCategoryCard(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SearchResultsScreen(initialQuery: title)));
      },
      child: Container(
        width: double.infinity,
        height: 60,
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.border),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            SizedBox(width: 15),
            Text(
              title,
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header from Figma
            Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF7153B8),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 9, offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () => context.findAncestorStateOfType<MainShellState>()?.openDrawer(),
                  ),
                  const Spacer(),
                  const Icon(Icons.search, color: Colors.white, size: 28),
                  const SizedBox(width: 20),
                  const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                ],
              ),
            ),
            
            SizedBox(height: 25),

            // Welcome Text
            // Welcome Text / "Swap, learn, grow"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Swap, learn, grow',
                    style: GoogleFonts.raleway(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF001129),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            // Most Collaborated Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                width: double.infinity,
                height: 151,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 17,
                      child: Text(
                        'Most Collaborated',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 16,
                      child: Row(
                        children: [
                          _buildOverlappingAvatar(0),
                          _buildOverlappingAvatar(1),
                          _buildOverlappingAvatar(2, showMore: true),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 52,
                      child: SizedBox(
                        width: 300,
                        child: Text(
                          'Discover the most accomplished and influential professionals',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 15,
                      child: Text(
                        'See more',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 30),

            // Category Filter
            SizedBox(
              height: 45,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 22),
                scrollDirection: Axis.horizontal,
                itemCount: MockData.categories.length,
                itemBuilder: (context, index) => _buildCategoryItem(MockData.categories[index]),
              ),
            ),

            SizedBox(height: 30),
            
            // Skills/Courses List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended for you',
                    style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  TextButton(
                    onPressed: () => context.findAncestorStateOfType<MainShellState>()?.setIndex(1),
                    child: Text('See All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            
            SizedBox(
              height: 360,
              child: _filteredSkills.isEmpty 
                ? Center(child: Text('No skills found in this category.', style: TextStyle(color: AppColors.textSecondary)))
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    scrollDirection: Axis.horizontal,
                    itemCount: _filteredSkills.length,
                    itemBuilder: (context, index) {
                      final skill = _filteredSkills[index];
                      return Container(
                        width: 300,
                        margin: EdgeInsets.only(right: 20),
                        child: SkillCard(
                          skill: skill,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SkillDetailsScreen(skill: skill))),
                        ),
                      );
                    },
                  ),
            ),

            SizedBox(height: 40),

            // Most Popular Categories
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'Top Categories',
                style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  _buildSearchCategoryCard('Programming', Icons.code_rounded),
                  _buildSearchCategoryCard('UI/UX Design', Icons.brush_rounded),
                  _buildSearchCategoryCard('Mobile Development', Icons.smartphone_rounded),
                  _buildSearchCategoryCard('Digital Marketing', Icons.trending_up_rounded),
                ],
              ),
            ),
            
            SizedBox(height: 40),

            // Featured Mentors
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'Top Mentors',
                style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 22),
                scrollDirection: Axis.horizontal,
                itemCount: MockData.users.length,
                itemBuilder: (context, index) {
                  final user = MockData.users[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(user: user))),
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          AppAvatar(
                            imageUrl: user.avatarUrl,
                            seed: user.name,
                            size: 70,
                          ),
                          SizedBox(height: 8),
                          Text(
                            user.name.split(' ')[0],
                            style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlappingAvatar(int index, {bool showMore = false}) {
    final user = MockData.users[index % MockData.users.length];
    return GestureDetector(
      onTap: () {
        if (!showMore) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(user: user)));
        }
      },
      child: Container(
        width: 25,
        height: 25,
        margin: const EdgeInsets.only(left: -8),
        decoration: BoxDecoration(
          color: showMore ? Colors.white : Colors.grey[300],
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Center(
          child: showMore
              ? const Text('+100', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.black))
              : ClipOval(
                  child: Image.network(
                    user.avatarUrl,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }
}

