import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'classifier.dart';
import 'image_utils.dart';

// Page for getting an analysis by snapping one image
// It is different from the live camera, see live camera

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
    cameraController = CameraController(widget.camera, ResolutionPreset.medium,
        imageFormatGroup: Platform.isIOS ?
        ImageFormatGroup.bgra8888 :
        ImageFormatGroup.yuv420);

    cameraController.initialize().then((value) {
      cameraController.startImageStream(imageAnalysis);
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

    setState(() {});
    // Processing the result into a string so we can display in the ui
    final classifResult = classifier.postProcess(classification!);

    setState(() {
      result = classifResult;
    });
    _isProcessing = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initCamera();
    classifier.initModel();
  }

  @override
  void dispose() {
    cameraController.dispose();
    classifier.close();
    super.dispose();
  }

  Widget cameraWidget(context) {
    // This was also copied. Just some scaling code.
    // I didn't write it's comments
    var camera = cameraController.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(cameraController),
      ),
    );
  }

  // I copied the UI becuase I just wanted to display the results
  // so we will have to get it changed. This applies to all the pages I worked on
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    List<Widget> list = [];

    list.add(
      SizedBox(
        // This checks if the camera is has been activated
        height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
        // This checks if the camera is has been activated
        child: (!cameraController.value.isInitialized)
            ? Column(
          children: [
            const Center(child: CircularProgressIndicator())
          ],
          )
            : cameraWidget(context),
      ),
    );
    list.add(
        Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // If the classifier returns a result then display
            if (classification != null)
          Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Row(
          children: [
          Text("Detected: $result",
            style:
            TextStyle(
              fontSize: 18,
                color: Colors.black
            ),),
          const Spacer(),
          ],
        ),
      ),
    ])
    )
    ));
    return SafeArea(
      child: Stack(
        children: list,
      ),
    );
  }
}