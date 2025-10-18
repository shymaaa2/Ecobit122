import 'package:eco/gallery.dart';
import 'package:flutter/material.dart';
import 'Data/Database.dart';
import 'Data/photo.dart';
import 'themed_background.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  List<Photo> photoList = [];
  String uid = '';
  String email = '';
  DateTime logTime = DateTime.now();

  
  void _onTabTapped(int index) {
    switch (index) {
      case 0:
       Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
      case 1:
       Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GalleryScreen()),
        );
        break;
      case 3:
      // Navigate to Map
        break;
      //case 4:
        //Navigator.push(
          //context,
          //MaterialPageRoute(builder: (_) => const SettingsPage()),
        //);
        //break;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _loadUserData() async{
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
        email = user.email ?? '';
        logTime = DateTime.timestamp();
      });
    }
    
     await DatabaseService().logUser({
          'email': email,
          'logTime': logTime,
        });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    DatabaseService.getPhotos((photoList) {
      setState(() {
        this.photoList = photoList;
      }
    );
    }, uid
  );
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
                itemCount: photoList.length,
                itemBuilder: (context, index) {
                  final photo = photoList[index];
                  return Card(
                    color: isDark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.green.shade600),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        photo.photoData!.img!,
                        width: 50,
                        height: 50,
                        errorBuilder: (_, __, ___) => Icon(Icons.broken_image, color: isDark ? Colors.white : Colors.black),
                      ),
                      title: Text(
                        photo.photoData!.note!,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      ),
                      subtitle: Text(
                        "Status: ${photo.photoData!.status}",
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
