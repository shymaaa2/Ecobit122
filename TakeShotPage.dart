import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'themed_background.dart';

class TakeShotPage extends StatefulWidget {
  const TakeShotPage({super.key});

  @override
  State<TakeShotPage> createState() => _TakeShotPageState();
}

class _TakeShotPageState extends State<TakeShotPage> {
  int _currentIndex = 2;

  final List<Map<String, String>> items = [
    {"name": "Mango", "image": "https://listonic.com/phimageproxy/listonic/products/mango.webp"},
    {"name": "Strawberries", "image": "https://c02.purpledshub.com/uploads/sites/41/2023/09/GettyImages_154514873.jpg"},
    {"name": "Apple", "image": "https://static.wikia.nocookie.net/fruits-information/images/2/2b/Apple.jpg/revision/latest/thumbnail/width/360/height/450?cb=20180802112257"},
    {"name": "Peach", "image": "https://img.freepik.com/free-psd/ripe-peach-with-green-leaf-isolated-delicious-summer-fruit_84443-40168.jpg?semt=ais_hybrid&w=740"},
    {"name": "Guava", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-c-6pLVzJFq3yY58zR6GdR9IEVnHTNxRbCQ&s"},
    {"name": "Peach", "image": "https://img.freepik.com/free-psd/ripe-peach-with-green-leaf-isolated-delicious-summer-fruit_84443-40168.jpg?semt=ais_hybrid&w=740"},
  ];

  void _onTabTapped(int index) {
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsPage()),
      );
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ThemedBackground(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.person, color: isDark ? Colors.white : Colors.black),
                    onPressed: () {
                    },
                  ),
                ],
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Manage List",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                  prefixIcon: Icon(Icons.search, color: isDark ? Colors.white : Colors.black),
                  filled: true,
                  fillColor: isDark ? Colors.black54 : Colors.white70,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                ),
              ),
            ),

            // Scrollable List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    color: isDark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.green.shade600),
                    ),
                    child: ListTile(
                      leading: Image.network(
                        item['image']!,
                        width: 50,
                        height: 50,
                        errorBuilder: (_, __, ___) => Icon(Icons.broken_image, color: isDark ? Colors.white : Colors.black),
                      ),
                      title: Text(
                        item['name']!,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      ),
                      subtitle: Text(
                        "Status: Edible\nApril 20, 2025",
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.copy, size: 20, color: isDark ? Colors.white : Colors.black),
                          const SizedBox(width: 8),
                          const Icon(Icons.delete, color: Colors.redAccent, size: 24),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
