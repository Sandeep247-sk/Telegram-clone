import 'message_model.dart';

enum ChatType { private, group, channel, secret }

class Chat {
  final String id;
  final String name;
  final ChatType type;
  final String avatarUrl;
  final String subtitle;
  int unreadCount;
  bool isPinned;
  bool isMuted;
  final String folderCategory; // 'All', 'Personal', 'Work', 'Groups', 'Channels'
  Message? lastMessage;
  final bool isVerified;
  final int memberCount;
  final String bio;
  final String username;

  Chat({
    required this.id,
    required this.name,
    required this.type,
    required this.avatarUrl,
    required this.subtitle,
    this.unreadCount = 0,
    this.isPinned = false,
    this.isMuted = false,
    required this.folderCategory,
    this.lastMessage,
    this.isVerified = false,
    this.memberCount = 1,
    this.bio = '',
    this.username = '',
  });

  String get initials {
    if (name.isEmpty) return 'C';
    final parts = name.trim().split(' ');
    if (parts.length > 1 && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  bool get isGroup => type == ChatType.group;
  bool get isChannel => type == ChatType.channel;
  bool get isSecret => type == ChatType.secret;
}
