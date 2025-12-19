/// App configuration read from pubspec.yaml.
///
/// Allows configuring app name, icon, version, and splash screen
/// directly from pubspec.yaml.
class AppConfig {
  /// App name (display name)
  final String appName;
  
  /// App package ID (e.g., com.example.myapp)
  final String packageId;
  
  /// Version name (e.g., 1.0.0)
  final String versionName;
  
  /// Version code / Build number (e.g., 1)
  final int versionCode;
  
  /// Splash screen image path (relative to assets)
  final String? splashImagePath;
  
  /// Use Flutter logo for app icon (default: false - uses custom icon)
  final bool useFlutterLogo;
  
  /// Custom app icon path (required if useFlutterLogo is false)
  final String? customIconPath;

  const AppConfig({
    required this.appName,
    required this.packageId,
    required this.versionName,
    required this.versionCode,
    this.splashImagePath,
    this.useFlutterLogo = false,
    this.customIconPath,
  });

  /// Create AppConfig from a map (typically from pubspec.yaml)
  factory AppConfig.fromMap(Map<String, dynamic> map) {
    return AppConfig(
      appName: map['app_name'] as String? ?? 'Flutter App',
      packageId: map['package_id'] as String? ?? 'com.example.app',
      versionName: map['version_name'] as String? ?? '1.0.0',
      versionCode: (map['version_code'] as int?) ?? 1,
      splashImagePath: map['splash_image_path'] as String?,
      useFlutterLogo: map['use_flutter_logo'] as bool? ?? false,
      customIconPath: map['custom_icon_path'] as String?,
    );
  }

  /// Parse version from pubspec.yaml format (e.g., "1.0.0+1")
  factory AppConfig.fromVersionString(String versionString) {
    final parts = versionString.split('+');
    final versionName = parts[0];
    final versionCode = parts.length > 1 ? int.tryParse(parts[1]) ?? 1 : 1;
    
    return AppConfig(
      appName: 'Flutter App',
      packageId: 'com.example.app',
      versionName: versionName,
      versionCode: versionCode,
    );
  }
}

