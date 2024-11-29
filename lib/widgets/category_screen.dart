import 'package:flutter/material.dart';
import '../views/newsbycategory.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  final List<Map<String, dynamic>> categories = [
    {
      'category': 'Technology',
      'description': 'Latest trends and innovations in the tech world.',
      'icon': Icons.computer,
      'gradient': [const Color(0xFF6B73FF), const Color(0xFF000DFF)],
    },
    {
      'category': 'Sports',
      'description': 'Updates on recent matches, scores, and sports news.',
      'icon': Icons.sports_baseball,
      'gradient': [const Color(0xFFFF416C), const Color(0xFFFF4B2B)],
    },
    {
      'category': 'Health',
      'description': 'Tips and insights on health and wellness.',
      'icon': Icons.health_and_safety,
      'gradient': [const Color(0xFF56AB2F), const Color(0xFFA8E063)],
    },
    {
      'category': 'Entertainment',
      'description': 'News about movies, shows, and celebrity updates.',
      'icon': Icons.movie,
      'gradient': [const Color(0xFFDA4453), const Color(0xFF89216B)],
    },
    {
      'category': 'Business',
      'description': 'Latest business news and market updates.',
      'icon': Icons.business,
      'gradient': [const Color(0xFF2C3E50), const Color(0xFF3498DB)],
    },
    {
      'category': 'Science',
      'description': 'Discoveries and advances in scientific research.',
      'icon': Icons.science,
      'gradient': [const Color(0xFF4776E6), const Color(0xFF8E54E9)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[100]!,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: category['gradient'],
                ),
                boxShadow: [
                  BoxShadow(
                    color: category['gradient'][0].withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return NewsListBycategory(
                            category: category['category'],
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Icon(
                            category['icon'],
                            size: 120,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                category['icon'],
                                size: 35,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                category['category'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Text(
                                  category['description'],
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
