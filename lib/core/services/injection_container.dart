// File: injection_container.dart
// Location: lib/core/services/
//
// Purpose:
// Sets up and registers all dependencies (services, blocs, repositories, data sources) using `get_it`.
// This acts as the **Service Locator**.
//
// Clean Architecture Note:
// This is an **Application Layer** file that wires together all feature layers (Presentation, Domain, Data).

import 'package:http/http.dart' as http;
import 'package:reels_ulearna/core/constants/imports.dart';

/// Singleton service locator instance (GetIt)
final sl = GetIt.instance;

/// Initializes and registers all dependencies (lazy singletons, factories, etc.)
Future<void> init() async {
  // BLoC
  sl.registerFactory(() => ReelsBloc(getReels: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetReels(sl()));

  // Repositories
  sl.registerLazySingleton<ReelsRepository>(
    () => ReelsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Remote Data Source
  sl.registerLazySingleton<ReelsRemoteDataSource>(
    () => ReelsRemoteDataSourceImpl(client: sl()),
  );

  // Local Data Source
  sl.registerLazySingleton<ReelsLocalDataSource>(
    () => ReelsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  // External Packages
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}
