import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash_config.dart';

/// A customizable splash screen widget
class SplashScreen extends StatefulWidget {
  /// Configuration for the splash screen
  final SplashConfig config;

  /// Widget to show after splash screen completes
  final Widget home;

  const SplashScreen({
    super.key,
    required this.config,
    required this.home,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(widget.config.backgroundColor),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    Timer(widget.config.duration, () {
      if (mounted) {
        widget.config.onComplete?.call();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => widget.home),
        );
      }
    });
  }
  
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(widget.config.backgroundColor),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(widget.config.backgroundColor),
          image: widget.config.imagePath.isNotEmpty
              ? DecorationImage(
                  image: AssetImage(widget.config.imagePath),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: widget.config.imagePath.isEmpty
            ? Center(
                child: FlutterLogo(
                  size: 100,
                ),
              )
            : null,
      ),
    );
  }
}

