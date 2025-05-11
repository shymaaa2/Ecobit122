import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'user_page.dart';

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
    switch (index) {
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        );
        break;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/image.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.person, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const UserPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Manage List",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      filled: true,
                      fillColor: Colors.white70,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.green),
                        ),
                        child: ListTile(
                          leading: Image.network(
                            item['image']!,
                            width: 50,
                            height: 50,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                          ),
                          title: Text(item['name']!),
                          subtitle: const Text("Status: Edible\nApril 20, 2025"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.copy, size: 20),
                              SizedBox(width: 8),
                              Icon(Icons.delete, color: Colors.red, size: 24),
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
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD2E3C8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black54,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
            onTap: _onTabTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
              BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}



