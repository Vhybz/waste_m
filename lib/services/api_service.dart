
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cjt_scan/models/scan_result.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Updated with the live Render API URL and /predict endpoint
  static const String _apiUrl = 'https://ctj-scan-api.onrender.com/predict';

  Future<ScanResult> scanImage(File imageFile) async {
    try {
      // 1. Convert image to Base64
      final bytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(bytes);

      // 2. Send POST request to the Render API
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'image_base64': base64Image}),
      ).timeout(const Duration(seconds: 60)); // Render free tier can be slow to wake up

      // 3. Parse the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Returns a ScanResult mapped from the API's prediction and confidence
        return ScanResult.fromJson(data);
      } else {
        throw Exception('Server error (${response.statusCode}). Please try again later.');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('The request timed out. The server might be taking time to wake up.');
    } catch (e) {
      throw Exception('Prediction failed: ${e.toString()}');
    }
  }
}
