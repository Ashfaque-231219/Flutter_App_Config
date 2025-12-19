import 'package:flutter/material.dart';
import 'app_config.dart';

/// Configuration for the splash screen.
class SplashConfig {
  /// Path to the splash screen image asset.
  ///
  /// If empty, a Flutter logo will be displayed.
  /// Path should be relative to assets (e.g., "assets/images/splash.png").
  final String imagePath;

  /// Duration to show the splash screen.
  final Duration duration;

  /// Background color as integer (e.g., 0xFF2196F3 for blue).
  ///
  /// Defaults to Flutter blue (0xFF2196F3).
  final int backgroundColor;

  /// Optional callback called when splash screen finishes.
  final VoidCallback? onComplete;

  const SplashConfig({
    this.imagePath = '',
    this.duration = const Duration(seconds: 2),
    this.backgroundColor = 0xFF2196F3,
    this.onComplete,
  });

  /// Create SplashConfig from AppConfig
  factory SplashConfig.fromAppConfig(AppConfig appConfig) {
    return SplashConfig(
      imagePath: appConfig.splashImagePath ?? '',
      duration: const Duration(seconds: 2),
      backgroundColor: 0xFF2196F3,
    );
  }
}

