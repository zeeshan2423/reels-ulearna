// File: context_extension.dart
// Location: lib/core/extensions/
//
// Purpose:
// Adds a custom extension to `BuildContext` to easily access `ReelsBloc`.
// This is a convenience utility to reduce boilerplate when interacting with BLoC in the UI.
//
// Clean Architecture Note:
// Extensions like this are UI helpers and belong to the **Core Layer** when shared across multiple features.

import 'package:reels_ulearna/core/constants/imports.dart';

extension ContextExtension on BuildContext {
  /// 🔁 Provides direct access to the `ReelsBloc` from the widget context.
  ///
  /// Instead of writing:
  /// `BlocProvider.of<ReelsBloc>(context)` or `context.read<ReelsBloc>()`
  /// You can now write: `context.reelsBloc`
  ReelsBloc get reelsBloc => read<ReelsBloc>();
}
