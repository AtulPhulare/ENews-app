import '../widgets/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/newsappbar.dart';
import '../controllers/theme_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: themeController.isDarkMode.value
              ? Colors.grey[900]
              : Colors.grey[50],
          appBar: NewsAppBar(
            isDarkMode: themeController.isDarkMode.value,
            onThemeToggled: () => themeController.toggleTheme(),
            title: 'News App',
          ),
          body: CategoryScreen(),
        ));
  }
}
