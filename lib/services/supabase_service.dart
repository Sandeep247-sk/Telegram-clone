import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://srvdrznwsryzblimfanx.supabase.co';
  static const String supabasePublishableKey = 'sb_publishable_blZkRQGJCMWQnKN2aGjObw__xra6PoO';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        publishableKey: supabasePublishableKey,
      );
      if (kDebugMode) {
        print('Supabase connected successfully: $supabaseUrl');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Supabase init error: $e');
      }
    }
  }

  // Real-time Messages Stream
  static Stream<List<Map<String, dynamic>>> streamMessages(String chatId) {
    return client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('chat_id', chatId)
        .order('timestamp', ascending: true);
  }

  // Fetch Chats from DB
  static Future<List<Chat>?> fetchChats() async {
    try {
      final response = await client.from('chats').select();
      final List data = response as List;
      return data.map((json) {
        return Chat(
          id: json['id'].toString(),
          name: json['name'] ?? 'Chat',
          type: _parseChatType(json['type']),
          avatarUrl: json['avatar_url'] ?? '',
          subtitle: json['subtitle'] ?? '',
          folderCategory: json['folder_category'] ?? 'Personal',
          unreadCount: json['unread_count'] ?? 0,
          isPinned: json['is_pinned'] ?? false,
          isMuted: json['is_muted'] ?? false,
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) print('Fetch chats error (using mock fallback): $e');
      return null;
    }
  }

  // Fetch Messages for a Chat
  static Future<List<Message>?> fetchMessages(String chatId) async {
    try {
      final response = await client
          .from('messages')
          .select()
          .eq('chat_id', chatId)
          .order('timestamp', ascending: true);

      final List data = response as List;
      return data.map((json) {
        return Message(
          id: json['id'].toString(),
          chatId: json['chat_id'].toString(),
          senderId: json['sender_id'].toString(),
          senderName: json['sender_name'] ?? 'User',
          text: json['text'] ?? '',
          timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
          isSentByMe: json['is_sent_by_me'] ?? true,
          isRead: json['is_read'] ?? true,
          messageType: _parseMessageType(json['message_type']),
          voiceDuration: json['voice_duration'],
          mediaUrl: json['media_url'],
          fileName: json['file_name'],
          fileSize: json['file_size'],
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) print('Fetch messages error (using local state): $e');
      return null;
    }
  }

  // Insert Message
  static Future<bool> sendMessage(Message message) async {
    try {
      await client.from('messages').insert({
        'id': message.id,
        'chat_id': message.chatId,
        'sender_id': message.senderId,
        'sender_name': message.senderName,
        'text': message.text,
        'timestamp': message.timestamp.toIso8601String(),
        'is_sent_by_me': message.isSentByMe,
        'is_read': message.isRead,
        'message_type': message.messageType.name,
        'voice_duration': message.voiceDuration,
        'media_url': message.mediaUrl,
        'file_name': message.fileName,
        'file_size': message.fileSize,
      });
      return true;
    } catch (e) {
      if (kDebugMode) print('Supabase insert message error: $e');
      return false;
    }
  }

  // Create Chat
  static Future<bool> createChat(Chat chat) async {
    try {
      await client.from('chats').insert({
        'id': chat.id,
        'name': chat.name,
        'type': chat.type.name,
        'avatar_url': chat.avatarUrl,
        'subtitle': chat.subtitle,
        'folder_category': chat.folderCategory,
        'unread_count': chat.unreadCount,
        'is_pinned': chat.isPinned,
        'is_muted': chat.isMuted,
      });
      return true;
    } catch (e) {
      if (kDebugMode) print('Supabase create chat error: $e');
      return false;
    }
  }

  static ChatType _parseChatType(String? typeStr) {
    if (typeStr == 'group') return ChatType.group;
    if (typeStr == 'channel') return ChatType.channel;
    if (typeStr == 'secret') return ChatType.secret;
    return ChatType.private;
  }

  static MessageType _parseMessageType(String? typeStr) {
    if (typeStr == 'voice') return MessageType.voice;
    if (typeStr == 'image') return MessageType.image;
    if (typeStr == 'file') return MessageType.file;
    if (typeStr == 'poll') return MessageType.poll;
    return MessageType.text;
  }
}
