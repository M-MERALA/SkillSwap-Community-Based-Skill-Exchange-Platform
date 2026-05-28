class CommunityModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final int memberCount;
  final bool isJoined;

  CommunityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.memberCount,
    this.isJoined = false,
  });

  CommunityModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? imageUrl,
    int? memberCount,
    bool? isJoined,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      memberCount: memberCount ?? this.memberCount,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}
