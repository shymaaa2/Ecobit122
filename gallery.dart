import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'classifier.dart';
import 'package:camera/camera.dart';
import 'camera.dart';
import 'feedback.dart';
import 'TakeShotPage.dart';

// Page for getting an analysis by selecting a pre-existing image
// This is using google's image picker

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {

  List<List<double>>? classification;
  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;
  late CameraDescription cameraDescription;
  final Classifer classifier = Classifer();

  String? imagePath;
  img.Image? image;
  final ImagePicker imagePicker = ImagePicker();

  String result = '';
  File? selectedImage;

  List<Widget>? _widgets;

  initPages() async {
    if (cameraIsAvailable) {
      // get list of available cameras
      cameraDescription = (await availableCameras()).first;
      _widgets!.add(CameraScreen(camera: cameraDescription));
    }
  }

  // Preparing the image to be analyzed by turning it into bytes
  // and then into UintList8 I think, basically think of the matrices from math
  // I think...
  Future<void> processImage() async {
    if(imagePath != null) { //maybe remove this check??
      final imageBytes = File(imagePath!).readAsBytesSync();
      image = img.decodeImage(imageBytes);
    }
    imageAnalysis();
  }

  Future<void> imageAnalysis() async{

    classification = await classifier.runInference(image!);
    setState(() {});
    final classifResult = await classifier.postProcess(classification!);
    setState(() {
      result = classifResult;
    });
  }

  // Making everything empty for the next analysis
  // Didn't think it's necessary in other pages but
  // We might need it for the camera
  void cleanResult(){
    imagePath = null;
    image = null;
    classification = null;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    classifier.initModel();
    initPages();
  }

  @override
  void dispose() {
    classifier.close();
    super.dispose();
  }

  // Same thing with the other UI I just copied this stuff for testing
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
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
                  if (imagePath != null) Image.file(File(imagePath!)),
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
                              Text("Detected: ${result}",
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
                                                          builder: (context) => const TakeShotPage()),
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
                                )

                              ],
                            ),
                          )

                      ])
                )],
              )
        ],)
      ),
    ])
    );

  }
}
