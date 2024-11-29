import 'dart:convert';
import '../widgets/article_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/newsappbar.dart';
import '../controllers/theme_controller.dart';

class NewsListBycategory extends StatefulWidget {
  final String category;
  const NewsListBycategory({super.key, required this.category});

  @override
  State<NewsListBycategory> createState() => _NewsListBycategoryState();
}

class _NewsListBycategoryState extends State<NewsListBycategory> {
  final ThemeController themeController = Get.find<ThemeController>();
  final TextEditingController searchController = TextEditingController();
  List<dynamic> articles = [];
  List<dynamic> filteredArticles = [];
  bool isLoading = true;
  String errorMessage = '';

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.only(top: 8),
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          color: themeController.isDarkMode.value
              ? Colors.grey[850]
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Shimmer.fromColors(
            baseColor: themeController.isDarkMode.value
                ? Colors.grey[850]!
                : Colors.grey[300]!,
            highlightColor: themeController.isDarkMode.value
                ? Colors.grey[800]!
                : Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    color: themeController.isDarkMode.value
                        ? Colors.grey[800]
                        : Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20,
                        width: double.infinity,
                        color: themeController.isDarkMode.value
                            ? Colors.grey[800]
                            : Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 60,
                        width: double.infinity,
                        color: themeController.isDarkMode.value
                            ? Colors.grey[800]
                            : Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 15,
                            width: 100,
                            color: themeController.isDarkMode.value
                                ? Colors.grey[800]
                                : Colors.white,
                          ),
                          Container(
                            height: 15,
                            width: 80,
                            color: themeController.isDarkMode.value
                                ? Colors.grey[800]
                                : Colors.white,
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
      },
    );
  }

  Future<void> fetchNews() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    var url =
        "https://newsapi.org/v2/top-headlines?country=us&category=${widget.category}&apiKey=e7d764843a6b4f21ad005ab7286af7a7";

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          articles = jsonData['articles'] ?? [];
          filteredArticles = articles;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load news';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error connecting to the server';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  void filterData(String query) {
    setState(() {
      filteredArticles = articles
          .where((article) => article['title']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: NewsAppBar(
            isDarkMode: themeController.isDarkMode.value,
            onThemeToggled: () => themeController.toggleTheme(),
            title: widget.category,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: filterData,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: themeController.isDarkMode.value
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    filled: true,
                    fillColor: themeController.isDarkMode.value
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: themeController.isDarkMode.value
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                  style: TextStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              if (errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.red[100],
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(errorMessage,
                          style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              Expanded(
                child: isLoading
                    ? _buildShimmerEffect()
                    : RefreshIndicator(
                        onRefresh: fetchNews,
                        child: filteredArticles.isEmpty
                            ? ListView(
                                children: [
                                  Center(
                                    child: Text(
                                      'No articles found',
                                      style: TextStyle(
                                        color: themeController.isDarkMode.value
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(top: 8),
                                itemCount: filteredArticles.length,
                                itemBuilder: (context, index) {
                                  var article = filteredArticles[index];
                                  return article['urlToImage'] == null ||
                                          article['title'] == null ||
                                          article['description'] == null ||
                                          article['source'] == null ||
                                          article['source']['name'] == null ||
                                          article['publishedAt'] == null ||
                                          article['author'] == null
                                      ? const SizedBox.shrink()
                                      : ArticleCard(
                                          image: article['urlToImage'],
                                          title: article['title'],
                                          des: article['description'],
                                          source: article['source']['name'],
                                          date: article['publishedAt'],
                                          author: article['author'],
                                        );
                                },
                              ),
                      ),
              ),
            ],
          ),
        ));
  }
}
