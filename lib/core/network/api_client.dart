import 'dart:convert';
import 'package:http/http.dart' as http;
import '../error/exceptions.dart';

class ApiClient {
  final http.Client client;
  final String baseUrl = 'http://moelshafey.top/API/MD';

  ApiClient({required this.client});

  Future<dynamic> get(String path, {Map<String, String>? queryParameters}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);
    try {
      final response = await client.get(uri).timeout(const Duration(seconds: 15));
      print(response.body);
      print(uri);

      return _handleResponse(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException();
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ServerException('Server error: ${response.statusCode}');
    }
  }
}
