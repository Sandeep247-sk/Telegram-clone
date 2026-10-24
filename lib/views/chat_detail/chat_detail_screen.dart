import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import '../../providers/app_theme_provider.dart';
import '../../providers/telegram_data_provider.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input_bar.dart';

class ChatDetailScreen extends StatefulWidget {
  final Chat chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  Message? _replyingToMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dataProvider = Provider.of<TelegramDataProvider>(context);
    final themeProvider = Provider.of<AppThemeProvider>(context);

    final messages = dataProvider.chatMessages[widget.chat.id] ?? [];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 19,
              backgroundImage: widget.chat.avatarUrl.isNotEmpty
                  ? NetworkImage(widget.chat.avatarUrl)
                  : null,
              backgroundColor: Colors.blueAccent,
              child: widget.chat.avatarUrl.isEmpty
                  ? Text(
                      widget.chat.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.chat.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.chat.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified_rounded,
                          color: Colors.blue,
                          size: 15,
                        ),
                      ],
                    ],
                  ),
                  Text(
                    widget.chat.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${widget.chat.name}...')),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 'mute') {
                dataProvider.toggleMuteChat(widget.chat.id);
              } else if (value == 'clear') {
                dataProvider.chatMessages[widget.chat.id]?.clear();
                setState(() {});
              } else if (value == 'wallpaper') {
                themeProvider.setWallpaper('pattern');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'mute',
                child: Text(widget.chat.isMuted ? 'Unmute' : 'Mute Notifications'),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear History'),
              ),
              const PopupMenuItem(
                value: 'wallpaper',
                child: Text('Change Wallpaper'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0E1621) : const Color(0xFF87A9C6),
        ),
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'No messages here yet...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return MessageBubble(
                          message: msg,
                          onReply: () {
                            setState(() {
                              _replyingToMessage = msg;
                            });
                          },
                          onReactionSelect: (emoji) {
                            dataProvider.addReaction(
                              widget.chat.id,
                              msg.id,
                              emoji,
                            );
                          },
                        );
                      },
                    ),
            ),
            MessageInputBar(
              replyingToText: _replyingToMessage?.text,
              onCancelReply: () {
                setState(() {
                  _replyingToMessage = null;
                });
              },
              onSendMessage: (text) {
                dataProvider.sendMessage(
                  widget.chat.id,
                  text,
                  replyToId: _replyingToMessage?.id,
                  replyToText: _replyingToMessage?.text,
                );
                setState(() {
                  _replyingToMessage = null;
                });
                Future.delayed(const Duration(milliseconds: 100), () {
                  _scrollToBottom();
                });
              },
              onSendAttachment: (type) {
                if (type == 'Voice') {
                  dataProvider.sendMessage(
                    widget.chat.id,
                    'Voice Message',
                    type: MessageType.voice,
                    voiceDuration: '0:22',
                  );
                } else if (type == 'Gallery') {
                  dataProvider.sendMessage(
                    widget.chat.id,
                    'Attached photo',
                    type: MessageType.image,
                    mediaUrl: 'https://i.pravatar.cc/600?img=65',
                  );
                } else if (type == 'File') {
                  dataProvider.sendMessage(
                    widget.chat.id,
                    'Telegram_Design_System.pdf',
                    type: MessageType.file,
                    fileName: 'Telegram_Design_System.pdf',
                    fileSize: '4.8 MB',
                  );
                } else {
                  dataProvider.sendMessage(
                    widget.chat.id,
                    'Sent attachment ($type)',
                  );
                }
                Future.delayed(const Duration(milliseconds: 100), () {
                  _scrollToBottom();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
