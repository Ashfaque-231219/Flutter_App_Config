#!/usr/bin/env dart
// ignore_for_file: avoid_print

// Configuration tool that reads from pubspec.yaml and configures
// app name, icon, version, and splash screen automatically.
// 
// This makes the package feel native - users just configure in pubspec.yaml
// and run this tool.

import 'dart:io';
import 'package:yaml/yaml.dart';

void main(List<String> args) {
  // Parse command line arguments
  bool androidOnly = false;
  bool iosOnly = false;
  
  for (var arg in args) {
    if (arg == '--android') {
      androidOnly = true;
    } else if (arg == '--ios') {
      iosOnly = true;
    }
  }
  
  print('🚀 Configuring app from pubspec.yaml...\n');

  // Read pubspec.yaml
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('❌ pubspec.yaml not found!');
    exit(1);
  }

  final pubspecContent = pubspecFile.readAsStringSync();
  final pubspec = loadYaml(pubspecContent);

  // Extract configuration
  final appConfig = pubspec['flutter_app_config'] as Map?;
  if (appConfig == null) {
    print('⚠️  No flutter_app_config configuration found in pubspec.yaml');
    print('   Add configuration section (see README.md)');
    exit(0);
  }

  final appName = appConfig['app_name'] as String? ?? 'Flutter App';
  final packageId = appConfig['package_id'] as String? ?? 'com.example.app';
  final versionString = pubspec['version'] as String?;
  final versionName = appConfig['version_name'] as String? ?? 
                      (versionString != null ? versionString.split('+')[0] : '1.0.0');
  final versionParts = versionString?.split('+') ?? [];
  final versionCode = appConfig['version_code'] as int? ?? 
                      (versionParts.length > 1 
                        ? int.tryParse(versionParts[1]) ?? 1
                        : 1);
  final splashImagePath = appConfig['splash_image_path'] as String?;
  final useFlutterLogo = appConfig['use_flutter_logo'] as bool? ?? false;

  print('📋 Configuration:');
  print('   App Name: $appName');
  print('   Package ID: $packageId');
  print('   Version: $versionName ($versionCode)');
  print('   Splash Image: ${splashImagePath ?? "Flutter logo (default)"}');
  print('   Use Flutter Logo: $useFlutterLogo\n');

  // Configure Android
  if (!iosOnly) {
    _configureAndroid(appName, packageId, versionName, versionCode);
    
    // Setup Android icons
    if (useFlutterLogo) {
      print('📱 Setting up Flutter logo icons for Android...');
      _setupFlutterLogoIconsAndroid();
    }
  }
  
  // Configure iOS
  if (!androidOnly) {
    _configureIOS(appName, packageId, versionName, versionCode);
    
    // Setup iOS icons
    if (useFlutterLogo) {
      print('📱 Setting up Flutter logo icons for iOS...');
      _setupFlutterLogoIconsIOS();
    }
  }

  print('\n✅ Configuration complete!');
  print('   Run: flutter run');
}

void _configureAndroid(String appName, String packageId, String versionName, int versionCode) {
  print('🔧 Configuring Android...');

  // Update AndroidManifest.xml
  final manifestFile = File('android/app/src/main/AndroidManifest.xml');
  if (manifestFile.existsSync()) {
    var content = manifestFile.readAsStringSync();
    content = content.replaceAll(
      RegExp(r'android:label="[^"]*"'),
      'android:label="$appName"',
    );
    manifestFile.writeAsStringSync(content);
    print('   ✅ Updated AndroidManifest.xml');
  }
  
  // Remove native splash screen to avoid double splash
  _removeNativeSplashScreen();

  // Update strings.xml
  final stringsFile = File('android/app/src/main/res/values/strings.xml');
  if (!stringsFile.existsSync()) {
    stringsFile.createSync(recursive: true);
    stringsFile.writeAsStringSync('''<resources>
    <string name="app_name">$appName</string>
</resources>''');
  } else {
    var content = stringsFile.readAsStringSync();
    if (content.contains('<string name="app_name">')) {
      content = content.replaceAll(
        RegExp(r'<string name="app_name">[^<]*</string>'),
        '<string name="app_name">$appName</string>',
      );
    } else {
      content = content.replaceAll(
        '</resources>',
        '    <string name="app_name">$appName</string>\n</resources>',
      );
    }
    stringsFile.writeAsStringSync(content);
  }
  print('   ✅ Updated strings.xml');

  // Update build.gradle.kts
  final buildGradleFile = File('android/app/build.gradle.kts');
  if (buildGradleFile.existsSync()) {
    var content = buildGradleFile.readAsStringSync();
    // Update applicationId
    content = content.replaceAll(
      RegExp(r'applicationId\s*=\s*"[^"]*"'),
      'applicationId = "$packageId"',
    );
    // Update versionName
    content = content.replaceAll(
      RegExp(r'versionName\s*=\s*"[^"]*"'),
      'versionName = "$versionName"',
    );
    // Update versionCode
    content = content.replaceAll(
      RegExp(r'versionCode\s*=\s*\d+'),
      'versionCode = $versionCode',
    );
    buildGradleFile.writeAsStringSync(content);
    print('   ✅ Updated build.gradle.kts');
  }
}

