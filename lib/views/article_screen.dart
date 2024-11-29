import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/theme_controller.dart';

class ArticleScreen extends StatefulWidget {
  final String title;
  final String author;
  final String date;
  final String content;
  final String imageUrl;
  final String source;

  const ArticleScreen({
    super.key,
    required this.title,
    required this.author,
    required this.date,
    required this.content,
    required this.imageUrl,
    required this.source,
  });

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    checkIfBookmarked();
  }

  Future<void> checkIfBookmarked() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bookmarksString = prefs.getString('bookmarks');
    List<dynamic> bookmarks = bookmarksString != null
        ? json.decode(bookmarksString) as List<dynamic>
        : [];

    setState(() {
      isBookmarked = bookmarks.any((item) => item['title'] == widget.title);
    });
  }

  Future<void> addBookmark(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bookmarksString = prefs.getString('bookmarks');
    List<dynamic> bookmarks = bookmarksString != null
        ? json.decode(bookmarksString) as List<dynamic>
        : [];

    final article = {
      'title': widget.title,
      'author': widget.author,
      'date': widget.date,
      'content': widget.content,
      'imageUrl': widget.imageUrl,
      'source': widget.source,
    };

    bookmarks.add(article);
    await prefs.setString('bookmarks', json.encode(bookmarks));
    setState(() {
      isBookmarked = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Bookmark Added successfully',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
        elevation: 6,
      ),
    );
  }

  Future<void> removeBookmark(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bookmarksString = prefs.getString('bookmarks');
    List<dynamic> bookmarks = bookmarksString != null
        ? json.decode(bookmarksString) as List<dynamic>
        : [];

    bookmarks.removeWhere((item) => item['title'] == widget.title);
    await prefs.setString('bookmarks', json.encode(bookmarks));
    setState(() {
      isBookmarked = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Bookmark Removed Successfully',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
        elevation: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final size = MediaQuery.of(context).size;

    return Obx(() => Scaffold(
          backgroundColor: themeController.isDarkMode.value
              ? Colors.grey[850]
              : Colors.grey[50],
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: size.height * 0.4,
                floating: false,
                pinned: true,
                backgroundColor: themeController.isDarkMode.value
                    ? Colors.grey[850]
                    : Colors.white,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border_outlined,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: isBookmarked
                        ? () => removeBookmark(context)
                        : () => addBookmark(context),
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 40),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 3,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.source,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.date,
                            style: TextStyle(
                              color: themeController.isDarkMode.value
                                  ? Colors.white60
                                  : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: Text(
                              widget.author[0].toUpperCase(),
                              style: TextStyle(
                                color: themeController.isDarkMode.value
                                    ? Colors.black87
                                    : Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.author,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: themeController.isDarkMode.value
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode.value
                              ? Colors.black87
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: const Offset(2, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.content,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color: themeController.isDarkMode.value
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
