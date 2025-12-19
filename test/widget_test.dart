import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_config/flutter_app_config.dart';

void main() {
  group('SplashScreen Widget Tests', () {
    testWidgets('SplashScreen displays Flutter logo when imagePath is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SplashScreen(
            config: const SplashConfig(
              imagePath: '',
              duration: Duration(seconds: 1),
            ),
            home: const Scaffold(body: Text('Home')),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(FlutterLogo), findsOneWidget);
    });

    testWidgets('SplashScreen navigates to home after duration',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SplashScreen(
            config: const SplashConfig(
              duration: Duration(milliseconds: 100),
            ),
            home: const Scaffold(body: Text('Home')),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });
  });

  group('SplashConfig Tests', () {
    test('SplashConfig has correct defaults', () {
      const config = SplashConfig();

      expect(config.imagePath, '');
      expect(config.duration, const Duration(seconds: 2));
      expect(config.backgroundColor, 0xFF2196F3);
      expect(config.onComplete, isNull);
    });

    test('SplashConfig can be customized', () {
      bool callbackCalled = false;
      final config = SplashConfig(
        imagePath: 'assets/splash.png',
        duration: const Duration(seconds: 5),
        backgroundColor: 0xFF000000,
        onComplete: () => callbackCalled = true,
      );

      expect(config.imagePath, 'assets/splash.png');
      expect(config.duration, const Duration(seconds: 5));
      expect(config.backgroundColor, 0xFF000000);
      expect(config.onComplete, isNotNull);

      config.onComplete?.call();
      expect(callbackCalled, isTrue);
    });
  });

  group('AppConfig Tests', () {
    test('AppConfig.fromMap creates config with defaults', () {
      final config = AppConfig.fromMap({});

      expect(config.appName, 'Flutter App');
      expect(config.packageId, 'com.example.app');
      expect(config.versionName, '1.0.0');
      expect(config.versionCode, 1);
      expect(config.useFlutterLogo, false);
    });

    test('AppConfig.fromMap reads values correctly', () {
      final config = AppConfig.fromMap({
        'app_name': 'Test App',
        'package_id': 'com.test.app',
        'version_name': '2.0.0',
        'version_code': 10,
        'use_flutter_logo': true,
        'splash_image_path': 'assets/splash.png',
      });

      expect(config.appName, 'Test App');
      expect(config.packageId, 'com.test.app');
      expect(config.versionName, '2.0.0');
      expect(config.versionCode, 10);
      expect(config.useFlutterLogo, true);
      expect(config.splashImagePath, 'assets/splash.png');
    });
  });
}
