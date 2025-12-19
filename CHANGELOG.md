# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-12-19

### Fixed
- Improved README documentation to prevent "Duplicate mapping key" error
- Added clear warnings about placing `flutter_app_config:` at root level, not inside `dependencies:`
- Added troubleshooting section for common YAML configuration mistakes

## [1.0.0] - 2025-12-19

### Added
- Configure app name, package ID, version, and splash screen directly from `pubspec.yaml`
- Automatic Android/iOS configuration tool (`dart run flutter_app_config:configure`)
- `SplashScreen` widget with customizable duration, background color, and image
- Flutter logo support for splash screen (displayed by default)
- Platform-specific configuration options (Android only, iOS only, or both)
- Automatic removal of native splash screens to avoid double splash

### Features
- Updates AndroidManifest.xml, build.gradle.kts, and strings.xml
- Updates iOS Info.plist and project.pbxproj
- Supports custom icons and Flutter logo for app icons (manual setup required)
- Configures app metadata (name, package ID, version) automatically
