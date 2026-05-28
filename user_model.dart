class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String phoneNumber;
  final String avatarUrl;
  final String location;
  final String bio;
  final double rating;
  final int reviewCount;
  final int swapsCompleted;
  final List<UserSkill> skillsOffered;
  final List<UserSkill> skillsWanted;
  final bool isVerified;
  final bool isOnline;
  final Map<String, String> socialLinks;

  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.email = '',
    this.phoneNumber = '',
    required this.avatarUrl,
    required this.location,
    required this.bio,
    required this.rating,
    required this.reviewCount,
    required this.swapsCompleted,
    required this.skillsOffered,
    required this.skillsWanted,
    this.isVerified = false,
    this.isOnline = false,
    this.socialLinks = const {},
  });

  UserModel copyWith({
    String? name,
    String? username,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    String? location,
    String? bio,
    List<UserSkill>? skillsOffered,
    List<UserSkill>? skillsWanted,
    Map<String, String>? socialLinks,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      rating: rating,
      reviewCount: reviewCount,
      swapsCompleted: swapsCompleted,
      skillsOffered: skillsOffered ?? this.skillsOffered,
      skillsWanted: skillsWanted ?? this.skillsWanted,
      isVerified: isVerified,
      isOnline: isOnline,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }
}

class UserSkill {
  final String name;
  final String level; // Beginner, Intermediate, Advanced, Expert

  const UserSkill({
    required this.name,
    required this.level,
  });
}

