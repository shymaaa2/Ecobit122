import 'dart:math';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

// Weee! The hard part!

class Classifer {
  // Getting the model and labels from the assets folder
  // Make sure to let the application access the assets folder in pubspec.yaml
  static const modelPath = 'assets/model.tflite';
  static const labelsPath = 'assets/labels.txt';

  late Interpreter interpreter;
  List<String> labels = [];

  // Basically activaing the interpreter(Think of it as the CNN)
  // And it's labels(Fresh/NA/Rotten)
  // NA stands for not applicable. It's for whatever isn't a fruit
  Future<void> loadModelAndLabels() async{
    interpreter = await Interpreter.fromAsset(modelPath);
    final labelData = await rootBundle.loadString(labelsPath);
    labels = labelData.split('\n');
    print("Interpreter loaded successfully.");
  }

  Future<void> initModel() async{
    loadModelAndLabels();
  }

  void close(){
    interpreter?.close();
  }

  //Future<img.Image> loadAndResizeImage(
  //img.Image ogImage,{
    //required int height,
    //required int width,
  //}) async{
    //print('-------------Load and resize----------------');
    //return img.copyResize(ogImage, height: height, width: width);
  //}


  // Method to make a prediction. I included some pre-processing here
  // since passing the variables was giving me trouble
  Future<List<List<double>>> runInference(img.Image inputImage) async{

    inputImage = img.copyResize(inputImage, height: 224, width: 224);

    // Creating a matrix of the image
    final imageMatrix = List.generate(
      inputImage.height,
          (y) => List.generate(
            inputImage.width,
            (x) {
          final pixel = inputImage.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );

    // This means that the output classes can be 3 only, Fresh/NA/Rotten
    final output =  [List<double>.filled(1*3, 0)];

    interpreter.run([imageMatrix], output);

    // print('----------Output-----------');
    // print(output);
    return output;
  }


  //Future<List<List<double>>> runInference(List<List<List<List<double>>>> inputTensor) async{
    //final output = [List<double>.filled(2,0.0)];
    //interpreter.run(inputTensor, output);
    //print('----------Output-----------');
    //print(output);
    //return output;
  //}


  // Post processing retriving the prediction with the highest confidence
  // I kinda get how it works but don't how to explain it...
  // For some reason the confidencePercent gives a number above 100
  // I dunno if that's correct?? Can the number be like that?
  String postProcess(List<List<double>> outputTensor){
    final confidence = outputTensor[0];
    final maxConfidence = confidence.reduce(max);

    final maxIndex = confidence.indexOf(maxConfidence);

    final prediction = labels[maxIndex];
    final confidencePercent = (maxConfidence * 100).toStringAsFixed(2);
    return prediction;
  }
}

