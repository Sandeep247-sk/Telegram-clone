import 'package:flutter/material.dart';

import 'attachment_bottom_sheet.dart';

class MessageInputBar extends StatefulWidget {
  final Function(String text) onSendMessage;
  final Function(String type) onSendAttachment;
  final String? replyingToText;
  final VoidCallback? onCancelReply;

  const MessageInputBar({
    super.key,
    required this.onSendMessage,
    required this.onSendAttachment,
    this.replyingToText,
    this.onCancelReply,
  });

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isTyping = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
    }
  }

  void _showAttachmentSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AttachmentBottomSheet(
        onOptionSelected: (type) {
          widget.onSendAttachment(type);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? const Color(0xFF17212B) : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reply banner preview
          if (widget.replyingToText != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.reply_rounded,
                    color: Color(0xFF3390EC),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Replying to message',
                          style: TextStyle(
                            color: Color(0xFF3390EC),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          widget.replyingToText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: widget.onCancelReply,
                  ),
                ],
              ),
            ),
          ],

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.sentiment_satisfied_alt_rounded,
                  color: theme.hintColor,
                  size: 26,
                ),
                onPressed: () {
                  // Quick emoji insert
                  _controller.text += '😊 ';
                },
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: 5,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: theme.hintColor),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.attach_file_rounded,
                  color: theme.hintColor,
                  size: 26,
                ),
                onPressed: _showAttachmentSheet,
              ),
              const SizedBox(width: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: const BoxDecoration(
                  color: Color(0xFF3390EC),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _isTyping ? Icons.send_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    if (_isTyping) {
                      _handleSend();
                    } else {
                      // Voice record simulation
                      widget.onSendAttachment('Voice');
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
