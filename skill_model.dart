class SkillModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String teacherId;
  final String teacherName;
  final String teacherAvatar;
  final double teacherRating;
  final double rating;
  final String thumbnailUrl;
  final String level;
  final String duration;
  final int studentCount;
  final List<String> tags;
  final List<ModuleModel> modules;
  final bool isActive;

  const SkillModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.teacherId,
    required this.teacherName,
    required this.teacherAvatar,
    required this.teacherRating,
    required this.rating,
    required this.thumbnailUrl,
    required this.level,
    required this.duration,
    required this.studentCount,
    required this.tags,
    required this.modules,
    this.isActive = true,
  });
}

class ModuleModel {
  final String id;
  final String title;
  final List<LessonModel> lessons;

  const ModuleModel({
    required this.id,
    required this.title,
    required this.lessons,
  });
}

class LessonModel {
  final String id;
  final String title;
  final String duration;
  final String videoUrl;
  final bool isCompleted;

  const LessonModel({
    required this.id,
    required this.title,
    required this.duration,
    this.videoUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    this.isCompleted = false,
  });

  LessonModel copyWith({bool? isCompleted}) {
    return LessonModel(
      id: id,
      title: title,
      duration: duration,
      videoUrl: videoUrl,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class SwapRequestModel {
  final String id;
  final String fromUserId;
  final String fromUserName;
  final String fromUserAvatar;
  final String toUserId;
  final String toUserName;
  final String toUserAvatar;
  final String offeredSkill;
  final String wantedSkill;
  final String status; // pending | accepted | declined | completed
  final DateTime createdAt;
  final String? message;

  const SwapRequestModel({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    required this.fromUserAvatar,
    required this.toUserId,
    required this.toUserName,
    required this.toUserAvatar,
    required this.offeredSkill,
    required this.wantedSkill,
    required this.status,
    required this.createdAt,
    this.message,
  });

  SwapRequestModel copyWith({
    String? id,
    String? fromUserId,
    String? fromUserName,
    String? fromUserAvatar,
    String? toUserId,
    String? toUserName,
    String? toUserAvatar,
    String? offeredSkill,
    String? wantedSkill,
    String? status,
    DateTime? createdAt,
    String? message,
  }) {
    return SwapRequestModel(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      fromUserName: fromUserName ?? this.fromUserName,
      fromUserAvatar: fromUserAvatar ?? this.fromUserAvatar,
      toUserId: toUserId ?? this.toUserId,
      toUserName: toUserName ?? this.toUserName,
      toUserAvatar: toUserAvatar ?? this.toUserAvatar,
      offeredSkill: offeredSkill ?? this.offeredSkill,
      wantedSkill: wantedSkill ?? this.wantedSkill,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      message: message ?? this.message,
    );
  }
}

class ChatModel {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String otherUserAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  const ChatModel({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    this.isOnline = false,
  });
}

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final DateTime sentAt;
  final bool isRead;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.sentAt,
    this.isRead = false,
  });
}

