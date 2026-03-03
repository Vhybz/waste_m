
import 'package:flutter/material.dart';

class AppColors {
  // NEW ECO PALETTE
  static const primary = Color(0xFF2E7D32); // Deep Green
  static const primaryLight = Color(0xFF81C784); // Light Green
  static const surface = Color(0xFFF1F8E9); // Soft Mint Surface
  static const background = Color(0xFFFFFFFF); // Clean white background

  // Status colors for waste categories
  static final biodegradable = Colors.green.shade600;
  static final nonBiodegradable = Colors.red.shade600;
  static final recyclable = Colors.blue.shade600;
  
  // Backward compatibility aliases
  static final normal = Colors.green.shade100.withValues(alpha: 0.5);
  static final mild = Colors.amber.shade100.withValues(alpha: 0.5);
  static final moderate = Colors.orange.shade100.withValues(alpha: 0.5);
  static final severe = Colors.red.shade100.withValues(alpha: 0.5);
}
