
import 'package:cjt_scan/utils/app_colors.dart';
import 'package:flutter/material.dart';

enum AnemiaStatus { normal, mild, moderate, severe, unknown, invalid }

class ScanResult {
  final String id;
  final AnemiaStatus status;
  final double confidence;
  final DateTime date;

  ScanResult({
    required this.status,
    required this.confidence,
  })  : id = UniqueKey().toString(),
        date = DateTime.now();

  /// Factory constructor to create a ScanResult from a JSON object.
  factory ScanResult.fromJson(Map<String, dynamic> json) {
    // Check for explicit eyelid validation if provided by API
    final bool isValidEyelid = json['is_eyelid'] ?? true;
    
    if (!isValidEyelid) {
      return ScanResult(status: AnemiaStatus.invalid, confidence: 0.0);
    }

    // Map the string status from the API to the AnemiaStatus enum
    final statusString = json['prediction']?.toLowerCase() ?? 'unknown';
    AnemiaStatus status;
    switch (statusString) {
      case 'normal':
        status = AnemiaStatus.normal;
        break;
      case 'mild':
        status = AnemiaStatus.mild;
        break;
      case 'moderate':
        status = AnemiaStatus.moderate;
        break;
      case 'severe':
        status = AnemiaStatus.severe;
        break;
      case 'invalid':
        status = AnemiaStatus.invalid;
        break;
      default:
        status = AnemiaStatus.unknown;
    }

    return ScanResult(
      status: status,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String get statusText {
    switch (status) {
      case AnemiaStatus.normal:
        return 'Normal';
      case AnemiaStatus.mild:
        return 'Mild Anemia';
      case AnemiaStatus.moderate:
        return 'Moderate Anemia';
      case AnemiaStatus.severe:
        return 'Severe Anemia';
      case AnemiaStatus.unknown:
        return 'Unknown';
      case AnemiaStatus.invalid:
        return 'Invalid Image';
    }
  }

  Color get statusColor {
    switch (status) {
      case AnemiaStatus.normal:
        return AppColors.normal;
      case AnemiaStatus.mild:
        return AppColors.mild;
      case AnemiaStatus.moderate:
        return AppColors.moderate;
      case AnemiaStatus.severe:
        return AppColors.severe;
      case AnemiaStatus.unknown:
      case AnemiaStatus.invalid:
        return Colors.grey.shade300;
    }
  }

  String get recommendation {
    switch (status) {
      case AnemiaStatus.normal:
        return 'No signs of anemia detected. Maintain a healthy diet. This is not a medical diagnosis.';
      case AnemiaStatus.mild:
        return 'Potential signs of mild anemia detected. Consider consulting a healthcare professional for further evaluation.';
      case AnemiaStatus.moderate:
        return 'Signs of moderate anemia detected. It is highly recommended to consult a healthcare professional.';
      case AnemiaStatus.severe:
        return 'Strong indicators of severe anemia detected. Please seek immediate medical attention.';
      case AnemiaStatus.unknown:
        return 'The result could not be determined. Please try scanning again in a well-lit environment.';
      case AnemiaStatus.invalid:
        return 'The captured image does not appear to be an eyelid. Please import or capture a clear image of the lower eyelid (conjunctiva) for accurate screening.';
    }
  }
}
