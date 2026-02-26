
import 'package:cjt_scan/models/scan_result.dart';
import 'package:cjt_scan/theme/app_theme.dart';
import 'package:cjt_scan/utils/app_routes.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = ModalRoute.of(context)!.settings.arguments as ScanResult?;

    if (result == null) {
      // Handle error case where result is null
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No result data found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Screening Result')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 8,
              shadowColor: result.statusColor.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: result.statusColor,
                        borderRadius: BorderRadius.circular(kAppCornerRadius),
                      ),
                      child: Text(
                        result.statusText,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '${result.confidence.toStringAsFixed(1)}% Confidence',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        result.recommendation,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.capture,
                    (route) => false,
                  );
                },
                child: const Text('Scan Again'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                   Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.capture,
                    (route) => false,
                  );
                  Navigator.of(context).pushNamed(AppRoutes.history);
                },
                child: const Text('View History'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
