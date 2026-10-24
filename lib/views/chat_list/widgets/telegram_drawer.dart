import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_theme_provider.dart';
import '../../../providers/telegram_data_provider.dart';
import '../../contacts/new_chat_screen.dart';
import '../../settings/settings_screen.dart';
import '../../chat_detail/chat_detail_screen.dart';

class TelegramDrawer extends StatefulWidget {
  const TelegramDrawer({super.key});

  @override
  State<TelegramDrawer> createState() => _TelegramDrawerState();
}

class _TelegramDrawerState extends State<TelegramDrawer> {
  bool _isAccountExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeProvider = Provider.of<AppThemeProvider>(context);
    final dataProvider = Provider.of<TelegramDataProvider>(context);
    final user = dataProvider.currentUser;

    return Drawer(
      child: Column(
        children: [
          // Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF212D3B) : theme.primaryColor,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              backgroundImage: user.avatarUrl.isNotEmpty
                  ? NetworkImage(user.avatarUrl)
                  : null,
              child: user.avatarUrl.isEmpty
                  ? Text(
                      user.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            otherAccountsPictures: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  color: Colors.white,
                ),
                tooltip: 'Toggle Theme',
                onPressed: () {
                  themeProvider.toggleNightMode();
                },
              ),
            ],
            accountName: Text(
              user.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            accountEmail: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.phoneNumber,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isAccountExpanded = !_isAccountExpanded;
                    });
                  },
                  child: Icon(
                    _isAccountExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          if (_isAccountExpanded)
            Container(
              color: isDark ? const Color(0xFF1C2733) : Colors.grey.shade100,
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 14,
                      child: Icon(Icons.person, size: 16),
                    ),
                    title: Text(user.name),
                    trailing: const Icon(Icons.check_circle, color: Colors.blue),
                  ),
                  ListTile(
                    leading: const Icon(Icons.add, color: Colors.blue),
                    title: const Text('Add Account'),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add Account tapped')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),

          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerTile(
                  icon: Icons.group_outlined,
                  title: 'New Group',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NewChatScreen(initialTab: 0),
                      ),
                    );
                  },
                ),
                _DrawerTile(
                  icon: Icons.person_outline,
                  title: 'Contacts',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NewChatScreen(),
                      ),
                    );
                  },
                ),
                _DrawerTile(
                  icon: Icons.call_outlined,
                  title: 'Calls',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Telegram Calls feature selected')),
                    );
                  },
                ),
                _DrawerTile(
                  icon: Icons.bookmark_border_rounded,
                  title: 'Saved Messages',
                  onTap: () {
                    Navigator.pop(context);
                    final savedChat = dataProvider.chats.firstWhere(
                      (c) => c.id == 'chat_saved',
                      orElse: () => dataProvider.chats.first,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatDetailScreen(chat: savedChat),
                      ),
                    );
                  },
                ),
                _DrawerTile(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),
                _DrawerTile(
                  icon: Icons.person_add_outlined,
                  title: 'Invite Friends',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share Telegram link with friends')),
                    );
                  },
                ),
                _DrawerTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Telegram Features',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Telegram v10.5 Features')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
