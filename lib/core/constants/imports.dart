// File: imports.dart
// Location: lib/core/constants/
//
// Purpose:
// This is a **barrel file** that re-exports common packages and app modules.
// It simplifies import statements across the app — instead of importing dozens of packages in every file,
// you can just write: `import 'package:reels_ulearna/core/constants/imports.dart';`
//
// Clean Architecture Note:
// This belongs to the **Core Layer** and is useful for development efficiency and consistency.

export 'dart:convert';

/// Flutter & third-party UI packages
export 'package:cached_network_image/cached_network_image.dart';
/// Utility & State packages
export 'package:connectivity_plus/connectivity_plus.dart';
export 'package:dartz/dartz.dart'
    hide State; // `Either<L, R>` for error handling
export 'package:equatable/equatable.dart';
export 'package:flutter/foundation.dart';
export 'package:flutter/material.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';
/// Core modules
export 'package:reels_ulearna/core/constants/api_constants.dart';
export 'package:reels_ulearna/core/error/exceptions.dart';
export 'package:reels_ulearna/core/error/failures.dart';
export 'package:reels_ulearna/core/extensions/context_extension.dart';
export 'package:reels_ulearna/core/network/network_info.dart';
export 'package:reels_ulearna/core/services/injection_container.dart';
export 'package:reels_ulearna/core/usecases/usecase.dart';
/// Feature: Reels
export 'package:reels_ulearna/features/reels/data/datasources/reels_local_data_source.dart';
export 'package:reels_ulearna/features/reels/data/datasources/reels_remote_data_source.dart';
export 'package:reels_ulearna/features/reels/data/models/reel_model.dart';
export 'package:reels_ulearna/features/reels/data/repositories/reels_repository_impl.dart';
export 'package:reels_ulearna/features/reels/domain/entities/reel.dart';
export 'package:reels_ulearna/features/reels/domain/repositories/reels_repository.dart';
export 'package:reels_ulearna/features/reels/domain/usecases/get_reels.dart';
export 'package:reels_ulearna/features/reels/presentation/bloc/reels_bloc.dart';
export 'package:reels_ulearna/features/reels/presentation/bloc/reels_event.dart';
export 'package:reels_ulearna/features/reels/presentation/bloc/reels_state.dart';
export 'package:reels_ulearna/features/reels/presentation/pages/reels_page.dart';
export 'package:reels_ulearna/features/reels/presentation/widgets/loading_indicator.dart';
export 'package:reels_ulearna/features/reels/presentation/widgets/reel_item.dart';
/// 🏁 Entry point widget
export 'package:reels_ulearna/my_app.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:video_player/video_player.dart';
