import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'classifier.dart';
import 'package:camera/camera.dart';
import 'camera.dart';
import 'home.dart';
import 'feedback.dart';
import 'package:native_exif/native_exif.dart';
import 'settings_page.dart';
import 'Data/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Page for getting an analysis by selecting a pre-existing image
// or taking a new photo. This is using google's image picker

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int _currentIndex = 2;
  List<List<double>>? classification;
  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;
  late CameraDescription cameraDescription;
  final Classifer classifier = Classifer();

  String? imagePath;
  img.Image? image;
  final ImagePicker imagePicker = ImagePicker();

  String result = '';
  File? selectedImage;

  XFile? pickedFile;
  Exif? exif;
  DateTime? shootingDate;
  String errMsg = '';

  List<Widget>? _widgets;

  String? email = "";

  initPages() async {
    if (cameraIsAvailable) {
      // get list of available cameras
      cameraDescription = (await availableCameras()).first;
      _widgets?.add(CameraScreen(camera: cameraDescription));
    }
  }


   Future<void> _loadUserData() async{
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        email = user.email;
      });
    }
  }

  Future<void> savePhoto() async{

     await DatabaseService().addPhoto({
          'email': email,
          'img': imagePath,
          'status':  result,
          'dateTaken': DateTime.now().toIso8601String(),
        });
  }

  calculateHours(DateTime imgDate) {
    DateTime now = DateTime.now();
    Duration age = now.difference(imgDate);
    return ((age.inDays % 365) % 30);
  }

  // Preparing the image to be analyzed by turning it into bytes
  // and then into UintList8 I think, basically think of the matrices from math
  Future<void> processImage() async {

      exif = await Exif.fromPath(imagePath ?? '');
      shootingDate = await exif?.getOriginalDate();
      int age = calculateHours(shootingDate ?? DateTime.now().subtract(const Duration(days: -1)));

      if(age >= 1) {
        // Check if Image was taken over 24 hours ago

        _showCustomDialog(
          message: 'This image was taken more than 24 hours ago!',
          color: Colors.red,
          icon: Icons.error_outline,
        );
      }
      else{
      
        final imageBytes = File(imagePath!).readAsBytesSync();
        image = img.decodeImage(imageBytes);
        imageAnalysis();

        _showCustomDialog(
          message: 'Your photo has been successfully processed',
          color: Colors.green,
          icon: Icons.check_circle,
        );
      }
  }
  
  void _showCustomDialog({
    required String message,
    required Color color,
    required IconData icon,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: color, width: 2),
        ),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: color, size: 50),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> imageAnalysis() async{

    classification = await classifier.runInference(image!);
    setState(() {});
    final classifResult = classifier.postProcess(classification!);
    setState(() {
      result = classifResult;
    });
  }

  // Making everything empty for the next analysis
  void cleanResult(){
    imagePath = null;
    image = null;
    classification = null;
    setState(() {});
  }

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
  void initState() {
    super.initState();
    classifier.initModel();
    _loadUserData();
    initPages();
    cleanResult();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (cameraIsAvailable)
                TextButton.icon(
                  onPressed: () async {
                    cleanResult();
                    final result = await imagePicker.pickImage(
                      source: ImageSource.camera,
                    );
                    imagePath = result?.path;
                    setState(() {});
                    processImage();
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 24,
                  ),
                  label: const Text("Take a photo"),
                ),
              TextButton.icon(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CameraScreen(camera:cameraDescription)),
                  );
                },
                icon: const Icon(
                  Icons.camera,
                  size: 24,
                ),
                label: const Text("Scan"),
              ),
              TextButton.icon(
                onPressed: () async {
                  cleanResult();
                  final result = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );

                  imagePath = result?.path;
                  setState(() {});
                  processImage();
                },
                icon: const Icon(
                  Icons.photo,
                  size: 24,
                ),
                label: const Text("Gallery"),
              ),
            ],
          ),
          const Divider(color: Colors.black),
          Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (imagePath != null) 
                  Row(
                    children: [Image.file(File(imagePath!))]
                    ),
                  if (image == null)
                    const Text("Take a photo or choose one from the gallery to "
                        "inference."),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(),
                    // Show classification result
                      SingleChildScrollView(
                        child:
                          Column(
                            children: [
                            if (classification != null)
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.white,
                                child: Row(
                                children: [
                                Text("Detected: $result",
                                style:
                                TextStyle(
                                color: Colors.black
                                ),),
                              const Spacer(),
                                IconButton(
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        backgroundColor: Colors.white,
                                        contentPadding:
                                        const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [

                                            const SizedBox(height: 8),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child:  SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Image(image: AssetImage("assets/feedback.png")),
                                              ),
                                            ),
                                            const Text(
                                              'Your voice matters! ',
                                              style: TextStyle(fontSize: 15, color: Colors.black87),
                                              textAlign: TextAlign.center,
                                            ),
                                            const Text('help us by filling a quick survey'),

                                            const SizedBox(height: 25),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                // OK Button
                                                OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                    side: const BorderSide(color: Colors.green, width: 1),
                                                    padding: const EdgeInsets.symmetric(
                                                        vertical: 10, horizontal: 25),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context); // close popup
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => const FeedbackPage()),
                                                    );
                                                  },
                                                  child: const Text(
                                                    'OK',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),

                                                // Maybe Later Button
                                                OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                    side: const BorderSide(color: Colors.green, width: 1),
                                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context); // close popup
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => const HomePage()),
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Maybe, later.',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.normal,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                               ElevatedButton(onPressed: ()=> savePhoto(), 
                                child: Text('Save',
                                style: TextStyle(
                                color: Colors.green)),
                              ),
                                ElevatedButton(onPressed: ()=> cleanResult(), 
                                child: Text('discard',
                                style: TextStyle(
                                color: Colors.green)),
                              ),
                            ],
                            ),
                          ),
                      ])
                )],
              )
        ],)
      ),
    ]),
    bottomNavigationBar: // Bottom Navigation Bar
      Padding(
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
          )
      ),  
    );
  }

  @override
  void dispose() {
    classifier.close();
    super.dispose();
  }
}