import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_theme_provider.dart';
import 'providers/telegram_data_provider.dart';
import 'views/chat_list/chat_list_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => TelegramDataProvider()),
      ],
      child: const TelegramApp(),
    ),
  );
}

class TelegramApp extends StatelessWidget {
  const TelegramApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context);

    ThemeMode mode;
    switch (themeProvider.themeModeOption) {
      case ThemeModeOption.dark:
        mode = ThemeMode.dark;
        break;
      case ThemeModeOption.light:
        mode = ThemeMode.light;
        break;
      case ThemeModeOption.system:
        mode = ThemeMode.system;
        break;
    }

    return MaterialApp(
      title: 'Telegram',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: mode,
      home: const ChatListScreen(),
    );
  }
}
