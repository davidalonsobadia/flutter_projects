import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../exceptions/login_backend_client_exceptions.dart';
import '../models/user_data.dart';

class LoginBackendClient {
  final String _baseAddress;

  LoginBackendClient(this._baseAddress);

  Future<http.Response> registerUser(UserData userData) async {
    return await _post(userData);
  }

  Future<UserData> getUserByIdToken(String idToken) async {
    final response = await _get(idToken);

    return UserData.fromJson(json.decode(response.body));
  }

  Future<http.Response> _post(UserData userData) async {
    final url = Uri.http(_baseAddress, '/register');
    try {
      final response = await http.post(
        url,
        body: json.encode(userData.toJson()),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
      return returnResponseOrThrowException(response);
    } on IOException {
      throw NetworkException('There was a Network disruption. Please try again later.');
    }
  }

  Future<http.Response> _get(String idToken) async {
    final url = Uri.http(_baseAddress, '/user');
    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Token $idToken',
        },
      );

      return returnResponseOrThrowException(response);
    } on IOException {
      throw NetworkException('There was a Network disruption. Please try again later.');
    }
  }

  http.Response returnResponseOrThrowException(http.Response response) {
    if (response.statusCode == 404) {
      throw ItemNotFoundException(
          'The item was not found in our current Database. Please contact our administrator.');
    } else if (response.statusCode > 400) {
      throw UnKnowApiException(
          response.statusCode, 'There was an unexpected error from our servers. Please try again later.');
    } else {
      return response;
    }
  }
}
