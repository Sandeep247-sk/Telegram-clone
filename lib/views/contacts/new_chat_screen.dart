import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/telegram_data_provider.dart';
import '../chat_detail/chat_detail_screen.dart';

class NewChatScreen extends StatefulWidget {
  final int initialTab;

  const NewChatScreen({super.key, this.initialTab = 0});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedUserIds = {};
  bool _isCreatingGroup = false;
  final TextEditingController _groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<TelegramDataProvider>(context);
    final contacts = dataProvider.contacts.where((u) {
      if (_searchController.text.isEmpty) return true;
      return u.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          u.username.toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isCreatingGroup ? 'New Group' : 'New Message'),
        actions: [
          if (_isCreatingGroup && _selectedUserIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: () {
                _showGroupNameDialog(context, dataProvider);
              },
            ),
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            onPressed: () {
              _showAddContactDialog(context, dataProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
          ),

          if (!_isCreatingGroup) ...[
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF3390EC),
                child: Icon(Icons.group_rounded, color: Colors.white),
              ),
              title: const Text('New Group', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() {
                  _isCreatingGroup = true;
                });
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.lock_rounded, color: Colors.white),
              ),
              title: const Text('New Secret Chat', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Secret chat mode with E2E encryption')),
                );
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.amber,
                child: Icon(Icons.campaign_rounded, color: Colors.white),
              ),
              title: const Text('New Channel', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                _showCreateChannelDialog(context, dataProvider);
              },
            ),
            const Divider(),
          ],

          // Contacts Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  _isCreatingGroup
                      ? 'Select members (${_selectedUserIds.length})'
                      : 'Sorted by last seen',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                final isSelected = _selectedUserIds.contains(contact.id);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: contact.avatarUrl.isNotEmpty
                        ? NetworkImage(contact.avatarUrl)
                        : null,
                    child: contact.avatarUrl.isEmpty ? Text(contact.initials) : null,
                  ),
                  title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    contact.isOnline ? 'online' : contact.lastSeen,
                    style: TextStyle(
                      color: contact.isOnline ? Colors.green : Theme.of(context).hintColor,
                    ),
                  ),
                  trailing: _isCreatingGroup
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedUserIds.add(contact.id);
                              } else {
                                _selectedUserIds.remove(contact.id);
                              }
                            });
                          },
                        )
                      : null,
                  onTap: () {
                    if (_isCreatingGroup) {
                      setState(() {
                        if (isSelected) {
                          _selectedUserIds.remove(contact.id);
                        } else {
                          _selectedUserIds.add(contact.id);
                        }
                      });
                    } else {
                      // Navigate to or open chat
                      final chat = dataProvider.chats.firstWhere(
                        (c) => c.name == contact.name,
                        orElse: () {
                          dataProvider.addContact(contact.name, contact.username, contact.phoneNumber);
                          return dataProvider.chats.last;
                        },
                      );
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatDetailScreen(chat: chat),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog(BuildContext context, TelegramDataProvider provider) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                provider.addContact(
                  nameCtrl.text,
                  '@${nameCtrl.text.toLowerCase().replaceAll(' ', '_')}',
                  phoneCtrl.text,
                );
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showGroupNameDialog(BuildContext context, TelegramDataProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Group Name'),
        content: TextField(
          controller: _groupNameController,
          decoration: const InputDecoration(hintText: 'Group Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_groupNameController.text.isNotEmpty) {
                final selectedMembers = provider.contacts
                    .where((c) => _selectedUserIds.contains(c.id))
                    .toList();
                provider.createGroup(_groupNameController.text, selectedMembers);
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showCreateChannelDialog(BuildContext context, TelegramDataProvider provider) {
    final channelNameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Channel'),
        content: TextField(
          controller: channelNameCtrl,
          decoration: const InputDecoration(hintText: 'Channel Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (channelNameCtrl.text.isNotEmpty) {
                provider.createGroup(channelNameCtrl.text, []);
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
