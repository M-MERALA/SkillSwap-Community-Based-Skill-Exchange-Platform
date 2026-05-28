import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Curated set of known-working Unsplash photo IDs for course thumbnails
const _courseImageIds = [
  'photo-1516321318423-f06f85e504b3', // tech/laptop
  'photo-1498050108023-c5249f4df085', // coding
  'photo-1551288049-bebda4e38f71', // data/charts
  'photo-1561070791-2526d30994b5', // design
  'photo-1611532736597-de2d4265fba3', // music
  'photo-1553877522-43269d4ea984', // marketing
  'photo-1542744173-8e7e53415bb0', // business
  'photo-1434030216411-0b793f4b4173', // study
];

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? seed;
  final double size;
  final AvatarType type;
  final BoxShape shape;
  final BorderRadius? borderRadius;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.seed,
    this.size = 50,
    this.type = AvatarType.user,
    this.shape = BoxShape.circle,
    this.borderRadius,
  });

  String get _fallbackUrl {
    final s = seed ?? 'default';
    if (type == AvatarType.user) {
      // ui-avatars.com is extremely reliable — generates initials avatars
      final encoded = Uri.encodeComponent(s);
      return 'https://ui-avatars.com/api/?name=$encoded&size=200&background=5500FF&color=fff&bold=true&format=png';
    } else {
      // Pick a curated Unsplash image based on seed hash
      final idx = s.codeUnits.fold(0, (a, b) => a + b) % _courseImageIds.length;
      return 'https://images.unsplash.com/${_courseImageIds[idx]}?w=800&h=450&fit=crop&auto=format';
    }
  }

  bool get _hasValidUrl =>
      imageUrl != null && imageUrl!.isNotEmpty && imageUrl!.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final primaryUrl = _hasValidUrl ? imageUrl! : _fallbackUrl;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : (borderRadius ?? BorderRadius.circular(16)),
        color: const Color(0xFFF5F5F7),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05), width: 1),
      ),
      child: ClipRRect(
        borderRadius: shape == BoxShape.circle
            ? BorderRadius.circular(size)
            : (borderRadius ?? BorderRadius.circular(16)),
        child: CachedNetworkImage(
          imageUrl: primaryUrl,
          fit: BoxFit.cover,
          width: size,
          height: size,
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) {
            // On error, always try the guaranteed fallback
            if (url != _fallbackUrl) {
              return CachedNetworkImage(
                imageUrl: _fallbackUrl,
                fit: BoxFit.cover,
                width: size,
                height: size,
                placeholder: (context, url) => _buildPlaceholder(),
                errorWidget: (context, url, error) => _buildFallback(),
              );
            }
            return _buildFallback();
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFEDEBF3),
      child: Center(
        child: SizedBox(
          width: size * 0.4,
          height: size * 0.4,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF5500FF),
          ),
        ),
      ),
    );
  }

  Widget _buildFallback() {
    if (type == AvatarType.user) {
      // Draw initials — always works, no network needed
      final initials = (seed ?? '?')
          .split(' ')
          .take(2)
          .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
          .join();
      return Container(
        color: const Color(0xFF5500FF),
        child: Center(
          child: Text(
            initials.isEmpty ? '?' : initials,
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return Container(
        color: const Color(0xFF423061),
        child: Center(
          child: Icon(
            Icons.school_rounded,
            color: Colors.white.withValues(alpha: 0.7),
            size: size * 0.45,
          ),
        ),
      );
    }
  }
}

enum AvatarType { user, course }
