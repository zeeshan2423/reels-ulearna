import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/reels/data/datasources/reels_local_data_source.dart';
import '../../features/reels/data/datasources/reels_remote_data_source.dart';
import '../../features/reels/data/repositories/reels_repository_impl.dart';
import '../../features/reels/domain/repositories/reels_repository.dart';
import '../../features/reels/domain/usecases/get_reels.dart';
import '../../features/reels/presentation/bloc/reels_bloc.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => ReelsBloc(getReels: sl()));

  sl.registerLazySingleton(() => GetReels(sl()));

  sl.registerLazySingleton<ReelsRepository>(
    () => ReelsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<ReelsRemoteDataSource>(
    () => ReelsRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ReelsLocalDataSource>(
    () => ReelsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}
