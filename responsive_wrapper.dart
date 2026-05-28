import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // threshold for desktop/tablet view
        final isLargeScreen = constraints.maxWidth > 600;

        if (isLargeScreen) {
          // On Desktop/Web, we allow the app to take more space but keep it centered or expanded
          // The user specifically said "Chrome/Edge should run as desktop, not forced mobile"
          // and "available space properly and allow all buttons/icons to be reachable".
          
          return Scaffold(
            backgroundColor: const Color(0xFFF2F0F7),
            body: child, // Just return the child directly so it can use the full desktop space
          );
        }

        // Standard full-screen mobile behavior
        return child;
      },
    );
  }
}
