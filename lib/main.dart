// File: main.dart
// Location: lib/
//
// Purpose:
// This is the **entry point** of the Flutter application.
// It performs required setup like initializing dependencies and then starts the app.
//
// Clean Architecture Note:
// This is part of the **App Layer** (outside domain/data/presentation).
// It connects infrastructure (e.g., dependency injection) to the app.

import 'package:reels_ulearna/core/constants/imports.dart';

void main() async {
  /// Ensures binding is initialized before running asynchronous code.
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize all app-level dependencies (services, repositories, blocs, etc.).
  await init();

  /// Launches the root of the widget tree.
  runApp(const MyApp());
}
