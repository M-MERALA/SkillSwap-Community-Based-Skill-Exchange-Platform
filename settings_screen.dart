import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  bool _location = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Account Settings'),
            _buildSettingItem(
              context,
              'Edit Profile',
              Icons.person_outline,
              onTap: () => Navigator.pushNamed(context, '/edit_profile'),
            ),
            _buildSettingItem(
              context,
              'Security & Password',
              Icons.lock_outline,
              onTap: () => _showComingSoon(context),
            ),
            _buildSettingItem(
              context,
              'Privacy Settings',
              Icons.privacy_tip_outlined,
              onTap: () => Navigator.pushNamed(context, '/privacy'),
            ),
            
            SizedBox(height: 30),
            _buildSectionTitle(context, 'Preferences'),
            _buildToggleItem(
              context,
              'Push Notifications',
              Icons.notifications_none,
              _notifications,
              (val) => setState(() => _notifications = val),
            ),
            _buildToggleItem(
              context,
              'Dark Mode',
              Icons.dark_mode_outlined,
              _darkMode,
              (val) => setState(() => _darkMode = val),
            ),
            _buildToggleItem(
              context,
              'Location Services',
              Icons.location_on_outlined,
              _location,
              (val) => setState(() => _location = val),
            ),

            SizedBox(height: 30),
            _buildSectionTitle(context, 'Support'),
            _buildSettingItem(
              context,
              'Help & FAQ',
              Icons.help_outline,
              onTap: () => Navigator.pushNamed(context, '/help'),
            ),
            _buildSettingItem(
              context,
              'Terms of Service',
              Icons.description_outlined,
              onTap: () => Navigator.pushNamed(context, '/terms'),
            ),
            
            SizedBox(height: 50),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false),
                child: Text(
                  'Logout',
                  style: GoogleFonts.inter(
                    color: AppColors.error,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Version 1.0.42 (Beta)',
                style: TextStyle(color: AppColors.textHint, fontSize: 12),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.textHint,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, IconData icon, {required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
        onTap: onTap,
      ),
    );
  }

  Widget _buildToggleItem(BuildContext context, String title, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary),
        title: Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.w600)),
        value: value,
        activeColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feature coming in the next update!')),
    );
  }
}

