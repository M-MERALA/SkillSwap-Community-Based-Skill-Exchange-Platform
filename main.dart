import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/intro_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_shell.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/saved_skills_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/terms_conditions_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/social_links_screen.dart';

import 'widgets/responsive_wrapper.dart';

void main() {
  runApp(const SkillSwapApp());
}

class SkillSwapApp extends StatelessWidget {
  const SkillSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Swap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      builder: (context, child) => ResponsiveWrapper(child: child!),
      routes: {
        '/': (context) => const IntroScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/main': (context) => const MainShell(),
        '/notifications': (context) => const NotificationsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
        '/saved': (context) => const SavedSkillsScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),
        '/terms': (context) => const TermsConditionsScreen(),
        '/help': (context) => const HelpSupportScreen(),
        '/social_links': (context) => const SocialLinksScreen(),
      },
    );
  }
}
