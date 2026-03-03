
import 'dart:io';
import 'dart:ui';
import 'package:waste_sort_ai/utils/app_routes.dart';
import 'package:waste_sort_ai/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleImageAction(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        Navigator.of(context).pushNamed(AppRoutes.processing, arguments: File(image.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selection failed: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Waste Classification', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: _CameraBackground()),
          _SquareScanningGuide(pulseController: _pulseController),
          const Positioned(top: 120, left: 0, right: 0, child: _ScanningHints()),
          Align(
            alignment: Alignment.bottomCenter,
            child: _BeautifiedControlPanel(
              onCameraTap: () => _handleImageAction(ImageSource.camera),
              onGalleryTap: () => _handleImageAction(ImageSource.gallery),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraBackground extends StatelessWidget {
  const _CameraBackground();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: Center(
        child: Icon(Icons.qr_code_scanner_rounded, size: 80, color: Colors.white.withValues(alpha: 0.05)),
      ),
    );
  }
}

class _SquareScanningGuide extends StatelessWidget {
  final AnimationController pulseController;
  const _SquareScanningGuide({required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: pulseController,
        builder: (context, child) {
          double size = 260 + (15 * pulseController.value);
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primaryLight.withValues(alpha: 0.3 + (0.4 * pulseController.value)),
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2 * pulseController.value),
                      blurRadius: 30,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Icon(Icons.add_rounded, color: Colors.white.withValues(alpha: 0.2), size: 40),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ScanningHints extends StatelessWidget {
  const _ScanningHints();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 16),
            SizedBox(width: 8),
            Text('AI Ready: Align item in center', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _BeautifiedControlPanel extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  const _BeautifiedControlPanel({required this.onCameraTap, required this.onGalleryTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 48),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -5))
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 24),
              const Text('Classify Waste', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
              const SizedBox(height: 12),
              const Text(
                'Place the item within the frame. Ensure good lighting for the most accurate classification.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, height: 1.5, fontSize: 15),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  _PanelButton(
                    onTap: onGalleryTap,
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    isPrimary: false,
                  ),
                  const SizedBox(width: 16),
                  _PanelButton(
                    onTap: onCameraTap,
                    icon: Icons.camera_alt_rounded,
                    label: 'Classify',
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanelButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final bool isPrimary;

  const _PanelButton({required this.onTap, required this.icon, required this.label, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.primary : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isPrimary ? [
              BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))
            ] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isPrimary ? Colors.white : Colors.black87, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
