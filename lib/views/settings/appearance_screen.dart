import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_theme_provider.dart';
import '../../theme/telegram_theme.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context);

    final colors = [
      TelegramTheme.primaryBlue,
      Colors.teal,
      Colors.purple,
      Colors.orange,
      Colors.redAccent,
      Colors.green,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Color Theme',
              style: TextStyle(
                color: Color(0xFF3390EC),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text('System Default'),
            trailing: themeProvider.themeModeOption == ThemeModeOption.system
                ? const Icon(Icons.check_rounded, color: Color(0xFF3390EC))
                : null,
            onTap: () => themeProvider.setThemeMode(ThemeModeOption.system),
          ),
          ListTile(
            title: const Text('Light Theme'),
            trailing: themeProvider.themeModeOption == ThemeModeOption.light
                ? const Icon(Icons.check_rounded, color: Color(0xFF3390EC))
                : null,
            onTap: () => themeProvider.setThemeMode(ThemeModeOption.light),
          ),
          ListTile(
            title: const Text('Dark Theme'),
            trailing: themeProvider.themeModeOption == ThemeModeOption.dark
                ? const Icon(Icons.check_rounded, color: Color(0xFF3390EC))
                : null,
            onTap: () => themeProvider.setThemeMode(ThemeModeOption.dark),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Accent Color Palette',
              style: TextStyle(
                color: Color(0xFF3390EC),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final c = colors[index];
                final isSelected = themeProvider.accentColor == c;
                return GestureDetector(
                  onTap: () {
                    themeProvider.setAccentColor(c);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: [
                        if (isSelected)
                          const BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                          ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.wallpaper_rounded),
            title: const Text('Change Chat Wallpaper'),
            subtitle: Text('Current: ${themeProvider.selectedWallpaper}'),
            onTap: () {
              themeProvider.setWallpaper('Classic Telegram Blueprint');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wallpaper updated')),
              );
            },
          ),
        ],
      ),
    );
  }
}
