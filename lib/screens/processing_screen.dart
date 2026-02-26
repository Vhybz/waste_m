
import 'dart:async';
import 'dart:math';
import 'package:cjt_scan/data/mock_data.dart';
import 'package:cjt_scan/models/scan_result.dart';
import 'package:cjt_scan/utils/app_routes.dart';
import 'package:flutter/material.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate AI processing
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        // Create a mock result
        final random = Random();
        final status = AnemiaStatus.values[random.nextInt(AnemiaStatus.values.length)];
        final confidence = 85.0 + random.nextDouble() * 14.0;

        // Add to mock history
        mockHistory.insert(0, ScanResult(status: status, confidence: confidence));

        Navigator.of(context).pushReplacementNamed(
          AppRoutes.results,
          arguments: mockHistory.first,
        );
      }
    });
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
          ],
        ),
      ),
    );
  }
}
