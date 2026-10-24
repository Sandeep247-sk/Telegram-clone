import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class TelegramDataProvider extends ChangeNotifier {
  late User currentUser;
  List<Chat> chats = [];
  Map<String, List<Message>> chatMessages = {};
  List<User> contacts = [];

  String activeFolder = 'All';
  String searchQuery = '';

  TelegramDataProvider() {
    _initMockData();
  }

  void _initMockData() {
    currentUser = const User(
      id: 'usr_me',
      name: 'Alex Mercer',
      username: 'alex_mercer',
      avatarUrl: 'https://i.pravatar.cc/300?img=11',
      bio: 'Flutter Developer | Telegram Power User 🚀',
      phoneNumber: '+1 415 555 2671',
      isOnline: true,
    );

    contacts = [
      const User(
        id: 'usr_durov',
        name: 'Pavel Durov',
        username: 'durov',
        avatarUrl: 'https://i.pravatar.cc/300?img=33',
        bio: 'Telegram Founder',
        phoneNumber: '+377 6 07 98 11',
        isOnline: true,
        isVerified: true,
      ),
      const User(
        id: 'usr_sarah',
        name: 'Sarah Jenkins',
        username: 'sarah_j',
        avatarUrl: 'https://i.pravatar.cc/300?img=5',
        bio: 'UI/UX Designer @ TechStudio',
        phoneNumber: '+1 212 555 8192',
        isOnline: true,
        lastSeen: 'online',
      ),
      const User(
        id: 'usr_alex_r',
        name: 'Alex Rivera',
        username: 'arivera',
        avatarUrl: 'https://i.pravatar.cc/300?img=12',
        bio: 'Product Lead & Coffee Enthusiast',
        phoneNumber: '+1 650 555 3019',
        isOnline: false,
        lastSeen: 'last seen 10 mins ago',
      ),
      const User(
        id: 'usr_bot',
        name: 'Telegram AI Bot',
        username: 'ai_assistant_bot',
        avatarUrl: 'https://i.pravatar.cc/300?img=60',
        bio: 'Automated AI Smart Assistant',
        phoneNumber: '',
        isOnline: true,
        isBot: true,
      ),
    ];

    // Initialize Chats
    final now = DateTime.now();

    final savedMessagesChat = Chat(
      id: 'chat_saved',
      name: 'Saved Messages',
      type: ChatType.private,
      avatarUrl: '',
      subtitle: 'Cloud storage',
      folderCategory: 'Personal',
      isPinned: true,
      bio: 'Your cloud storage for notes, files and links',
    );

    final durovChat = Chat(
      id: 'chat_durov',
      name: 'Pavel Durov',
      type: ChatType.private,
      avatarUrl: 'https://i.pravatar.cc/300?img=33',
      subtitle: 'online',
      folderCategory: 'Personal',
      isPinned: true,
      isVerified: true,
      username: 'durov',
      bio: 'Founder of Telegram & VK',
    );

    final flutterGroup = Chat(
      id: 'chat_flutter',
      name: 'Flutter Developers Official',
      type: ChatType.group,
      avatarUrl: 'https://i.pravatar.cc/300?img=68',
      subtitle: '142,500 members, 3,210 online',
      folderCategory: 'Work',
      memberCount: 142500,
      unreadCount: 4,
      isPinned: true,
      bio: 'The largest community for Flutter and Dart engineering.',
    );

    final newsChannel = Chat(
      id: 'chat_news',
      name: 'Telegram News',
      type: ChatType.channel,
      avatarUrl: 'https://i.pravatar.cc/300?img=50',
      subtitle: '6.4M subscribers',
      folderCategory: 'Channels',
      memberCount: 6400000,
      isVerified: true,
      unreadCount: 12,
      bio: 'Official news and announcements from Telegram.',
    );

    final sarahChat = Chat(
      id: 'chat_sarah',
      name: 'Sarah Jenkins',
      type: ChatType.private,
      avatarUrl: 'https://i.pravatar.cc/300?img=5',
      subtitle: 'online',
      folderCategory: 'Work',
      unreadCount: 1,
      username: 'sarah_j',
    );

    final aiBotChat = Chat(
      id: 'chat_aibot',
      name: 'Telegram AI Assistant',
      type: ChatType.private,
      avatarUrl: 'https://i.pravatar.cc/300?img=60',
      subtitle: 'bot',
      folderCategory: 'Personal',
      username: 'ai_assistant_bot',
      bio: 'Smart assistant powered by LLM',
    );

    final techTrendsChannel = Chat(
      id: 'chat_tech',
      name: 'Tech & AI Insights Daily',
      type: ChatType.channel,
      avatarUrl: 'https://i.pravatar.cc/300?img=22',
      subtitle: '89.2K subscribers',
      folderCategory: 'Channels',
      memberCount: 89200,
      bio: 'Daily news on AI, Mobile Tech and Open Source.',
    );

    chats = [
      savedMessagesChat,
      durovChat,
      flutterGroup,
      newsChannel,
      sarahChat,
      aiBotChat,
      techTrendsChannel,
    ];

    // Seed Messages
    chatMessages['chat_saved'] = [
      Message(
        id: 'm_s1',
        chatId: 'chat_saved',
        senderId: currentUser.id,
        senderName: currentUser.name,
        text: '📌 Flutter Telegram Clone project structure & checklist',
        timestamp: now.subtract(const Duration(hours: 5)),
        isSentByMe: true,
      ),
      Message(
        id: 'm_s2',
        chatId: 'chat_saved',
        senderId: currentUser.id,
        senderName: currentUser.name,
        text: 'Voice note demo item',
        timestamp: now.subtract(const Duration(hours: 2)),
        isSentByMe: true,
        messageType: MessageType.voice,
        voiceDuration: '0:24',
      ),
    ];

    chatMessages['chat_durov'] = [
      Message(
        id: 'm_d1',
        chatId: 'chat_durov',
        senderId: 'usr_durov',
        senderName: 'Pavel Durov',
        text: 'Welcome to Telegram! Freedom of communication is our priority.',
        timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        isSentByMe: false,
      ),
      Message(
        id: 'm_d2',
        chatId: 'chat_durov',
        senderId: currentUser.id,
        senderName: currentUser.name,
        text: 'The new UI design and speed are unbelievable! Great work.',
        timestamp: now.subtract(const Duration(minutes: 45)),
        isSentByMe: true,
        isRead: true,
      ),
      Message(
        id: 'm_d3',
        chatId: 'chat_durov',
        senderId: 'usr_durov',
        senderName: 'Pavel Durov',
        text: 'Thank you! We just pushed our newest update with enhanced privacy and mini apps.',
        timestamp: now.subtract(const Duration(minutes: 10)),
        isSentByMe: false,
        reactions: ['🔥', '❤️'],
      ),
    ];

    chatMessages['chat_flutter'] = [
      Message(
        id: 'm_f1',
        chatId: 'chat_flutter',
        senderId: 'usr_alex_r',
        senderName: 'Alex Rivera',
        text: 'Has anyone tested the latest Flutter 3.29 release with Impeller renderer?',
        timestamp: now.subtract(const Duration(hours: 3)),
        isSentByMe: false,
      ),
      Message(
        id: 'm_f2',
        chatId: 'chat_flutter',
        senderId: 'usr_sarah',
        senderName: 'Sarah Jenkins',
        text: 'Yes! Smooth 120 FPS animations on mobile devices. It works flawlessly.',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 20)),
        isSentByMe: false,
        reactions: ['👍', '🚀'],
      ),
      Message(
        id: 'm_f3',
        chatId: 'chat_flutter',
        senderId: currentUser.id,
        senderName: currentUser.name,
        text: 'Building a Telegram Clone using Flutter right now! The UI response is instant.',
        timestamp: now.subtract(const Duration(minutes: 15)),
        isSentByMe: true,
        isRead: true,
      ),
    ];

    chatMessages['chat_news'] = [
      Message(
        id: 'm_n1',
        chatId: 'chat_news',
        senderId: 'telegram_official',
        senderName: 'Telegram News',
        text: '🎉 Telegram reaches 950 million active users worldwide!\n\nThank you to our incredible global community for supporting open, fast, and secure messaging.',
        timestamp: now.subtract(const Duration(hours: 4)),
        isSentByMe: false,
        reactions: ['🎉', '🔥', '❤️'],
      ),
    ];

    chatMessages['chat_sarah'] = [
      Message(
        id: 'm_s1',
        chatId: 'chat_sarah',
        senderId: 'usr_sarah',
        senderName: 'Sarah Jenkins',
        text: 'Hey Alex! Did you finish reviewing the Figma mockups for the new chat screens?',
        timestamp: now.subtract(const Duration(minutes: 30)),
        isSentByMe: false,
      ),
    ];

    chatMessages['chat_aibot'] = [
      Message(
        id: 'm_b1',
        chatId: 'chat_aibot',
        senderId: 'usr_bot',
        senderName: 'Telegram AI Assistant',
        text: 'Hello! I am your AI Assistant. Ask me anything or send me a text to test automated smart replies!',
        timestamp: now.subtract(const Duration(hours: 12)),
        isSentByMe: false,
      ),
    ];

    chatMessages['chat_tech'] = [
      Message(
        id: 'm_t1',
        chatId: 'chat_tech',
        senderId: 'tech_channel',
        senderName: 'Tech & AI Insights',
        text: '⚡ Breaking: Open Source AI Models achieve state-of-the-art benchmark scores across coding and mobile deployment tasks.',
        timestamp: now.subtract(const Duration(hours: 6)),
        isSentByMe: false,
      ),
    ];

    // Set last messages for chats
    for (var chat in chats) {
      final list = chatMessages[chat.id];
      if (list != null && list.isNotEmpty) {
        chat.lastMessage = list.last;
      }
    }
  }

  // Filtered Chats
  List<Chat> get filteredChats {
    return chats.where((chat) {
      // Folder filter
      if (activeFolder != 'All') {
        if (chat.folderCategory != activeFolder) {
          // Special exception: Groups tab matches ChatType.group
          if (activeFolder == 'Groups' && chat.isGroup) {
            // match
          } else if (activeFolder == 'Channels' && chat.isChannel) {
            // match
          } else {
            return false;
          }
        }
      }

      // Search filter
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final nameMatch = chat.name.toLowerCase().contains(query);
        final messageMatch = chat.lastMessage?.text.toLowerCase().contains(query) ?? false;
        return nameMatch || messageMatch;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        // Pinned chats first
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;

        // Sort by last message time
        final timeA = a.lastMessage?.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
        final timeB = b.lastMessage?.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
        return timeB.compareTo(timeA);
      });
  }

  void setActiveFolder(String folder) {
    activeFolder = folder;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  // Actions
  void sendMessage(
    String chatId,
    String text, {
    MessageType type = MessageType.text,
    String? replyToId,
    String? replyToText,
    String? mediaUrl,
    String? voiceDuration,
    String? fileName,
    String? fileSize,
  }) {
    final now = DateTime.now();
    final newMessage = Message(
      id: 'm_${now.millisecondsSinceEpoch}',
      chatId: chatId,
      senderId: currentUser.id,
      senderName: currentUser.name,
      text: text,
      timestamp: now,
      isSentByMe: true,
      isRead: false,
      replyToMessageId: replyToId,
      replyToText: replyToText,
      mediaUrl: mediaUrl,
      messageType: type,
      voiceDuration: voiceDuration,
      fileName: fileName,
      fileSize: fileSize,
    );

    if (!chatMessages.containsKey(chatId)) {
      chatMessages[chatId] = [];
    }
    chatMessages[chatId]!.add(newMessage);

    // Update last message in chat list
    final chatIndex = chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      chats[chatIndex].lastMessage = newMessage;
    }

    notifyListeners();

    // Simulated Auto-Reply for bots or specific contacts
    _simulateResponse(chatId, text);
  }

  void _simulateResponse(String chatId, String userText) {
    final chatIndex = chats.indexWhere((c) => c.id == chatId);
    if (chatIndex == -1) return;
    final chat = chats[chatIndex];

    Timer(const Duration(seconds: 1, milliseconds: 500), () {
      String replyText = '';
      String senderName = chat.name;
      String senderId = 'usr_bot';

      if (chat.id == 'chat_aibot') {
        replyText = _getAiResponse(userText);
      } else if (chat.id == 'chat_durov') {
        replyText = "Thanks for your input, Alex! We are working hard on the next Telegram update.";
        senderId = 'usr_durov';
        senderName = 'Pavel Durov';
      } else if (chat.id == 'chat_sarah') {
        replyText = "Awesome! Let me check that and get back to you shortly 👍";
        senderId = 'usr_sarah';
        senderName = 'Sarah Jenkins';
      } else if (chat.isGroup) {
        replyText = "That's a great point! Flutter makes building cross-platform UI so fast.";
        senderId = 'usr_alex_r';
        senderName = 'Alex Rivera';
      } else {
        return;
      }

      final now = DateTime.now();
      final replyMsg = Message(
        id: 'm_reply_${now.millisecondsSinceEpoch}',
        chatId: chatId,
        senderId: senderId,
        senderName: senderName,
        text: replyText,
        timestamp: now,
        isSentByMe: false,
      );

      chatMessages[chatId]?.add(replyMsg);
      chat.lastMessage = replyMsg;
      chat.unreadCount += 1;

      // Mark sent messages as read
      final list = chatMessages[chatId];
      if (list != null) {
        for (var m in list) {
          if (m.isSentByMe) m.isRead = true;
        }
      }

      notifyListeners();
    });
  }

  String _getAiResponse(String input) {
    final lower = input.toLowerCase();
    if (lower.contains('hello') || lower.contains('hi')) {
      return "Hello Alex! How can I assist you with your Telegram Clone today?";
    } else if (lower.contains('flutter') || lower.contains('code')) {
      return "Flutter is Google's UI toolkit for crafting beautiful, natively compiled applications for mobile, web, and desktop from a single codebase!";
    } else if (lower.contains('feature') || lower.contains('telegram')) {
      return "Telegram features include end-to-end secret chats, cloud sync, massive groups up to 200,000 members, custom themes, bots, and fast media delivery.";
    } else {
      return "I received your message: '$input'. Everything is synchronized smoothly with your cloud storage!";
    }
  }

  void markAsRead(String chatId) {
    final chatIndex = chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      chats[chatIndex].unreadCount = 0;
    }

    final list = chatMessages[chatId];
    if (list != null) {
      for (var m in list) {
        m.isRead = true;
      }
    }

    notifyListeners();
  }

  void togglePinChat(String chatId) {
    final chatIndex = chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      chats[chatIndex].isPinned = !chats[chatIndex].isPinned;
      notifyListeners();
    }
  }

  void toggleMuteChat(String chatId) {
    final chatIndex = chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      chats[chatIndex].isMuted = !chats[chatIndex].isMuted;
      notifyListeners();
    }
  }

  void deleteChat(String chatId) {
    chats.removeWhere((c) => c.id == chatId);
    chatMessages.remove(chatId);
    notifyListeners();
  }

  void addReaction(String chatId, String messageId, String emoji) {
    final list = chatMessages[chatId];
    if (list != null) {
      final msg = list.firstWhere((m) => m.id == messageId, orElse: () => list.first);
      if (msg.reactions.contains(emoji)) {
        msg.reactions.remove(emoji);
      } else {
        msg.reactions.add(emoji);
      }
      notifyListeners();
    }
  }

  void addContact(String name, String username, String phone) {
    final newUser = User(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      username: username,
      avatarUrl: 'https://i.pravatar.cc/300?img=${contacts.length + 10}',
      bio: 'New Telegram Contact',
      phoneNumber: phone,
    );
    contacts.add(newUser);

    // Create a new chat for this contact
    final newChat = Chat(
      id: 'chat_${newUser.id}',
      name: newUser.name,
      type: ChatType.private,
      avatarUrl: newUser.avatarUrl,
      subtitle: 'last seen recently',
      folderCategory: 'Personal',
      username: newUser.username,
    );
    chats.add(newChat);
    chatMessages[newChat.id] = [];

    notifyListeners();
  }

  void createGroup(String groupName, List<User> selectedMembers) {
    final newChat = Chat(
      id: 'chat_g_${DateTime.now().millisecondsSinceEpoch}',
      name: groupName,
      type: ChatType.group,
      avatarUrl: 'https://i.pravatar.cc/300?img=40',
      subtitle: '${selectedMembers.length + 1} members',
      folderCategory: 'Groups',
      memberCount: selectedMembers.length + 1,
      bio: 'New group created by ${currentUser.name}',
    );

    chats.add(newChat);
    chatMessages[newChat.id] = [
      Message(
        id: 'm_init_${DateTime.now().millisecondsSinceEpoch}',
        chatId: newChat.id,
        senderId: currentUser.id,
        senderName: currentUser.name,
        text: 'Created group "$groupName"',
        timestamp: DateTime.now(),
        isSentByMe: true,
      )
    ];
    newChat.lastMessage = chatMessages[newChat.id]!.first;

    notifyListeners();
  }
}
