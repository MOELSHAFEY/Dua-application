import 'package:dua/core/network/api_client.dart';
import 'package:dua/core/models/drug_model.dart';

abstract class DrugRemoteDataSource {
  Future<List<DrugModel>> searchDrugs(String query);
}

class DrugRemoteDataSourceImpl implements DrugRemoteDataSource {
  final ApiClient apiClient;

  DrugRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<DrugModel>> searchDrugs(String query) async {
    final response = await apiClient.get(
      '/search.php',
      queryParameters: {'name': query},
    );
    if (response is List) {
      return response.map((e) => DrugModel.fromJson(e)).toList();
    } else if (response is Map) {
      if (response.containsKey('products')) {
        final List data = response['products'];
        return data.map((e) => DrugModel.fromJson(e)).toList();
      } else if (response.containsKey('data')) {
        final List data = response['data'];
        return data.map((e) => DrugModel.fromJson(e)).toList();
      }
    }
    return [];
  }


}
