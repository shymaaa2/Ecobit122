import 'package:eco/Data/Database.dart';
import 'package:eco/report_validators.dart';
import 'package:flutter/material.dart';
import 'Data/photo.dart';
import 'Data/log.dart';
import 'Data/rating.dart';
import 'admin_addLocation.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;
import 'dart:io';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({Key? key}) : super(key: key);

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  List<Photo> photoList = [];
  List<Log> logList = [];
  List<Rating> ratingList = [];

  void saveAsExcel() async{
    // Creating an instance of a workbook and sheet
    final xcel.Workbook workbook = xcel.Workbook(3);
    final xcel.Worksheet photoSheet = workbook.worksheets[0];
    final xcel.Worksheet logSheet = workbook.worksheets[1];
    final xcel.Worksheet ratingSheet = workbook.worksheets[2];
    //final xcel.Worksheet locationSheet = workbook.worksheets[3]; in case it's needed

    photoSheet.name = 'Photos';
    logSheet.name = 'Logs';
    ratingSheet.name = 'Ratings';

    // Headings for Photo Sheet
    photoSheet.getRangeByIndex(1, 1).setText("Email");
    photoSheet.getRangeByIndex(1, 2).setText("Status");
    photoSheet.getRangeByIndex(1, 3).setText("Date Taken");

    // Headings for Log Sheet
    logSheet.getRangeByIndex(1, 1).setText("Email");
    logSheet.getRangeByIndex(1, 2).setText("Login at");

    // Headings for Rating Sheet
    ratingSheet.getRangeByIndex(1, 1).setText("Email");
    ratingSheet.getRangeByIndex(1, 2).setText("Date Submitted");
    ratingSheet.getRangeByIndex(1, 3).setText("Accuracy");
    ratingSheet.getRangeByIndex(1, 4).setText("Usability");
    ratingSheet.getRangeByIndex(1, 5).setText("Reccomendation");
    ratingSheet.getRangeByIndex(1, 6).setText("Clarity");


    for (var i = 0; i < photoList.length; i++) {
     final item = photoList[i];
     photoSheet.getRangeByIndex(i + 2, 1).setText(item.photoData!.email!.toString());
     photoSheet.getRangeByIndex(i + 2, 2).setText(item.photoData!.status!.toString());
     photoSheet.getRangeByIndex(i + 2, 3).setText(item.photoData!.dateTaken!.toString());
    }

    for (var i = 0; i < logList.length; i++) {
     final item = logList[i];
     logSheet.getRangeByIndex(i + 2, 1).setText(item.logData!.email!.toString());
     logSheet.getRangeByIndex(i + 2, 2).setText(item.logData!.logTime!.toString());
    }

    for (var i = 0; i < ratingList.length; i++) {
     final item = ratingList[i];
     ratingSheet.getRangeByIndex(i + 2, 1).setText(item.ratingData!.email!.toString());
     ratingSheet.getRangeByIndex(i + 2, 2).setText(item.ratingData!.dateTaken!.toString());
     ratingSheet.getRangeByIndex(i + 2, 3).setText(item.ratingData!.q1!.toString());
     ratingSheet.getRangeByIndex(i + 2, 4).setText(item.ratingData!.q2!.toString());
     ratingSheet.getRangeByIndex(i + 2, 5).setText(item.ratingData!.q3!.toString());
     ratingSheet.getRangeByIndex(i + 2, 6).setText(item.ratingData!.q4!.toString());
    }

    final List<int> bytes = workbook.saveAsStream();
  

    // Save and launch the file.
    await File('/storage/emulated/0/Download/Data.xlsx').writeAsBytes(bytes);

    workbook.dispose();

    ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Data Saved Sucessfully."),
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 3),
          ),
        );
  }

  @override
  void initState() {
    super.initState();

    DatabaseService.getUserPhotos((photos) {
      setState(() => photoList = photos);
    });

    DatabaseService.getLogs((logs) {
      setState(() => logList = logs);
    });

    DatabaseService.getRatings((ratings) {
      setState(() => ratingList = ratings);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Data" , style: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 28,
          fontWeight: FontWeight.bold,
        )),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.black,
        elevation: 0,

      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 40,
          crossAxisSpacing: 25,
          childAspectRatio: 1,
          children: [

            DashboardBox(
              label: "User Logs",
              count: logList.length.toString(),
              imageUrl: 'https://cdn-icons-png.flaticon.com/512/987/987473.png',
              onTap: () {
                _openLogs(context);
              },
            ),

            DashboardBox(
              label: "Photos Taken",
              count: photoList.length.toString(),
              imageUrl: 'https://i.pinimg.com/564x/0c/d9/7e/0cd97ef433ff3b2bf7708e0aec62e169.jpg',
              onTap: () {
                _openPhotos(context);
              },
            ),

            DashboardBox(
              label: "Feedback",
              count: ratingList.length.toString(),
              imageUrl: 'https://media.istockphoto.com/id/946716862/vector/vector-illustration-icon-emoticon-flat-design-concept-feedback-service-customer-experience.jpg?s=612x612&w=0&k=20&c=CqBRWHqg0AdHbgLgwAvzolYNsOLeLsFHpx_MeouBiOg=',
              onTap: () {
                _openFeedback(context);
              },
            ),

            DashboardBox(
              label: "Location",
              count: "1",
              imageUrl: 'https://cdn-icons-png.flaticon.com/512/1865/1865269.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminAddLocationPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Navigation Functions
  void _openPhotos(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PhotosReportPage(photoList: photoList)),
    );
  }

  void _openLogs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LogsReportPage(logList: logList)),
    );
  }

  void _openFeedback(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FeedbackReportPage(ratingList: ratingList)),
    );
  }
}
class DashboardBox extends StatelessWidget {
  final String label;
  final String count;
  final String imageUrl;
  final VoidCallback onTap;

