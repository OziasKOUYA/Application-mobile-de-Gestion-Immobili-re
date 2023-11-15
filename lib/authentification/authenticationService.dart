import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../apiConstants.dart';
import '../connexion/apiService.dart';
import '../exceptions/authenticationException.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationService {
  final _controller = StreamController<AuthenticationStatus>();
  final storage = FlutterSecureStorage();
  

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    const url = '${ApiConstants.baseUrl}/login/';
    final body = {
      'username': username,
      'password': password
    };

    final response = await http.post(Uri.parse(url), body: body);
    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      final token = responseBody['jwt'];
      await storage.write(key: 'jwt', value: token);
      await storage.write(key: 'username', value: username);
      _controller.add(AuthenticationStatus.authenticated);
    } else if (response.statusCode == 401) {
      final errorMessage = responseBody['detail'] ;
      throw AuthenticationException(message: errorMessage);
    } else if (response.statusCode == 500) {
      throw AuthenticationException(message: 'Server error');
    } else {
      throw AuthenticationException(message: 'Failed to sign in');
    }
  }

  /*void logOut() async {
    const url = '${ApiConstants.baseUrl}/logout/';
    final response = await http.post(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${await storage.read(key: 'jwt')}',
    });

    if (response.statusCode == 200) {
      await storage.delete(key: 'jwt');
      await storage.delete(key: 'username');
      _controller.add(AuthenticationStatus.unauthenticated);
    } else {
      throw AuthenticationException(message: 'Failed to sign out');
    }
  }*/

  void logOut(BuildContext context) async {
    try {
      await ApiService.makeRequest('/logout/', context, method: 'POST'); // Ajouter le paramètre context ici
      await storage.delete(key: 'jwt');
      await storage.delete(key: 'username');
      _controller.add(AuthenticationStatus.unauthenticated);
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  void dispose() => _controller.close();
}
