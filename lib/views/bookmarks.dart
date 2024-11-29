import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/theme_controller.dart';
import '../widgets/article_card.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  final ThemeController themeController = Get.find<ThemeController>();
  List<dynamic> bookmarks = [];
  bool isLoading = true;
  Future<void> loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bookmarksData = prefs.getString('bookmarks');

    if (bookmarksData != null && bookmarksData.isNotEmpty) {
      setState(() {
        bookmarks = jsonDecode(bookmarksData);
      });
    } else {
      setState(() {
        bookmarks = [];
      });
    }
  }

  Future<void> removeBookmark(int index) async {
    setState(() {
      bookmarks.removeAt(index);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('bookmarks', jsonEncode(bookmarks));
  }

  @override
  void initState() {
    super.initState();
    loadBookmarks().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: const Text('Bookmarks'),
            backgroundColor: themeController.isDarkMode.value
                ? Colors.grey[850]
                : Colors.white,
            iconTheme: IconThemeData(
              color: themeController.isDarkMode.value
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          backgroundColor: themeController.isDarkMode.value
              ? Colors.grey[850]
              : Colors.grey[50],
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : bookmarks.isEmpty
                  ? Center(
                      child: Text(
                        'No bookmarks available',
                        style: TextStyle(
                          color: themeController.isDarkMode.value
                              ? Colors.white70
                              : Colors.black54,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: bookmarks.length,
                      itemBuilder: (context, index) {
                        var article = bookmarks[index];
                        return Dismissible(
                          key: Key(index.toString()),
                          direction: DismissDirection
                              .startToEnd, // Only allow swipe to the right
                          onDismissed: (direction) {
                            removeBookmark(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${article['title']} removed',
                                  style: const TextStyle(
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
                          },
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.redAccent, Colors.red],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          child: ArticleCard(
                            image: article['imageUrl'],
                            title: article['title'],
                            des: article['content'],
                            source: article['source'],
                            date: article['date'],
                            author: article['author'],
                          ),
                        );
                      },
                    ),
        ));
  }
}
