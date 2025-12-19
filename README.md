# flutter_app_config

Configure app name, icon, version, and splash screen directly from `pubspec.yaml`. Save 30-60 minutes of manual setup with automatic Android/iOS configuration. Flutter logo included. One command setup.

## What It Does?

- ✅ **Updates AndroidManifest.xml** - App name for release, debug & profile
- ✅ **Updates build.gradle.kts** - Package ID, version name, and version code
- ✅ **Updates strings.xml** - App name resource
- ✅ **Removes native Android splash** - Sets transparent background to avoid double splash
- ✅ **Updates Info.plist** - App display name for iOS
- ✅ **Updates project.pbxproj** - Bundle identifier for iOS
- ✅ **Removes native iOS splash** - Makes LaunchScreen transparent to avoid double splash
- ✅ **Supports Flutter logo icons** - Manual setup required (see documentation)
- ✅ **Configures splash screen** - Ready-to-use widget with Flutter logo by default
- ✅ **Platform-specific options** - Configure Android only, iOS only, or both

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_app_config: ^1.0.0
```

Or run this command:

```bash
flutter pub add flutter_app_config
```

Then run:

```bash
flutter pub get
```

## Quick Start (3 Steps)

### Step 1: Add Configuration to `pubspec.yaml`

Add configuration section to your `pubspec.yaml`:

```yaml
# Your existing pubspec.yaml
name: my_app
version: 1.0.0+1

dependencies:
  flutter:
    sdk: flutter
  flutter_app_config: ^1.0.0

# ⚠️ IMPORTANT: Add this configuration section at ROOT LEVEL (same level as 'dependencies')
# Do NOT put it inside the 'dependencies:' section!
flutter_app_config:
  app_name: "My Awesome App"
  package_id: "com.example.myapp"
  version_name: "1.0.0"
  version_code: 1
  splash_image_path: null  # null = Flutter logo, or "assets/images/splash.png"
  use_flutter_logo: false  # false = custom icon (default), true = Flutter logo
  custom_icon_path: "assets/icons/app_icon.png"  # Your custom icon path
```

**⚠️ Common Mistake:** Make sure `flutter_app_config:` is at the **root level** of your `pubspec.yaml` (same indentation as `dependencies:`), NOT inside the `dependencies:` section. If you put it inside `dependencies:`, you'll get a "Duplicate mapping key" error.

### Step 2: Apply Configuration (IMPORTANT!)

**After adding the configuration above, you MUST run this command to apply the changes:**

```bash
dart run flutter_app_config:configure
```

This command will automatically:
- ✅ Update Android files (AndroidManifest.xml, build.gradle.kts, strings.xml)
- ✅ Update iOS files (Info.plist, project.pbxproj)
- ✅ Remove native splash screens (to avoid double splash)
- ⚠️ Set up app icons (if icon setup scripts are available - otherwise requires manual setup)

**Platform-specific options:**

To configure only Android:
```bash
dart run flutter_app_config:configure --android
```

To configure only iOS:
```bash
dart run flutter_app_config:configure --ios
```

**Note:** You need to run this command every time you change the configuration in `pubspec.yaml` to apply the changes to your Android/iOS project files.

**Alternative command (if the above doesn't work):**
```bash
flutter pub run flutter_app_config:configure
```

### Step 3: Use Splash Screen in Your App

Now add the splash screen widget to your app code:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_app_config/flutter_app_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Awesome App',
      home: SplashScreen(
        config: const SplashConfig(
          imagePath: '', // Empty = Flutter logo (default)
          duration: Duration(seconds: 2),
          backgroundColor: 0xFF2196F3, // Flutter blue
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Welcome!')),
    );
  }
}
```

### Step 4: Run Your App

```bash
flutter run
```

