enum MessageType { text, image, voice, file, poll }

class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isSentByMe;
  bool isRead;
  bool isPinned;
  final String? replyToMessageId;
  final String? replyToText;
  final String? mediaUrl;
  final MessageType messageType;
  final String? voiceDuration;
  final String? fileName;
  final String? fileSize;
  final List<String> reactions;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isSentByMe,
    this.isRead = true,
    this.isPinned = false,
    this.replyToMessageId,
    this.replyToText,
    this.mediaUrl,
    this.messageType = MessageType.text,
    this.voiceDuration,
    this.fileName,
    this.fileSize,
    List<String>? reactions,
  }) : reactions = reactions ?? [];

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
