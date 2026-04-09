import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:dua/features/access_control/data/datasources/access_remote_data_source.dart';
import 'package:dua/features/access_control/data/repositories/access_repository_impl.dart';
import 'package:dua/features/access_control/domain/repositories/access_repository.dart';
import 'package:dua/features/access_control/domain/usecases/check_version_usecase.dart';
import 'package:dua/features/access_control/presentation/cubit/access_cubit.dart';
import 'package:dua/features/drug_search/data/datasources/drug_remote_data_source.dart';
import 'package:dua/features/drug_search/data/repositories/drug_repository_impl.dart';
import 'package:dua/features/drug_search/domain/repositories/drug_repository.dart';
import 'package:dua/features/drug_search/domain/usecases/search_drugs_usecase.dart';
import 'package:dua/features/drug_search/presentation/cubit/search_cubit.dart';
import 'package:dua/features/drug_details/data/datasources/drug_details_remote_data_source.dart';
import 'package:dua/features/drug_details/data/repositories/drug_details_repository_impl.dart';
import 'package:dua/features/drug_details/domain/repositories/drug_details_repository.dart';
import 'package:dua/features/drug_details/domain/usecases/get_drug_info_usecase.dart';
import 'package:dua/features/drug_details/presentation/cubit/drug_details_cubit.dart';
import 'package:dua/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:dua/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:dua/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:dua/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:dua/features/favorites/domain/usecases/toggle_favorite_usecase.dart';
import 'package:dua/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dua/core/network/api_client.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:dua/core/services/voice_search_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Drug Search
  sl.registerFactory(() => SearchCubit(searchDrugsUseCase: sl()));
  sl.registerLazySingleton(() => SearchDrugsUseCase(sl()));
  sl.registerLazySingleton<DrugRepository>(
    () => DrugRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DrugRemoteDataSource>(
    () => DrugRemoteDataSourceImpl(apiClient: sl()),
  );

  // Features - Drug Details
  sl.registerFactory(() => DrugDetailsCubit(getDrugInfoUseCase: sl()));
  sl.registerLazySingleton(() => GetDrugInfoUseCase(sl()));
  sl.registerLazySingleton<DrugDetailsRepository>(
    () => DrugDetailsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DrugDetailsRemoteDataSource>(
    () => DrugDetailsRemoteDataSourceImpl(apiClient: sl()),
  );
  // Features - Favorites
  sl.registerFactory(
    () => FavoritesCubit(
      getFavoritesUseCase: sl(),
      toggleFavoriteUseCase: sl(),
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(),
  );

  // Features - Access Control
  sl.registerFactory(() => AccessCubit(checkVersionUseCase: sl()));
  sl.registerLazySingleton(() => CheckVersionUseCase(sl()));
  sl.registerLazySingleton<AccessRepository>(
    () => AccessRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AccessRemoteDataSource>(
    () => AccessRemoteDataSourceImpl(apiClient: sl()),
  );

  // Core
  sl.registerLazySingleton(() => ApiClient(client: sl()));
  sl.registerLazySingleton(() => VoiceSearchService(sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => SpeechToText());
}
