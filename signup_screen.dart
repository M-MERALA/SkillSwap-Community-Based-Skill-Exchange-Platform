import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';
import 'account_setup_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;

  void _signup() {
    if (_firstNameCtrl.text.isEmpty || _lastNameCtrl.text.isEmpty || _emailCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in required fields.')));
      return;
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AccountSetupScreen(
        initialName: '${_firstNameCtrl.text} ${_lastNameCtrl.text}',
        initialEmail: _emailCtrl.text,
        initialPhone: _phoneCtrl.text,
      )),
    );
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Widget _buildBlurCircle({
    required double width,
    required double height,
    required Color color,
    required double blurSigma,
  }) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5500FF),
      body: Stack(
        children: [
          // Background Gradient matching Intro
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.2, -1.0),
                end: Alignment(0.2, 1.0),
                colors: [
                  Color(0xFF5500FF),
                  Color(0xFFFFE272),
                  Color(0xFF5500FF),
                ],
                stops: [0.0, 0.05, 1.0],
              ),
            ),
          ),
          
          // Blur Circles
          Positioned(top: -50, right: -100, child: _buildBlurCircle(width: 300, height: 300, color: const Color(0xFFEDEBF3), blurSigma: 80)),
          Positioned(bottom: -100, left: -50, child: _buildBlurCircle(width: 400, height: 400, color: const Color(0xFF5500FF), blurSigma: 100)),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Skillswap Logo
                  Center(
                    child: Text(
                      'Skillswap',
                      style: GoogleFonts.jomhuria(
                        fontSize: 84,
                        color: const Color(0xFF370F0F),
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Form Container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Join Community',
                          style: GoogleFonts.raleway(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF370F0F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create an account to start swapping skills.',
                          style: GoogleFonts.lato(fontSize: 15, color: Colors.black54),
                        ),
                        const SizedBox(height: 32),
                        
                        Row(
                          children: [
                            Expanded(child: _buildPremiumField(label: 'First Name', hint: 'John', controller: _firstNameCtrl)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildPremiumField(label: 'Last Name', hint: 'Doe', controller: _lastNameCtrl)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildPremiumField(label: 'Email Address', hint: 'name@example.com', controller: _emailCtrl, icon: Icons.email_outlined),
                        const SizedBox(height: 20),
                        _buildPremiumField(label: 'Phone Number', hint: '+1 234 567 890', controller: _phoneCtrl, icon: Icons.phone_outlined),
                        const SizedBox(height: 20),
                        _buildPremiumField(label: 'Password', hint: '••••••••', controller: _passCtrl, isPassword: true, icon: Icons.lock_outline_rounded),
                        
                        const SizedBox(height: 32),
                        
                        // Signup Button
                        Container(
                          width: double.infinity,
                          height: 58,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF5500FF), Color(0xFF7B36FF)],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: _signup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            child: Text(
                              'Create Account',
                              style: GoogleFonts.publicSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Social Row
                        Row(
                          children: [
                            Expanded(child: _buildSocialButton(label: 'Google', iconAsset: 'https://img.icons8.com/color/48/000000/google-logo.png', onTap: () {})),
                            const SizedBox(width: 12),
                            Expanded(child: _buildSocialButton(label: 'Apple', icon: Icons.apple, onTap: () {})),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Footer
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: "Already a member? ", style: GoogleFonts.inter(color: Colors.white70)),
                            TextSpan(text: "Sign In", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF370F0F).withValues(alpha: 0.7)),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FE),
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && _obscurePass,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.2)),
              prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF5500FF).withValues(alpha: 0.5), size: 20) : null,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility, color: Colors.black26, size: 18),
                      onPressed: () => setState(() => _obscurePass = !_obscurePass),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({required String label, String? iconAsset, IconData? icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconAsset != null) Image.network(iconAsset, height: 18) else if (icon != null) Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}