void _configureIOS(String appName, String packageId, String versionName, int versionCode) {
  print('🔧 Configuring iOS...');

  // Update Info.plist
  final infoPlistFile = File('ios/Runner/Info.plist');
  if (infoPlistFile.existsSync()) {
    var content = infoPlistFile.readAsStringSync();
    // Update CFBundleDisplayName
    if (content.contains('<key>CFBundleDisplayName</key>')) {
      content = content.replaceAll(
        RegExp(r'<key>CFBundleDisplayName</key>\s*<string>[^<]*</string>'),
        '<key>CFBundleDisplayName</key>\n\t<string>$appName</string>',
      );
    } else {
      content = content.replaceAll(
        '</dict>',
        '\t<key>CFBundleDisplayName</key>\n\t<string>$appName</string>\n</dict>',
      );
    }
    infoPlistFile.writeAsStringSync(content);
    print('   ✅ Updated Info.plist');
  }

  // Update project.pbxproj for bundle identifier
  final projectFile = File('ios/Runner.xcodeproj/project.pbxproj');
  if (projectFile.existsSync()) {
    var content = projectFile.readAsStringSync();
    content = content.replaceAll(
      RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = [^;]+;'),
      'PRODUCT_BUNDLE_IDENTIFIER = $packageId;',
    );
    projectFile.writeAsStringSync(content);
    print('   ✅ Updated project.pbxproj');
  }
  
  // Remove native splash screen to avoid double splash
  _removeNativeSplashScreenIOS();
}

void _removeNativeSplashScreen() {
  print('   🔧 Removing native splash screen to avoid double splash...');
  
  // Update styles.xml to use transparent background
  final stylesFile = File('android/app/src/main/res/values/styles.xml');
  if (stylesFile.existsSync()) {
    var content = stylesFile.readAsStringSync();
    content = content.replaceAll(
      RegExp(r'<item name="android:windowBackground">@drawable/launch_background</item>'),
      '<item name="android:windowBackground">@android:color/transparent</item>',
    );
    stylesFile.writeAsStringSync(content);
    print('   ✅ Updated styles.xml');
  }
  
  // Update styles.xml for Android 12+
  final stylesV31File = File('android/app/src/main/res/values-v31/styles.xml');
  if (stylesV31File.existsSync()) {
    var content = stylesV31File.readAsStringSync();
    content = content.replaceAll(
      RegExp(r'<item name="android:windowBackground">@drawable/launch_background</item>'),
      '<item name="android:windowBackground">@android:color/transparent</item>',
    );
    stylesV31File.writeAsStringSync(content);
    print('   ✅ Updated styles.xml (v31)');
  }
  
  // Update night mode styles
  final stylesNightFile = File('android/app/src/main/res/values-night/styles.xml');
  if (stylesNightFile.existsSync()) {
    var content = stylesNightFile.readAsStringSync();
    content = content.replaceAll(
      RegExp(r'<item name="android:windowBackground">@drawable/launch_background</item>'),
      '<item name="android:windowBackground">@android:color/transparent</item>',
    );
    stylesNightFile.writeAsStringSync(content);
    print('   ✅ Updated styles.xml (night mode)');
  }
}

void _removeNativeSplashScreenIOS() {
  print('   🔧 Removing native iOS splash screen to avoid double splash...');
  
  // Update LaunchScreen.storyboard to be transparent
  final launchScreenFile = File('ios/Runner/Base.lproj/LaunchScreen.storyboard');
  if (launchScreenFile.existsSync()) {
    var content = launchScreenFile.readAsStringSync();
    // Remove LaunchImage imageView
    content = content.replaceAll(
      RegExp(r'<imageView[^>]*image="LaunchImage"[^>]*>[\s\S]*?</imageView>'),
      '',
    );
    // Make background transparent
    content = content.replaceAll(
      RegExp(r'<color key="backgroundColor" red="[^"]*" green="[^"]*" blue="[^"]*" alpha="[^"]*"'),
      '<color key="backgroundColor" red="0" green="0" blue="0" alpha="0"',
    );
    // Remove constraints related to removed imageView
    content = content.replaceAll(
      RegExp(r'<constraint[^>]*firstItem="YRO-k0-Ey4"[^>]*>[\s\S]*?</constraint>'),
      '',
    );
    launchScreenFile.writeAsStringSync(content);
    print('   ✅ Updated LaunchScreen.storyboard');
  }
}

void _setupFlutterLogoIconsAndroid() {
  // Try macOS script first (uses built-in sips, no ImageMagick needed)
  if (Platform.isMacOS) {
    final script = File('setup_flutter_logo_macos.sh');
    if (script.existsSync()) {
      final result = Process.runSync('bash', ['setup_flutter_logo_macos.sh'], runInShell: true);
      if (result.exitCode == 0) {
        print('   ✅ Flutter logo icons set up successfully');
        return;
      }
    }
  }
  
  // Fallback to ImageMagick script
  final script = File('setup_flutter_logo_simple.sh');
  if (script.existsSync()) {
    final result = Process.runSync('bash', ['setup_flutter_logo_simple.sh'], runInShell: true);
    if (result.exitCode == 0) {
      print('   ✅ Flutter logo icons set up successfully');
      return;
    }
  }
  
  print('   ⚠️  Could not set up icons automatically.');
  if (Platform.isMacOS) {
    print('   Run manually: ./setup_flutter_logo_macos.sh');
  } else {
    print('   Run manually: ./setup_flutter_logo_simple.sh (requires ImageMagick)');
  }
}

void _setupFlutterLogoIconsIOS() {
  // Same as Android - both platforms are set up by the same script
  _setupFlutterLogoIconsAndroid();
}

