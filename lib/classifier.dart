import 'dart:math';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';


class Classifer {
  // Getting the model and labels from the assets folder
  // Make sure to let the application access the assets folder in pubspec.yaml
  static const modelPath = 'assets/model.tflite';
  static const labelsPath = 'assets/labels.txt';

  late Interpreter interpreter;
  List<String> labels = [];

  // Basically activaing the interpreter(Think of it as the CNN)
  // And it's labels(Edible/NA/Inedible)
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
    interpreter.close();
  }

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

  // Post processing retriving the prediction with the highest confidence
  String postProcess(List<List<double>> outputTensor){
    final confidence = outputTensor[0];
    final maxConfidence = confidence.reduce(max);

    final maxIndex = confidence.indexOf(maxConfidence);

    final prediction = labels[maxIndex];
    return prediction;
  }
}