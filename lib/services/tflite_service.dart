
import 'dart:io';
import 'package:flutter/foundation.dart'; 
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TfliteService {
  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  Future<void> loadModel() async {
    if (kIsWeb) return;
    try {
      _interpreter = await Interpreter.fromAsset('asset/model/mnist_model.tflite');
      _isModelLoaded = true;
      debugPrint('TFLite: Model loaded successfully');
    } catch (e) {
      debugPrint('TFLite: Error loading model: $e');
    }
  }

  Future<Map<String, dynamic>> classifyWaste(File imageFile) async {
    if (kIsWeb) return {'prediction': 'not_supported_on_web', 'confidence': 0.0};
    if (!_isModelLoaded) await loadModel();
    if (_interpreter == null) return {'prediction': 'error', 'confidence': 0.0};

    try {
      final imageBytes = await imageFile.readAsBytes();
      final decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) throw Exception("Failed to decode image");

      final resizedImage = img.copyResize(decodedImage, width: 224, height: 224);
      var input = _imageToByteListFloat32(resizedImage, 224, 127.5, 127.5);
      var output = List.filled(1 * 2, 0.0).reshape([1, 2]);

      _interpreter!.run(input, output);

      final List<double> results = List<double>.from(output[0]);
      
      if (results[0] > results[1]) {
        return {'prediction': 'biodegradable', 'confidence': results[0] * 100};
      } else {
        return {'prediction': 'non-biodegradable', 'confidence': results[1] * 100};
      }
    } catch (e) {
      debugPrint('TFLite: Inference Error: $e');
      return {'prediction': 'error', 'confidence': 0.0};
    }
  }

  Uint8List _imageToByteListFloat32(img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (pixel.r - mean) / std;
        buffer[pixelIndex++] = (pixel.g - mean) / std;
        buffer[pixelIndex++] = (pixel.b - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  void dispose() {
    _interpreter?.close();
  }
}
