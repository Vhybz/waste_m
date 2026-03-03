
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:waste_sort_ai/models/scan_result.dart';

class ApiService {
  static const String _apiUrl = 'https://ctj-scan-api.onrender.com/predict';

  Future<ScanResult> scanImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'image_base64': base64Image}),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
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
