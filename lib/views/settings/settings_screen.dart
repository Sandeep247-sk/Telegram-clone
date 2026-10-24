import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/telegram_data_provider.dart';
import 'appearance_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<TelegramDataProvider>(context);
    final user = dataProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile tapped')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // User Header Box
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: user.avatarUrl.isNotEmpty
                      ? NetworkImage(user.avatarUrl)
                      : null,
                  child: user.avatarUrl.isEmpty
                      ? Text(
                          user.initials,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.phoneNumber,
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '@${user.username}',
                        style: const TextStyle(
                          color: Color(0xFF3390EC),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // Account Details Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Account',
              style: TextStyle(
                color: Color(0xFF3390EC),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: Text(user.phoneNumber),
            subtitle: const Text('Tap to change phone number'),
          ),
          ListTile(
            title: Text('@${user.username}'),
            subtitle: const Text('Username'),
          ),
          ListTile(
            title: Text(user.bio),
            subtitle: const Text('Bio'),
          ),
          const Divider(),

          // Settings Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Settings',
              style: TextStyle(
                color: Color(0xFF3390EC),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.palette_outlined, color: Colors.cyan),
            title: const Text('Chat Settings & Appearance'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AppearanceScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline_rounded, color: Colors.grey),
            title: const Text('Privacy and Security'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy & Security Options')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none_rounded, color: Colors.orange),
            title: const Text('Notifications and Sounds'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart_outline_rounded, color: Colors.green),
            title: const Text('Data and Storage'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined, color: Colors.blue),
            title: const Text('Chat Folders'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.devices_rounded, color: Colors.amber),
            title: const Text('Devices'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language_rounded, color: Colors.purple),
            title: const Text('Language'),
            subtitle: const Text('English'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
