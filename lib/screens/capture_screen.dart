
import 'dart:io';
import 'package:cjt_scan/models/scan_result.dart';
import 'package:cjt_scan/services/api_service.dart';
import 'package:cjt_scan/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();

  File? _imageFile;
  ScanResult? _scanResult;
  bool _isLoading = false;

  /// Initiates the image capture process and calls the API.
  Future<void> _captureAndScan() async {
    try {
      // 1. Capture image
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          _isLoading = true;
          _scanResult = null; // Clear previous results
        });

        // 2. Send to API
        final result = await _apiService.scanImage(_imageFile!);

        setState(() {
          _scanResult = result;
          _isLoading = false;
        });

      } else {
        // User canceled the capture
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image capture was canceled.')),
          );
        }
      }
    } catch (e) {
      // 3. Handle errors
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  /// Resets the screen to its initial state to allow for a new scan.
  void _reset() {
    setState(() {
      _imageFile = null;
      _scanResult = null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ready to Scan'),
        leading: _buildPopupMenu(),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (_imageFile == null)
            _CameraPlaceholder(
              onCapture: _captureAndScan,
            )
          else
            // Show the captured image as a preview
            Image.file(
              _imageFile!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

          if (_scanResult != null)
            _ResultCard(result: _scanResult!, onScanAgain: _reset),

          if (_isLoading)
            const _LoadingOverlay(),
        ],
      ),
    );
  }
  
  PopupMenuButton _buildPopupMenu() {
    return PopupMenuButton(
          icon: const Icon(Icons.menu),
          onSelected: (selection) {
            switch (selection) {
              case 'disclaimer':
                Navigator.of(context).pushNamed(AppRoutes.disclaimer);
                break;
              case 'history':
                Navigator.of(context).pushNamed(AppRoutes.history);
                break;
              case 'logout':
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(
              value: 'disclaimer',
              child: Text('View Disclaimer'),
            ),
            const PopupMenuItem(
              value: 'history',
              child: Text('View History'),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Text('Logout'),
            ),
          ],
        );
  }
}

// --- WIDGETS --- //

/// A placeholder UI shown before an image is captured.
class _CameraPlaceholder extends StatelessWidget {
  final VoidCallback onCapture;
  const _CameraPlaceholder({required this.onCapture});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.black87,
          child: const Center(
            child: Icon(Icons.camera_alt, color: Colors.white24, size: 64),
          ),
        ),
        // Scan Guide Overlay
        Container(
          width: screenSize.width * 0.8,
          height: screenSize.width * 0.8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.7), width: 3),
          ),
        ),

        Positioned(
          bottom: 0,
          child: _BottomPanel(onCapture: onCapture),
        ),
      ],
    );
  }
}

/// The curved bottom panel with instructions and the capture button.
class _BottomPanel extends StatelessWidget {
  final VoidCallback onCapture;
  const _BottomPanel({required this.onCapture});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: screenSize.width,
          height: screenSize.height * 0.25,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Position your lower eyelid inside the circle',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        // Capture Button
        Transform.translate(
          offset: const Offset(0, -35),
          child: SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              onPressed: onCapture,
              child: const Icon(Icons.camera_alt, size: 35),
            ),
          ),
        ),
      ],
    );
  }
}

/// A semi-transparent overlay with a loading indicator.
class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 24),
            Text(
              'Analyzing...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A card that displays the scan result and recommendation.
class _ResultCard extends StatelessWidget {
  final ScanResult result;
  final VoidCallback onScanAgain;

  const _ResultCard({required this.result, required this.onScanAgain});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24.0),
      child: Card(
        elevation: 8,
        shadowColor: result.statusColor.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: result.statusColor,
                  borderRadius: BorderRadius.circular(28.0),
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
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: onScanAgain,
                  child: const Text('Scan Again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
