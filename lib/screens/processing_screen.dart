
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waste_sort_ai/services/tflite_service.dart';
import 'package:waste_sort_ai/utils/app_routes.dart';
import 'package:waste_sort_ai/models/scan_result.dart';
import 'package:waste_sort_ai/utils/app_colors.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  final TfliteService _tfliteService = TfliteService();
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
      final predictionData = await _tfliteService.classifyWaste(imageFile);
      
      final result = ScanResult(
        id: UniqueKey().toString(),
        name: 'Waste Item ${DateTime.now().hour}:${DateTime.now().minute}',
        status: _mapStatus(predictionData['prediction']),
        confidence: (predictionData['confidence'] as num).toDouble(),
        date: DateTime.now(),
        imagePath: imageFile.path,
      );

      final user = supabase.auth.currentUser;
      if (user != null) {
        await supabase.from('scans').insert({
          'user_id': user.id,
          'name': result.name,
          'prediction': result.statusText,
          'confidence': result.confidence,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.results,
          arguments: result,
        );
      }
    } catch (e) {
      debugPrint('Classification Error: $e');
      _showErrorAndPop('Classification Failed: ${e.toString()}');
    }
  }

  WasteStatus _mapStatus(String prediction) {
    if (prediction == 'biodegradable') return WasteStatus.biodegradable;
    if (prediction == 'non-biodegradable') return WasteStatus.nonBiodegradable;
    return WasteStatus.unknown;
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 32),
            const Text(
              'Classifying waste...',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Our AI is analyzing the material type for proper sorting.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
