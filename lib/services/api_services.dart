import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Toggle between demo API and company API
  final bool useDemoApi;

  ApiService({this.useDemoApi = true});

  // Demo APIs
  final String _reqresBase = "https://reqres.in/api";
  final String _jsonPlaceholderBase = "https://jsonplaceholder.typicode.com";

  // Company API (replace with actual details from company)
  final String _companyBase = "https://your-company-api.com/api/v1";
  final String _apiKey = "YOUR_API_KEY_HERE"; // 👈 replace with real key

  /// Login API
  final String _baseUrl = "https://dummyjson.com";

  /// Login API using DummyJSON
  Future<String> login(String username, String password) async {
    print("user name ="+username+"  password ="+password);
    final url = Uri.parse("$_baseUrl/auth/login");

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['token'] ?? data['accessToken']; // token or accessToken
    } else {
      final data = jsonDecode(res.body);
      throw Exception(data['message'] ?? 'Login failed');

    }
  }

  /// Fetch Items API
  Future<List<Map<String, dynamic>>> fetchItems() async {
    final url = useDemoApi
        ? Uri.parse("$_jsonPlaceholderBase/posts")
        : Uri.parse("$_companyBase/items");

    try {
      final res = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          if (!useDemoApi) "x-api-key": _apiKey, // only for company API
        },
      );

      if (res.statusCode == 200) {
        final List<dynamic> arr = jsonDecode(res.body);
        return arr.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception("Failed to fetch items: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Items request failed: $e");
    }
  }
}
