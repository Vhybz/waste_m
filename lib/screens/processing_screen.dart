
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cjt_scan/services/api_service.dart';
import 'package:cjt_scan/utils/app_routes.dart';
import 'package:cjt_scan/models/scan_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  final ApiService _apiService = ApiService();
  final supabase = Supabase.instance.client;
  bool _isAnalyzing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isAnalyzing) {
      final imageFile = ModalRoute.of(context)!.settings.arguments as File?;
      if (imageFile != null) {
        _isAnalyzing = true;
        _analyzeAndSave(imageFile);
      } else {
        _showErrorAndPop('No image provided for analysis.');
      }
    }
  }

  Future<void> _analyzeAndSave(File imageFile) async {
    try {
      // 1. Get Prediction from API
      final result = await _apiService.scanImage(imageFile);

      // 2. Save to Supabase 'scans' table
      final user = supabase.auth.currentUser;
      if (user != null) {
        await supabase.from('scans').insert({
          'user_id': user.id,
          'name': 'Scan ${DateTime.now().hour}:${DateTime.now().minute}', // Default name
          'prediction': result.status.text,
          'confidence': result.confidence,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      // 3. Navigate to Results
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.results,
          arguments: result,
        );
      }
    } catch (e) {
      _showErrorAndPop('Analysis Failed: ${e.toString()}');
    }
  }

  void _showErrorAndPop(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            Text(
              'Analyzing conjunctiva...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Saving to your secure health record',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
