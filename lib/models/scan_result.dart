
import 'package:flutter/material.dart';

enum WasteStatus { biodegradable, nonBiodegradable, recyclable, unknown, invalid }

extension WasteStatusExtension on WasteStatus {
  Color get color {
    switch (this) {
      case WasteStatus.biodegradable:
        return Colors.green.shade600; // Earthy green
      case WasteStatus.nonBiodegradable:
        return Colors.red.shade600; // Alert red
      case WasteStatus.recyclable:
        return Colors.blue.shade600; // Industrial blue
      case WasteStatus.unknown:
      case WasteStatus.invalid:
        return Colors.grey.shade400;
    }
  }

  String get text {
    switch (this) {
      case WasteStatus.biodegradable:
        return 'Biodegradable';
      case WasteStatus.nonBiodegradable:
        return 'Non-Biodegradable';
      case WasteStatus.recyclable:
        return 'Recyclable';
      case WasteStatus.unknown:
        return 'Unknown';
      case WasteStatus.invalid:
        return 'Invalid Image';
    }
  }
}

class ScanResult {
  final String id;
  final String name;
  final WasteStatus status;
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

  factory ScanResult.fromJson(Map<String, dynamic> json, {String? imagePath}) {
    final statusString = (json['prediction'] ?? json['status'])?.toLowerCase() ?? 'unknown';
    WasteStatus status;
    
    switch (statusString) {
      case 'biodegradable':
      case 'organic':
      case 'degradable':
        status = WasteStatus.biodegradable;
        break;
      case 'non-biodegradable':
      case 'non-degradable':
      case 'waste':
        status = WasteStatus.nonBiodegradable;
        break;
      case 'recyclable':
      case 'plastic':
      case 'metal':
      case 'glass':
        status = WasteStatus.recyclable;
        break;
      case 'invalid':
        status = WasteStatus.invalid;
        break;
      default:
        status = WasteStatus.unknown;
    }

    return ScanResult(
      id: json['id']?.toString() ?? UniqueKey().toString(),
      name: json['name'] ?? 'Unnamed Item',
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
      case WasteStatus.biodegradable:
        return 'This item is organic and can be composted. Avoid mixing it with plastics to reduce environmental impact.';
      case WasteStatus.nonBiodegradable:
        return 'This item does not decompose naturally. Please dispose of it in a designated waste bin or check if it can be repurposed.';
      case WasteStatus.recyclable:
        return 'This item can be processed and reused. Please clean it and place it in the blue recycling bin.';
      case WasteStatus.unknown:
        return 'Classification unclear. Please ensure the item is clearly visible and try scanning again.';
      case WasteStatus.invalid:
        return 'The image provided is not clear or does not contain a recognizable waste item. Please retake the photo.';
    }
  }
}
