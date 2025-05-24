// lib/data/providers/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/constants/api_constants.dart';

class ApiClient {
  final http.Client httpClient;
  final Duration timeout = const Duration(seconds: 10);

  ApiClient({required this.httpClient});

  // Adding query parameters, error handling, and timeout
  Future<List<dynamic>> getProducts({Map<String, String>? queryParams}) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/products').replace(
        queryParameters: queryParams,
      );

      final response = await httpClient.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body) as List;
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your connection.');
    } on FormatException {
      throw Exception('Invalid response format from server.');
    } on Exception catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Map<String, dynamic>> getProductById(int id) async {
    try {
      final response = await httpClient.get(
        Uri.parse('${ApiConstants.baseUrl}/products/$id'),
        headers: {'Accept': 'application/json'},
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        throw Exception('Failed to load product details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product details: $e');
    }
  }

  // Search functionality
  Future<List<dynamic>> searchProducts(String query) async {
    try {
      final response = await httpClient.get(
        Uri.parse('${ApiConstants.baseUrl}/products/search?q=$query'),
        headers: {'Accept': 'application/json'},
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body) as List;
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching products: $e');
    }
  }
}
