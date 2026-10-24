import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/telegram_data_provider.dart';
import 'widgets/chat_tile.dart';
import 'widgets/folder_tab_bar.dart';
import 'widgets/telegram_drawer.dart';
import '../chat_detail/chat_detail_screen.dart';
import '../contacts/new_chat_screen.dart';
import '../search/global_search_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, int> _calculateUnreadCounts(TelegramDataProvider dataProvider) {
    Map<String, int> counts = {
      'All': 0,
      'Personal': 0,
      'Work': 0,
      'Groups': 0,
      'Channels': 0,
    };

    for (var chat in dataProvider.chats) {
      if (chat.unreadCount > 0) {
        counts['All'] = (counts['All'] ?? 0) + chat.unreadCount;
        if (counts.containsKey(chat.folderCategory)) {
          counts[chat.folderCategory] =
              (counts[chat.folderCategory] ?? 0) + chat.unreadCount;
        }
        if (chat.isGroup) {
          counts['Groups'] = (counts['Groups'] ?? 0) + chat.unreadCount;
        } else if (chat.isChannel) {
          counts['Channels'] = (counts['Channels'] ?? 0) + chat.unreadCount;
        }
      }
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<TelegramDataProvider>(context);
    final filteredChats = dataProvider.filteredChats;
    final unreadCounts = _calculateUnreadCounts(dataProvider);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const TelegramDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text('Telegram'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GlobalSearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FolderTabBar(
            activeFolder: dataProvider.activeFolder,
            onFolderSelected: (folder) {
              dataProvider.setActiveFolder(folder);
            },
            unreadCounts: unreadCounts,
          ),
          Expanded(
            child: filteredChats.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 72,
                          color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No chats found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredChats.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      indent: 78,
                    ),
                    itemBuilder: (context, index) {
                      final chat = filteredChats[index];
                      return ChatTile(
                        chat: chat,
                        onTap: () {
                          dataProvider.markAsRead(chat.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatDetailScreen(chat: chat),
                            ),
                          );
                        },
                        onPinToggle: () {
                          dataProvider.togglePinChat(chat.id);
                        },
                        onMuteToggle: () {
                          dataProvider.toggleMuteChat(chat.id);
                        },
                        onDelete: () {
                          dataProvider.deleteChat(chat.id);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3390EC),
        child: const Icon(Icons.edit_rounded, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NewChatScreen(),
            ),
          );
        },
      ),
    );
  }
}
