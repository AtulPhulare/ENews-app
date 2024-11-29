import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/theme_controller.dart';
import '../views/article_screen.dart';

class ArticleCard extends StatelessWidget {
  final String image;
  final String title;
  final String des;
  final String source;
  final String date;
  final String author;

  const ArticleCard({
    super.key,
    required this.image,
    required this.title,
    required this.des,
    required this.source,
    required this.date,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    String formattedDate;
    try {
      final DateTime parsedDate = DateTime.parse(date);
      formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      formattedDate = date;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      color: themeController.isDarkMode.value ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return ArticleScreen(
                  title: title,
                  author: author,
                  date: formattedDate,
                  content: des,
                  imageUrl: image,
                  source: source,
                );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeController.isDarkMode.value
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    des,
                    style: TextStyle(
                      fontSize: 14,
                      color: themeController.isDarkMode.value
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        source,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: themeController.isDarkMode.value
                              ? Colors.white60
                              : Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
