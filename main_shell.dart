import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'swaps_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void setIndex(int index) {
    setState(() => _selectedIndex = index);
  }

  static const List<Widget> _screens = [
    HomeScreen(),
    ExploreScreen(),
    SwapsScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black12)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Menu',
                    style: GoogleFonts.raleway(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF001129),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(Icons.group_outlined, 'Community', () => setState(() => _selectedIndex = 1)),
                  _buildDrawerItem(Icons.person_outline, 'Personal Details', () => setState(() => _selectedIndex = 4)),
                  _buildDrawerItem(Icons.workspace_premium_outlined, 'Premium', () {}),
                  _buildDrawerItem(Icons.calendar_today_outlined, 'Time Table', () {}),
                  _buildDrawerItem(Icons.history_outlined, 'History', () {}),
                  _buildDrawerItem(Icons.folder_shared_outlined, 'Portfolio', () {}),
                  _buildDrawerItem(Icons.psychology_outlined, 'Personalise Coaching', () {}),
                ],
              ),
            ),
            const Divider(color: Colors.black, thickness: 2, indent: 36, endIndent: 36),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/privacy'),
                    child: Text('Privacy Policy', style: GoogleFonts.inter(fontSize: 11, color: Colors.black)),
                  ),
                  const Text(' • ', style: TextStyle(color: Colors.black)),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/terms'),
                    child: Text('Terms of Service', style: GoogleFonts.inter(fontSize: 11, color: Colors.black)),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.black),
              title: Text('Help and feedback', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
              onTap: () => Navigator.pushNamed(context, '/help'),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: Text('Log out', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 86, // from CSS
        decoration: const BoxDecoration(
          color: Color(0xFF7153B8), // #7153B8
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // 0px -5px 15px rgba(0, 0, 0, 0.25)
              blurRadius: 15,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                isSelected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _NavItem(
                icon: Icons.explore_outlined,
                isSelected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _NavItem(
                icon: Icons.swap_horiz_outlined,
                isSelected: _selectedIndex == 2,
                onTap: () => setState(() => _selectedIndex = 2),
                badge: 2,
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                isSelected: _selectedIndex == 3,
                onTap: () => setState(() => _selectedIndex = 3),
                badge: 3,
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                isSelected: _selectedIndex == 4,
                onTap: () => setState(() => _selectedIndex = 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      shape: const Border(bottom: BorderSide(color: Color(0xFFA8A8A8), width: 1)),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final int? badge;

  const _NavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 54,
        height: 54,
        decoration: isSelected
            ? const BoxDecoration(
                color: Color(0xB3EDEBF3), // rgba(237, 235, 243, 0.7)
                shape: BoxShape.circle,
              )
            : null,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4), // Simulate icon borders in CSS
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            if (badge != null && badge! > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

