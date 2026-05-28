import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/mock_data.dart';
import '../widgets/app_avatar.dart';
import 'public_profile_screen.dart';

class CommunityDetailsScreen extends StatefulWidget {
  final String title;
  final String description;
  const CommunityDetailsScreen({super.key, required this.title, required this.description});

  @override
  State<CommunityDetailsScreen> createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen> {
  bool _isJoined = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF7153B8), Color(0xFF5500FF)],
                    ),
                  ),
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE272),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'FEATURED COMMUNITY',
                          style: GoogleFonts.publicSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF370F0F),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.title,
                        style: GoogleFonts.raleway(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.people_outline, color: Colors.white70, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '12,450 members sharing skills',
                            style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Action Row
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => _isJoined = !_isJoined);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(_isJoined ? 'Request sent to join community' : 'Left community'),
                                  backgroundColor: const Color(0xFF5500FF),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isJoined ? Colors.green : const Color(0xFF423061),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            child: Text(
                              _isJoined ? 'REQUEST SENT' : 'ASK TO JOIN',
                              style: GoogleFonts.publicSans(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDEBF3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.share_outlined, color: Color(0xFF5500FF)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // About Section
                  Text(
                    'About this community',
                    style: GoogleFonts.raleway(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF001129)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.description,
                    style: GoogleFonts.inter(fontSize: 16, color: Colors.black54, height: 1.6),
                  ),

                  const SizedBox(height: 40),

                  // Resources / Folders Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Learning Folders',
                        style: GoogleFonts.raleway(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF001129)),
                      ),
                      const Icon(Icons.folder_copy_outlined, color: Color(0xFF5500FF)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      _buildFolderCard('Getting Started', '14 resources', const Color(0xFF7153B8)),
                      _buildFolderCard('Assignments', '8 resources', const Color(0xFF423061)),
                      _buildFolderCard('Live Sessions', '5 recordings', const Color(0xFF5500FF)),
                      _buildFolderCard('Bonus Content', '12 guides', const Color(0xFFFFE272), darkText: true),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Experts Section
                  Text(
                    'Top Contributors',
                    style: GoogleFonts.raleway(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF001129)),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: MockData.users.length,
                      itemBuilder: (context, index) {
                        final user = MockData.users[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(user: user))),
                            child: Column(
                              children: [
                                AppAvatar(imageUrl: user.avatarUrl, seed: user.name, size: 64),
                                const SizedBox(height: 8),
                                Text(
                                  user.name.split(' ')[0],
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderCard(String title, String subtitle, Color color, {bool darkText = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.folder_rounded, color: darkText ? const Color(0xFF370F0F) : Colors.white, size: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkText ? const Color(0xFF370F0F) : Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: darkText ? const Color(0xFF370F0F).withValues(alpha: 0.7) : Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
