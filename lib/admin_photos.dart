import 'package:eco/admin_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'Data/Database.dart';
import 'Data/photo.dart';
import 'themed_background.dart';

// add datetaken to photodata
class AdminPhoto extends StatefulWidget {
  const AdminPhoto({super.key});

  @override
  State<AdminPhoto> createState() => _AdminPhotoState();
}

class _AdminPhotoState extends State<AdminPhoto> {
  List<Photo> photoList = [];

  @override
  void initState() {
    super.initState();
    DatabaseService.getUserPhotos((photoList) {
      setState(() {
        this.photoList = photoList;
      }
    );
    }
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
                  "Photos Details",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
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