  const DashboardBox({
    super.key,
    required this.label,
    required this.count,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 3),
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl, height: 60),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              count,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class PhotosReportPage extends StatelessWidget {
  final List<Photo> photoList;
  const PhotosReportPage({super.key, required this.photoList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Photos Taken")),
      body: ListView.builder(
        itemCount: photoList.length,
        itemBuilder: (context, index) {
          final p = photoList[index];
          return ListTile(
            leading: Image.asset("assets/${p.photoData!.img!}", width: 60),
            title: Text("Email: ${p.photoData!.email!}"),
            subtitle: Text("Date: ${p.photoData!.dateTaken!}"),
          );
        },
      ),
    );
  }
}

class LogsReportPage extends StatelessWidget {
  final List<Log> logList;
  const LogsReportPage({super.key, required this.logList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Login Logs")),
      body: ListView.builder(
        itemCount: logList.length,
        itemBuilder: (context, index) {
          final log = logList[index];
          return ListTile(
            leading: const Icon(Icons.login, color: Colors.green),
            title: Text(log.logData!.email!),
            subtitle: Text("Login at: ${log.logData!.logTime!}"),
          );
        },
      ),
    );
  }
}

class FeedbackReportPage extends StatelessWidget {
  final List<Rating> ratingList;
  const FeedbackReportPage({super.key, required this.ratingList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feedback")),
      body: ListView.builder(
        itemCount: ratingList.length,
        itemBuilder: (context, index) {
          final r = ratingList[index];
          return ListTile(
            leading: const Icon(Icons.feedback, color: Colors.green),
            title: Text("User ID: ${r.ratingData!.email!}"),
            subtitle: Text(
                "Accuracy: ${r.ratingData!.q1!}, Usability: ${r.ratingData!.q2!}, Reccomendation: ${r.ratingData!.q3!}, Clarity: ${r.ratingData!.q4!} \n Submitted on: ${r.ratingData!.dateTaken!}"),
          );
        },
      ),
    );



  }
}
