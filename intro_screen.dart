import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // Transition to Splash after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/signup');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBlurCircle({
    required double width,
    required double height,
    required double left,
    required double top,
    required Color color,
    required double blurSigma,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaleW = size.width / 390.0;
    final scaleH = size.height / 844.0;
    final scale = scaleW < scaleH ? scaleW : scaleH;

    return Scaffold(
      backgroundColor: const Color(0xFF5500FF),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.2, -1.0), // 168.71deg approx
            end: Alignment(0.2, 1.0),
            colors: [
              Color(0xFF5500FF), // -55.47%
              Color(0xFFFFE272), // -4.6%
              Color(0xFF5500FF), // 99.47%
            ],
            stops: [0.0, 0.05, 1.0],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Stack(
            children: [
              // Blurs as per Figma CSS
              _buildBlurCircle(width: 138 * scale, height: 248 * scale, left: 344 * scale, top: 0 * scale, color: const Color(0xFFEDEBF3), blurSigma: 85),
              _buildBlurCircle(width: 268 * scale, height: 248 * scale, left: 279 * scale, top: 270 * scale, color: const Color(0xFF5500FF), blurSigma: 131),
              _buildBlurCircle(width: 268 * scale, height: 248 * scale, left: 309 * scale, top: 475 * scale, color: const Color(0xFF5500FF), blurSigma: 130),
              _buildBlurCircle(width: 136 * scale, height: 126 * scale, left: 0 * scale, top: 502 * scale, color: const Color(0xFF5500FF), blurSigma: 130),
              _buildBlurCircle(width: 268 * scale, height: 248 * scale, left: 53 * scale, top: 703 * scale, color: const Color(0xFF5500FF), blurSigma: 130),
              _buildBlurCircle(width: 268 * scale, height: 248 * scale, left: 248 * scale, top: 703 * scale, color: const Color(0xFF5500FF), blurSigma: 130),

              // Skillswap Logo
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 371 * scale - (size.height / 2) + 54 * scale),
                  child: Text(
                    'Skillswap',
                    style: GoogleFonts.jomhuria(
                      fontSize: 108 * scale,
                      color: const Color(0xFF370F0F), // Exactly from Figma CSS
                      height: 1.0,
                    ),
                  ),
                ),
              ),

              // Loading Spinner and Tagline
              Positioned(
                left: 0,
                right: 0,
                top: 696 * scale,
                child: Column(
                  children: [
                    SizedBox(
                      width: 24 * scale,
                      height: 24 * scale,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF370F0F)),
                      ),
                    ),
                    SizedBox(height: 12 * scale),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60 * scale),
                      child: Text(
                        'Unlock your full potential and discover endless possibilities with Skill Swap',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 10 * scale,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