**That's it!** Your app is now configured with:
- ✅ Custom app name (shown under app icon)
- ✅ Package ID / Bundle Identifier (updated in Android/iOS)
- ✅ Version and build number (updated in Android/iOS)
- ✅ Custom app icon (or Flutter logo if `use_flutter_logo: true`)
- ✅ Flutter logo splash screen (displayed on app launch)

## Configuration Options

All configuration is done in `pubspec.yaml` under `flutter_app_config`:

```yaml
name: my_app
version: 1.0.0+1

dependencies:
  flutter:
    sdk: flutter
  flutter_app_config: ^1.0.0

# ⚠️ Configuration section at ROOT LEVEL (same level as 'dependencies')
flutter_app_config:
  # Required
  app_name: "Your App Name"           # Display name shown under app icon
  package_id: "com.example.app"      # Package ID (Android) / Bundle ID (iOS)
  
  # Version (optional - uses pubspec.yaml version if not set)
  version_name: "1.0.0"              # Version string (e.g., 1.0.0)
  version_code: 1                    # Build number (integer)
  
  # Splash Screen
  splash_image_path: null            # null = Flutter logo, or path like "assets/images/splash.png"
  
  # App Icon
  use_flutter_logo: false            # false = use custom icon (default), true = use Flutter logo
  custom_icon_path: "assets/icons/app_icon.png"  # Path to your custom icon (required if use_flutter_logo is false)
```

**⚠️ Important:** The `flutter_app_config:` section must be at the **root level** of your `pubspec.yaml` file (same indentation as `dependencies:`), NOT inside the `dependencies:` section. Putting it inside `dependencies:` will cause a "Duplicate mapping key" YAML error.

### Configuration Examples

**Minimal (uses custom icon):**
```yaml
flutter_app_config:
  app_name: "My App"
  package_id: "com.example.myapp"
  custom_icon_path: "assets/icons/app_icon.png"  # Your custom icon
```

**Full Configuration (Custom Icon):**
```yaml
flutter_app_config:
  app_name: "My Awesome App"
  package_id: "com.company.myapp"
  version_name: "2.5.0"
  version_code: 25
  splash_image_path: "assets/images/custom_splash.png"
  use_flutter_logo: false  # Use custom icon
  custom_icon_path: "assets/icons/app_icon.png"
```

**Using Flutter Logo (Optional):**
```yaml
flutter_app_config:
  app_name: "My App"
  package_id: "com.example.myapp"
  use_flutter_logo: true   # Use Flutter logo instead of custom icon
  # custom_icon_path not needed when use_flutter_logo is true
```

**Using Custom Splash Image:**
```yaml
flutter_app_config:
  app_name: "My App"
  package_id: "com.example.myapp"
  splash_image_path: "assets/images/my_splash.png"  # Custom splash image
  custom_icon_path: "assets/icons/my_icon.png"  # Custom icon (512x512 recommended)
```

**Using Flutter Logo for App Icon:**
```yaml
flutter_app_config:
  app_name: "My App"
  package_id: "com.example.myapp"
  use_flutter_logo: true   # Use Flutter logo for app icon
  # custom_icon_path not needed when use_flutter_logo is true
```

## Setting Up App Icons

### Using Custom Icon (Default)

By default, the package uses your custom icon. Just provide the path in `custom_icon_path`:

```yaml
flutter_app_config:
  app_name: "My App"
  package_id: "com.example.myapp"
  custom_icon_path: "assets/icons/app_icon.png"  # Your custom icon (512x512 recommended)
```

**Note:** Custom icon setup requires manual configuration. The configuration tool will update app metadata, but you'll need to generate and place icon files manually using tools like [appicon.co](https://appicon.co/) or similar icon generators.

### Using Flutter Logo (Optional)

If you want to use Flutter logo instead, set `use_flutter_logo: true`:

```yaml
flutter_app_config:
  app_name: "My App"
  package_id: "com.example.myapp"
  use_flutter_logo: true   # Use Flutter logo
```

**Note:** Icon setup requires additional scripts. See manual setup below.

### Automatic Setup (Requires Scripts)

