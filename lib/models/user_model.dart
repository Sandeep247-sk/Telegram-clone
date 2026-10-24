class User {
  final String id;
  final String name;
  final String username;
  final String avatarUrl;
  final String bio;
  final String phoneNumber;
  final bool isOnline;
  final String lastSeen;
  final bool isVerified;
  final bool isBot;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarUrl,
    required this.bio,
    required this.phoneNumber,
    this.isOnline = false,
    this.lastSeen = 'Recently',
    this.isVerified = false,
    this.isBot = false,
  });

  String get initials {
    if (name.isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length > 1 && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
