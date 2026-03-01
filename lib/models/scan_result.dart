import 'package:cjt_scan/utils/app_colors.dart';
import 'package:flutter/material.dart';

enum AnemiaStatus { normal, mild, moderate, severe, unknown, invalid }

extension AnemiaStatusExtension on AnemiaStatus {
  Color get color {
    switch (this) {
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

  String get text {
    switch (this) {
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
}

class ScanResult {
  final String id;
  final String name; // Added to store scan name
  final AnemiaStatus status;
  final double confidence;
  final DateTime date;
  final String? imagePath;

  ScanResult({
    required this.id,
    required this.name,
    required this.status,
    required this.confidence,
    required this.date,
    this.imagePath,
  });

  /// Factory constructor to create a ScanResult from a JSON object.
  factory ScanResult.fromJson(Map<String, dynamic> json, {String? imagePath}) {
    final bool isValidEyelid = json['is_eyelid'] ?? true;
    
    if (!isValidEyelid) {
      return ScanResult(
        id: json['id']?.toString() ?? UniqueKey().toString(),
        name: json['name'] ?? 'Unnamed Scan',
        status: AnemiaStatus.invalid,
        confidence: 0.0,
        date: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
        imagePath: imagePath ?? json['image_path'],
      );
    }

    final statusString = (json['prediction'] ?? json['status'])?.toLowerCase() ?? 'unknown';
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
      id: json['id']?.toString() ?? UniqueKey().toString(),
      name: json['name'] ?? 'Unnamed Scan',
      status: status,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      date: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      imagePath: imagePath ?? json['image_path'],
    );
  }

  String get statusText => status.text;

  Color get statusColor => status.color;

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
