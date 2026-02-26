
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cjt_scan/models/scan_result.dart';

class ApiService {
  // --- CONFIGURABLE API URL ---
  // Updated with the new ngrok URL
  static const String _apiUrl = 'https://colitic-amya-irrefutably.ngrok-free.dev/scan';

  /// Takes an image file, converts it to Base64, and sends it to the API.
  /// Returns a [ScanResult] with the prediction and confidence.
  Future<ScanResult> scanImage(File imageFile) async {
    try {
      // 1. Convert image to Base64
      final bytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(bytes);

      // 2. Send POST request
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          // Ngrok free tier sometimes requires a specific browser-agent header to avoid interstitial pages.
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'
        },
        body: jsonEncode({'image_base64': base64Image}),
      ).timeout(const Duration(seconds: 30));

      // 3. Parse the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ScanResult.fromJson(data);
      } else {
        // Handle non-200 responses, including the interstitial page from ngrok
        if (response.body.contains("ngrok-error-code")) {
           throw Exception('Failed to connect to ngrok. Please ensure the tunnel is active and the URL is correct.');
        }
        throw Exception('Failed to get prediction. Status code: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet connection or server not reachable.');
    } on TimeoutException {
      throw Exception('The request timed out. Please try again.');
    } catch (e) {
      // Re-throw other exceptions to be caught by the UI
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
