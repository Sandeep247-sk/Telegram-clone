import 'package:flutter/material.dart';

class FolderTabBar extends StatelessWidget {
  final String activeFolder;
  final ValueChanged<String> onFolderSelected;
  final Map<String, int> unreadCounts;

  const FolderTabBar({
    super.key,
    required this.activeFolder,
    required this.onFolderSelected,
    required this.unreadCounts,
  });

  static const List<String> folders = [
    'All',
    'Personal',
    'Work',
    'Groups',
    'Channels',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF212D3B) : theme.primaryColor,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.black26 : Colors.black12,
            width: 0.5,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];
          final isSelected = folder == activeFolder;
          final unread = unreadCounts[folder] ?? 0;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => onFolderSelected(folder),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? Colors.white24 : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      folder,
                      style: TextStyle(
                        color: isSelected
                            ? (isDark ? Colors.white : theme.primaryColor)
                            : Colors.white70,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    if (unread > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? theme.primaryColor : const Color(0xFF2481CC))
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$unread',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
