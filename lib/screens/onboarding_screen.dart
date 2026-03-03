
import 'package:waste_sort_ai/utils/app_colors.dart';
import 'package:waste_sort_ai/utils/app_routes.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) => setState(() => _currentPage = value),
                children: const [
                  _OnboardingPage(
                    imageAsset: 'asset/images/b.jpg', // Updated image
                    title: 'Welcome to WasteSort AI',
                    subtitle: 'Your personal AI-powered tool for smart waste classification. Help protect the planet using just your smartphone camera.',
                  ),
                  _OnboardingPage(
                    imageAsset: 'asset/images/c.jpg', // Updated image
                    title: 'Instant Waste Analysis',
                    subtitle: 'Capture a clear image of any waste item to instantly identify if it is biodegradable, non-biodegradable, or recyclable.',
                  ),
                  _OnboardingPage(
                    imageAsset: 'asset/images/d.jpg', // Updated image
                    title: 'Track Your Impact',
                    subtitle: 'Monitor your sorting habits over time with our analytics dashboard. Stay informed and observe your contribution to a cleaner environment.',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              child: Column(
                children: [
                  _buildPageIndicator(),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage < 2)
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                          },
                          child: const Text('Skip', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                        )
                      else
                        const SizedBox(width: 60),

                      FilledButton(
                        onPressed: () {
                          if (_currentPage == 2) {
                            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(_currentPage == 2 ? 'Get Started' : 'Next', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? AppColors.primary : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subtitle;

  const _OnboardingPage({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF1F8E9),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(imageAsset, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 60),
          Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: -0.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, height: 1.6, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
