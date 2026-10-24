import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/telegram_data_provider.dart';
import '../chat_detail/chat_detail_screen.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Chats';

  final List<String> _categories = [
    'Chats',
    'Media',
    'Links',
    'Files',
    'Music',
    'Voice',
  ];

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<TelegramDataProvider>(context);
    final query = _searchController.text.trim().toLowerCase();

    final matchingChats = dataProvider.chats.where((c) {
      if (query.isEmpty) return true;
      return c.name.toLowerCase().contains(query) ||
          (c.lastMessage?.text.toLowerCase().contains(query) ?? false);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter chip strip
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: const Color(0xFF3390EC),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: matchingChats.isEmpty
                ? Center(
                    child: Text(
                      'No results found for "$query"',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  )
                : ListView.builder(
                    itemCount: matchingChats.length,
                    itemBuilder: (context, index) {
                      final chat = matchingChats[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: chat.avatarUrl.isNotEmpty
                              ? NetworkImage(chat.avatarUrl)
                              : null,
                          child: chat.avatarUrl.isEmpty ? Text(chat.initials) : null,
                        ),
                        title: Text(
                          chat.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          chat.lastMessage?.text ?? chat.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          dataProvider.markAsRead(chat.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatDetailScreen(chat: chat),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
