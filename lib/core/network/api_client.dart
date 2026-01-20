import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;

  ApiClient(this._client);

  Future<Map<String, dynamic>> get(String url, {Map<String, String>? params}) async {
    try {
      final uri = Uri.parse(url).replace(queryParameters: params);
      print(uri);
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
