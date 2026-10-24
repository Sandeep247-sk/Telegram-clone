import 'package:flutter/material.dart';
import '../theme/telegram_theme.dart';

enum ThemeModeOption { system, light, dark }

class AppThemeProvider extends ChangeNotifier {
  ThemeModeOption _themeModeOption = ThemeModeOption.system;
  Color _accentColor = TelegramTheme.primaryBlue;
  String _selectedWallpaper = 'default';

  ThemeModeOption get themeModeOption => _themeModeOption;
  Color get accentColor => _accentColor;
  String get selectedWallpaper => _selectedWallpaper;

  bool isDarkMode(BuildContext context) {
    if (_themeModeOption == ThemeModeOption.dark) return true;
    if (_themeModeOption == ThemeModeOption.light) return false;
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  void setThemeMode(ThemeModeOption mode) {
    _themeModeOption = mode;
    notifyListeners();
  }

  void toggleNightMode() {
    if (_themeModeOption == ThemeModeOption.dark) {
      _themeModeOption = ThemeModeOption.light;
    } else {
      _themeModeOption = ThemeModeOption.dark;
    }
    notifyListeners();
  }

  void setAccentColor(Color color) {
    _accentColor = color;
    notifyListeners();
  }

  void setWallpaper(String wallpaper) {
    _selectedWallpaper = wallpaper;
    notifyListeners();
  }

  ThemeData get lightTheme => TelegramTheme.lightTheme(_accentColor);
  ThemeData get darkTheme => TelegramTheme.darkTheme(_accentColor);
}
