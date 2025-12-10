import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'classifier.dart';
import 'image_utils.dart';

//live camera

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  State<StatefulWidget> createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {

  late CameraController cameraController;
  late Classifer classifier = Classifer();
  List<List<double>>? classification;

  String errMsg = '';

  // This for process that take time, the check is for the loading circle
  // to appear and also to prevent the ml algorithm from making an inference
  // while it is in progress of making an inference
  bool _isProcessing = false;

  String result = '';

  DateTime lastShot = DateTime.now();

  // Initiliaization of camera, as in activating the camera
  // mounted I think check if the camera exists at this time
  // Resolution preset affects the quality of the camera so if
  // you try the camera asnd everythings looks bad that's why
  Future<void> initCamera() async{
    cameraController = CameraController(widget.camera, ResolutionPreset.medium);

    await cameraController.initialize().then((value) {
      cameraController.startImageStream((image)
      {
        if(DateTime.now().difference(lastShot).inSeconds > 1){
          imageAnalysis(image);
        }
      });
      if (mounted) {
        setState(() {});
      }
    }).catchError((Object e) {
      if( e is CameraException){
        switch(e.code){
          case 'CameraAccessDenied':
            errMsg = 'Please Allow Camera Access';
            break;
          default:
            errMsg = 'An Error Occured';
            break;
        }
      }
    });
  }

  Future<void> imageAnalysis(CameraImage cameraImage) async {
    // if image is still analyze, skip this frame
    if (_isProcessing) {
      return;
    }

    _isProcessing = true;

    // Converting the image and then making a prediction
    // The classifier will return the result as type <List<List<double>>?
    // question mark is part of the typing btw
    final convertedImage = ImageUtils.convertCameraImage(cameraImage);
    classification = await classifier.runInference(convertedImage!);

    // Processing the result into a string so we can display in the ui
    final classifResult = classifier.postProcess(classification!);

    setState(() {
      result = classifResult;
      _isProcessing = false;
      lastShot = DateTime.now();
    });
    
  
  }

  @override
  void initState() {
    super.initState();
    initCamera();
    classifier.initModel();
  }
  // I copied the UI becuase I just wanted to display the results
  // so we will have to get it changed. This applies to all the pages I worked on
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      ),
      body: (cameraController.value.isInitialized)
          ? Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: CameraPreview(cameraController),
                ),
                if (classification != null)
                Text(
                  "Detected: $result",
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.green,
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
 }

   @override
  void dispose() {
    cameraController.dispose();
    classifier.close();
    super.dispose();
  }
}