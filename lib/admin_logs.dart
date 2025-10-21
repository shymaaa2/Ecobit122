import 'package:eco/admin_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'Data/Database.dart';
import 'Data/log.dart';
import 'themed_background.dart';

class AdminLog extends StatefulWidget {
  const AdminLog({super.key});

  @override
  State<AdminLog> createState() => _AdminLogState();
}

class _AdminLogState extends State<AdminLog> {
  List<Log> logList = [];

  @override
  void initState() {
    super.initState();
    DatabaseService.getLogs((logList) {
      setState(() {
        this.logList = logList;
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
                  "Login History",
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
                itemCount: logList.length,
                itemBuilder: (context, index) {
                  final log = logList[index];
                  return Card(
                    color: isDark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.green.shade600),
                    ),
                    child: ListTile(
                      title: Text(
                        log.logData!.email!,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      ),
                      subtitle: Text(
                        "Time Logged: ${log.logData!.logTime!}",
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
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