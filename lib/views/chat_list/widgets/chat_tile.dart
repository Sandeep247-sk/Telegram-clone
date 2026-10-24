import 'package:flutter/material.dart';

import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';

class ChatTile extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;
  final VoidCallback onPinToggle;
  final VoidCallback onMuteToggle;
  final VoidCallback onDelete;

  const ChatTile({
    super.key,
    required this.chat,
    required this.onTap,
    required this.onPinToggle,
    required this.onMuteToggle,
    required this.onDelete,
  });

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.red,
    ];
    final hash = name.codeUnits.fold(0, (p, c) => p + c);
    return colors[hash % colors.length];
  }

  Widget _buildAvatar(BuildContext context) {
    if (chat.id == 'chat_saved') {
      return Container(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(
          color: Color(0xFF3390EC),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.bookmark_rounded,
          color: Colors.white,
          size: 28,
        ),
      );
    }

    if (chat.avatarUrl.isNotEmpty) {
      return Stack(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(chat.avatarUrl),
          ),
          if (chat.subtitle == 'online')
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: const Color(0xFF40C463),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return CircleAvatar(
      radius: 26,
      backgroundColor: _getAvatarColor(chat.name),
      child: Text(
        chat.initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final lastMsg = chat.lastMessage;
    if (lastMsg == null) {
      return Text(
        chat.subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).hintColor, fontSize: 13),
      );
    }

    Widget statusPrefix = const SizedBox.shrink();
    if (lastMsg.isSentByMe) {
      statusPrefix = Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Icon(
          lastMsg.isRead ? Icons.done_all : Icons.done,
          size: 16,
          color: lastMsg.isRead ? const Color(0xFF3390EC) : Colors.grey,
        ),
      );
    }

    String textPreview = lastMsg.text;
    if (lastMsg.messageType == MessageType.voice) {
      textPreview = '🎤 Voice message (${lastMsg.voiceDuration ?? '0:15'})';
    } else if (lastMsg.messageType == MessageType.image) {
      textPreview = '📷 Photo';
    } else if (lastMsg.messageType == MessageType.file) {
      textPreview = '📄 File: ${lastMsg.fileName ?? 'Document'}';
    }

    return Row(
      children: [
        statusPrefix,
        Expanded(
          child: Text(
            textPreview,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: chat.unreadCount > 0
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87)
                  : Theme.of(context).hintColor,
              fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lastMsg = chat.lastMessage;

    return InkWell(
      onTap: onTap,
      onLongPress: () {
        _showContextMenu(context);
      },
      child: Container(
        color: chat.isPinned
            ? (isDark ? const Color(0xFF1E2A38) : const Color(0xFFF5F5F5))
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        child: Row(
          children: [
            _buildAvatar(context),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                chat.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (chat.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified_rounded,
                                color: Color(0xFF3390EC),
                                size: 16,
                              ),
                            ],
                            if (chat.isMuted) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.volume_off_rounded,
                                color: Theme.of(context).hintColor,
                                size: 15,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (lastMsg != null)
                        Text(
                          lastMsg.formattedTime,
                          style: TextStyle(
                            color: chat.unreadCount > 0
                                ? const Color(0xFF3390EC)
                                : Theme.of(context).hintColor,
                            fontSize: 12,
                            fontWeight: chat.unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(child: _buildSubtitle(context)),
                      if (chat.isPinned && chat.unreadCount == 0)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(
                            Icons.push_pin_rounded,
                            size: 16,
                            color: Color(0xFF8E99A2),
                          ),
                        ),
                      if (chat.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: chat.isMuted
                                ? Colors.grey
                                : const Color(0xFF3390EC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${chat.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  chat.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                ),
                title: Text(chat.isPinned ? 'Unpin Chat' : 'Pin Chat'),
                onTap: () {
                  Navigator.pop(context);
                  onPinToggle();
                },
              ),
              ListTile(
                leading: Icon(
                  chat.isMuted ? Icons.volume_up : Icons.volume_off,
                ),
                title: Text(chat.isMuted ? 'Unmute' : 'Mute Notifications'),
                onTap: () {
                  Navigator.pop(context);
                  onMuteToggle();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Chat', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
