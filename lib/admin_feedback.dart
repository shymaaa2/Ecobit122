import 'package:eco/admin_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'Data/Database.dart';
import 'Data/rating.dart';
import 'themed_background.dart';

class AdminFeedback extends StatefulWidget {
  const AdminFeedback({super.key});

  @override
  State<AdminFeedback> createState() => _AdminFeedbackState();
}

class _AdminFeedbackState extends State<AdminFeedback> {
  List<Rating> ratingList = [];

  @override
  void initState() {
    super.initState();
    DatabaseService.getRatings((ratingList) {
      setState(() {
        this.ratingList = ratingList;
      }
    );
    }
  );
  print(ratingList);
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
                  "Feedback",
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
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: ratingList.length,
                itemBuilder: (context, index) {
                  final rating = ratingList[index];
                  return Card(
                    color: isDark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.green.shade600),
                    ),
                    child: ListTile(
                      title: Text(
                        "User: ${rating.ratingData!.uid!}",
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      ),
                       trailing: Row( 
                        children: [
                       Text(
                        "Q1: ${rating.ratingData!.q1!}, Q2: ${rating.ratingData!.q2!}, Q3: ${rating.ratingData!.q3!}, Q4: ${rating.ratingData!.q4!}",
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                          ),
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
