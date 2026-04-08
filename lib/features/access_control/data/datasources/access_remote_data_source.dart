import '../../../../core/network/api_client.dart';
import '../models/app_version_model.dart';

abstract class AccessRemoteDataSource {
  Future<AppVersionModel> getLatestVersion();
}

class AccessRemoteDataSourceImpl implements AccessRemoteDataSource {
  final ApiClient apiClient;

  AccessRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AppVersionModel> getLatestVersion() async {
    final response = await apiClient.get('/V.json');
    return AppVersionModel.fromJson(response);
  }
}
