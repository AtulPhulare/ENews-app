import '../views/bookmarks.dart';
import 'package:flutter/material.dart';

class NewsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onThemeToggled;
  final bool isDarkMode;
  final String title;

  const NewsAppBar({
    super.key,
    required this.onThemeToggled,
    required this.isDarkMode,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      centerTitle: false,
      title: SingleChildScrollView(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
            letterSpacing: 0.5,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.bookmark,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 26,
          ),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const Bookmarks();
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 26,
          ),
          onPressed: onThemeToggled,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
