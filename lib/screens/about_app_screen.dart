
import 'package:cjt_scan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7E57C2), Color(0xFF9575CD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7E57C2).withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'About App & Author',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAppSection(context),
            const Divider(height: 1),
            _buildAuthorSection(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF7E57C2).withValues(alpha: 0.2), width: 2),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('asset/images/img_2.png'),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'What is cjt_scan AI?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'cjt_scan AI is a specialized medical screening tool designed to detect potential signs of anemia through non-invasive analysis of the palpebral conjunctiva (lower eyelid).',
            style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black54),
          ),
          const SizedBox(height: 32),
          _buildFeatureRow(Icons.psychology_outlined, 'AI Precision', 'State-of-the-art computer vision analyzes pallor markers in seconds.'),
          _buildFeatureRow(Icons.speed_rounded, 'Instant Analysis', 'Receive screening feedback instantly without invasive blood draws.'),
          _buildFeatureRow(Icons.security_rounded, 'Secure Data', 'Your health records are encrypted and stored with maximum privacy.'),
          const SizedBox(height: 24),
          _buildDisclaimerCard(),
        ],
      ),
    );
  }

  Widget _buildAuthorSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      color: Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meet the Developer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'asset/images/pp.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kyeremeh Clifford',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Data Scientist & Software Engineer',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'I am a Data Scientist who completed my BSc in Information Technology at the University of Energy and Natural Resources in Ghana, Bono Region - Fiapre. '
            'I completed Mmeredane Estate JHS, and Twene Amanfo Secondary and Technical School.',
            style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black54),
          ),
          const SizedBox(height: 32),
          const Text(
            'Connect with me:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: [
              _buildSocialChip(
                icon: Icons.code_rounded,
                label: 'GitHub',
                onTap: () => _launchURL('https://github.com/Vhybz'),
              ),
              _buildSocialChip(
                icon: Icons.link_rounded,
                label: 'LinkedIn',
                onTap: () => _launchURL('https://www.linkedin.com/in/kyeremeh-clifford-9690082b3'),
              ),
              _buildSocialChip(
                icon: Icons.facebook_rounded,
                label: 'Facebook',
                onTap: () => _launchURL('https://www.facebook.com/share/1BxNYqWNiy/'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(desc, style: const TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialChip({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return Container(
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
              'Important: This app is a screening tool and NOT a medical diagnosis. Always consult a healthcare provider.',
              style: TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
