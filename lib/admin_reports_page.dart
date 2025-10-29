import 'package:eco/Data/Database.dart';
import 'package:eco/report_validators.dart';
import 'package:flutter/material.dart';
import 'Data/photo.dart';
import 'Data/log.dart';
import 'Data/rating.dart';
import 'admin_addLocation.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({Key? key}) : super(key: key);

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  DatabaseService databaseService = DatabaseService();
  List<Photo> photoList = [];
  List<Log> logList = [];
  List<Rating> ratingList = [];
  
  int selectedTab = 0;

  
  @override
  void initState() {
    super.initState();
    DatabaseService.getUserPhotos((photoList) {
      ReportValidators.validateEmptyReports(photoList);
      ReportValidators.validateReports(photoList);
      setState(() {
        this.photoList = photoList;
      }
    );
    }
  );

   DatabaseService.getRatings((ratingList) {
      ReportValidators.validateEmptyReports(ratingList);
      ReportValidators.validateReports(ratingList);
      setState(() {
        this.ratingList = ratingList;
      }
    );
    }
  );

   DatabaseService.getLogs((logList) {
      ReportValidators.validateEmptyReports(logList);
      ReportValidators.validateReports(logList);
      setState(() {
        this.logList = logList;
      }
    );
    }
  );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ["Photos", "Login Logs", "Feedback"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Reports"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ToggleButtons(
            isSelected: [
              selectedTab == 0,
              selectedTab == 1,
              selectedTab == 2,
            ],
            borderRadius: BorderRadius.circular(10),
            onPressed: (index) => setState(() => selectedTab = index),
            children: tabs
                .map((t) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(t, style: const TextStyle(fontSize: 16)),
            ))
                .toList(),
          ),
          const SizedBox(height: 10),
          TextButton(onPressed:()=> {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminAddLocationPage()),
                    )},
                    style: TextButton.styleFrom( backgroundColor: Colors.lightGreen, foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), 
                       ),
                       ),
                    child: const Text('Map' ,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold) ),
                  ),

          Expanded(child: _buildReportContent()),
        ],
      ),
    );
  }

  Widget _buildReportContent() {
    if (selectedTab == 0) return _buildPhotosReport();
    if (selectedTab == 1) return _buildLoginLogsReport();
    return _buildFeedbackReport();
  }

  Widget _buildPhotosReport() {
        return ListView.builder(
          itemCount: photoList.length,
          itemBuilder: (context, index) {
            final photo = photoList[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Image.asset("assets/${photo.photoData!.img!}",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text("User ID: ${photo.photoData!.uid!}"),
                subtitle: Text("Taken on: ${photo.photoData!.dateTaken!}"),
              ),
            );
          },
        );
      }
    
  

  Widget _buildLoginLogsReport() {
    
        return ListView.builder(
          itemCount: logList.length,
          itemBuilder: (context, index) {
            final log = logList[index];
            return ListTile(
              leading: const Icon(Icons.login, color: Colors.green),
              title: Text(log.logData!.email!),
              subtitle: Text("Login at: ${log.logData!.logTime!}"),
            );
          },
        );
      }

  Widget _buildFeedbackReport() {
  
        return ListView.builder(
          itemCount: ratingList.length,
          itemBuilder: (context, index) {
            final fb = ratingList[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: const Icon(Icons.feedback, color: Colors.green),
                title: Text("User ID: ${fb.ratingData!.uid!}"),
                subtitle: Text("(⭐ ${fb.ratingData!.q1!}) ,(⭐ ${fb.ratingData!.q2!}), (⭐ ${fb.ratingData!.q3!}), (⭐ ${fb.ratingData!.q4!})\n Submitted on: ${fb.ratingData!.dateTaken!}"), 
              ),
            );
          },
        );
      }
}