**The configuration tool will attempt to set up icons when you run:**
```bash
dart run flutter_app_config:configure
```

**If icon setup scripts are available, the tool will:**
- Automatically download Flutter logo
- Generate all required icon sizes for Android and iOS
- Use macOS built-in tools (no ImageMagick needed on macOS)
- Fall back to ImageMagick script on other platforms if needed

**If scripts are not found, you'll need to set up icons manually (see below).**

### Manual Setup (Optional)

If you need to regenerate icons manually:

1. Download Flutter logo from: https://flutter.dev/brand
2. Use online tool: https://appicon.co/ to generate all sizes
3. Replace icon files manually in:
   - Android: `android/app/src/main/res/mipmap-*/ic_launcher.png`
   - iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

## What Gets Configured?

### Android:
- ✅ `android/app/src/main/AndroidManifest.xml` - App name
- ✅ `android/app/src/main/res/values/strings.xml` - App name resource
- ✅ `android/app/build.gradle.kts` - Package ID, version name, version code
- ✅ `android/app/src/main/res/values/styles.xml` - Removes native splash (transparent background)
- ✅ App icons (all densities: mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi) - Flutter logo

### iOS:
- ✅ `ios/Runner/Info.plist` - App display name
- ✅ `ios/Runner.xcodeproj/project.pbxproj` - Bundle identifier
- ✅ `ios/Runner/Base.lproj/LaunchScreen.storyboard` - Removes native splash (transparent)
- ✅ App icons (all required sizes) - Flutter logo

### Flutter:
- ✅ Splash screen widget ready to use
- ✅ Flutter logo displayed by default
- ✅ Customizable duration and colors

## Requirements

- Flutter SDK >=3.0.0
- Dart SDK >=3.0.0
- For icon generation (optional): ImageMagick or use online tools like [appicon.co](https://appicon.co/)

## Complete Workflow Summary

1. **Add package** → `flutter pub add flutter_app_config`
2. **Add config** → Add `flutter_app_config:` section to `pubspec.yaml`
3. **Apply changes** → Run `dart run flutter_app_config:configure` ⚠️ **This is required!**
4. **Add splash widget** → Use `SplashScreen` in your `main.dart`
5. **Run app** → `flutter run`

**Important:** Step 3 (`dart run flutter_app_config:configure`) is required every time you change the configuration in `pubspec.yaml`. This command reads your config and updates all Android/iOS files automatically.

## Troubleshooting

**"Duplicate mapping key" error:**
```yaml
# ❌ WRONG - Don't put flutter_app_config inside dependencies:
dependencies:
  flutter_app_config: ^1.0.0
  flutter_app_config:  # ❌ This causes duplicate key error!
    app_name: "My App"

# ✅ CORRECT - Put it at root level:
dependencies:
  flutter_app_config: ^1.0.0

flutter_app_config:  # ✅ At root level, same as 'dependencies'
  app_name: "My App"
```

**Configuration tool not found:**
```bash
# Make sure you're in your project root and have run: flutter pub get
dart run flutter_app_config:configure

# If that doesn't work, try:
flutter pub run flutter_app_config:configure
```

**Changes not applied after updating pubspec.yaml:**
```bash
# You must run the configuration tool after changing pubspec.yaml
dart run flutter_app_config:configure
```

**Icons not showing:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

**Need to regenerate icons:**
Icon setup requires manual configuration. To set up icons:
1. Download Flutter logo from https://flutter.dev/brand
2. Use online tool https://appicon.co/ to generate all sizes
3. Replace icon files manually

**Icon setup not working:**
- Icon setup requires manual configuration using online tools or scripts
- For custom icons: Use online tool https://appicon.co/ to generate all required sizes
- For Flutter logo: Download from https://flutter.dev/brand and use https://appicon.co/ to generate sizes
- Place generated icons in:
  - Android: `android/app/src/main/res/mipmap-*/ic_launcher.png`
  - iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
