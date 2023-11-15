import 'dart:convert';
import '../apiConstants.dart';
import '../register/models/Utilisateur.dart';
import 'models/User.dart';
import 'package:http/http.dart' as http;



class UserService {


  Future<User?> getUser(String? token) async {
    if (token == null) {
      throw Exception('Token is null');
    }

    final url = Uri.parse('${ApiConstants.baseUrl}/userConnectedMobile/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print(responseBody);
      return User.fromMap(responseBody);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: check your JWT');
    } else if (response.statusCode == 404) {
      throw Exception('API endpoint not found');
    } else {
      throw Exception(
          'Failed to fetch user details: ${response.statusCode}, ${response
              .body}');
    }
  }
  Future<Utilisateur> getUtilisateurByUsername(String username) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/getArtisan/$username/');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        try {
          return Utilisateur.fromJson(responseBody);
        } catch (e) {
          final utilisateur =Utilisateur.fromJson(responseBody);
          throw Exception('Erreur lors de la conversion de la réponse JSON en objet User');
        }
      } else {
        throw Exception('Erreur lors de la récupération : ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erreur lors de la récupération de l\'artisan: $error');
    }
  }
}