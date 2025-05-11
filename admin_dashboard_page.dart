import 'package:flutter/material.dart';
import 'admin_page.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

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
                // Top-right user icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminPage()),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'App Data',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                // Custom Grid Buttons with images and count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.1,
                    children: const [
                      _DashboardImageButton(
                        label: 'Login history',
                        imageUrl: 'https://cdn-icons-png.flaticon.com/512/987/987473.png',
                      ),
                      _DashboardImageButton(
                        label: 'Photo Details',
                        imageUrl: 'https://i.pinimg.com/564x/0c/d9/7e/0cd97ef433ff3b2bf7708e0aec62e169.jpg',
                      ),
                      _DashboardImageButton(
                        label: 'Feedback',
                        imageUrl: 'https://media.istockphoto.com/id/946716862/vector/vector-illustration-icon-emoticon-flat-design-concept-feedback-service-customer-experience.jpg?s=612x612&w=0&k=20&c=CqBRWHqg0AdHbgLgwAvzolYNsOLeLsFHpx_MeouBiOg=',
                      ),
                      _DashboardImageButton(
                        label: 'Map',
                        imageUrl: 'https://cdn-icons-png.flaticon.com/512/1865/1865269.png',
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Static Home Icon
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Icon(Icons.home, size: 30),
                      Text("Home", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardImageButton extends StatelessWidget {
  final String imageUrl;
  final String label;

  const _DashboardImageButton({required this.imageUrl, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle tap
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(color: Colors.green),
        ),
        elevation: 3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(imageUrl, width: 40, height: 40),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
