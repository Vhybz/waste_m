
import 'package:cjt_scan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('About cjt_scan AI', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                child: const Icon(Icons.info_outline_rounded, size: 50, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'What is cjt_scan AI?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            const Text(
              'cjt_scan AI is a cutting-edge medical screening tool designed to detect potential signs of anemia through non-invasive analysis of the palpebral conjunctiva (the inner lining of the lower eyelid).',
              style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            _buildFeatureSection(
              title: 'How it Works',
              description: 'Using advanced Artificial Intelligence and Computer Vision, the app analyzes the pallor (paleness) of the conjunctiva. A paler lining often correlates with lower hemoglobin levels, a key indicator of anemia.',
              icon: Icons.psychology_outlined,
            ),
            const SizedBox(height: 16),
            _buildFeatureSection(
              title: 'Quick & Non-Invasive',
              description: 'No needles or blood draws required. Simply capture or upload a clear image of your lower eyelid to receive an instant preliminary assessment.',
              icon: Icons.flash_on_outlined,
            ),
            const SizedBox(height: 16),
            _buildFeatureSection(
              title: 'Monitor Trends',
              description: 'Save your results securely to track your health insights over time and visualize trends through our built-in analytics dashboard.',
              icon: Icons.bar_chart_rounded,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.withValues(alpha: 0.1)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Important: This app is a screening tool and NOT a substitute for professional medical diagnosis. Always consult a healthcare provider.',
                      style: TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSection({required String title, required String description, required IconData icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
