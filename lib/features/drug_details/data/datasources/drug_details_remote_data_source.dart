import 'package:dua/core/network/api_client.dart';

abstract class DrugDetailsRemoteDataSource {
  Future<String> getDrugInfo(String id);
}

class DrugDetailsRemoteDataSourceImpl implements DrugDetailsRemoteDataSource {
  final ApiClient apiClient;

  DrugDetailsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<String> getDrugInfo(String id) async {
    final response = await apiClient.get(
      '/info.php',
      queryParameters: {'id': id},
    );
    if (response is Map && !response['error']) {
      return response['msg'].toString();
    }
    return '';
  }
}
