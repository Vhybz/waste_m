
import 'package:waste_sort_ai/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

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
      appBar: AppBar(
        title: const Text('Meet the Developer', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Professional Profile'),
                  const Text(
                    'I am a Data Scientist & Software Engineer dedicated to creating innovative health-tech and environmental solutions. My expertise lies in Flutter development, machine learning integration, and secure cloud architecture.',
                    style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.6, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Educational Journey'),
                  _buildEducationTile(
                    'BSc. Information Technology',
                    'University of Energy and Natural Resources (UENR), Fiapre',
                    Icons.school_rounded,
                  ),
                  _buildEducationTile(
                    'Secondary & Technical Education',
                    'Twene Amanfo Secondary and Technical School',
                    Icons.account_balance_rounded,
                  ),
                  _buildEducationTile(
                    'Junior High Education',
                    'Mmeredane Estate JHS',
                    Icons.history_edu_rounded,
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Core Expertise'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTechChip('Data Science'),
                      _buildTechChip('Flutter'),
                      _buildTechChip('Supabase'),
                      _buildTechChip('Machine Learning'),
                      _buildTechChip('FastAPI'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildSectionTitle('Connect with me'),
                  const SizedBox(height: 16),
                  _buildSocialGrid(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'asset/images/pp.jpg',
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 110,
                  height: 110,
                  color: Colors.white,
                  child: const Icon(Icons.person_rounded, size: 50, color: AppColors.primary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Kyeremeh Clifford',
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
          const SizedBox(height: 4),
          Text(
            'Data Scientist & Software Engineer',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildEducationTile(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.grey.shade50,
      side: BorderSide(color: Colors.grey.shade200),
      labelStyle: const TextStyle(color: AppColors.primary),
    );
  }

  Widget _buildSocialGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.start,
      children: [
        _buildSocialButton(
          icon: Icons.code_rounded,
          label: 'GitHub',
          onTap: () => _launchURL('https://github.com/Vhybz'),
        ),
        _buildSocialButton(
          icon: Icons.link_rounded,
          label: 'LinkedIn',
          onTap: () => _launchURL('https://www.linkedin.com/in/kyeremeh-clifford-9690082b3'),
        ),
        _buildSocialButton(
          icon: Icons.facebook_rounded,
          label: 'Facebook',
          onTap: () => _launchURL('https://www.facebook.com/share/1BxNYqWNiy/'),
        ),
      ],
    );
  }

  Widget _buildSocialButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
