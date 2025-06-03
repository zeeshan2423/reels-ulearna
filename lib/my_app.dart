// File: my_app.dart
// Location: lib/
//
// Purpose:
// This file defines the root widget of the application, `MyApp`.
// It sets up the app's theme and initial screen (home page).
//
// Clean Architecture Note:
// While this file touches the Presentation Layer, it mainly serves to
// assemble and connect pieces — not to handle business logic or UI rendering directly.

import 'package:reels_ulearna/core/constants/imports.dart';

/// `MyApp` is the root widget of the app.
///
/// It sets up the [MaterialApp], configures global themes,
/// and injects the initial `ReelsBloc` used in the home screen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ulearna Reels',

      /// App-wide theme configuration.
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      /// Sets the initial screen of the app with dependency-injected BLoC.
      home: BlocProvider(
        /// Provides the `ReelsBloc` from the service locator (`sl`).
        create: (_) => sl<ReelsBloc>(),

        /// 🖥 The main screen for displaying reels.
        child: const ReelsPage(),
      ),
    );
  }
}
