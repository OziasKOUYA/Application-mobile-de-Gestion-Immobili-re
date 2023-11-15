import 'dart:convert';
import 'package:gestion_immobiliere/register/models/Utilisateur.dart';
import 'package:http/http.dart' as http;
import '../apiConstants.dart';


class RegisterService {

  Future<void> registerClient(Utilisateur utilisateur) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/clientRegister/');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(utilisateur.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Inscription réussie
      } else if (response.statusCode == 400) {
        // Nom d'utilisateur déjà pris
        throw Exception('Ce nom d\'utilisateur est déjà pris. Veuillez le modifier.');
      } else {
        // Erreur lors de l'inscription
        throw Exception('Erreur lors de l\'inscription du comptable');
      }
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future<void> registerGerant(Utilisateur utilisateur) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/gerantRegister/');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(utilisateur.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Inscription réussie
        print('Inscription artisan réussie');
      } else if (response.statusCode == 400) {
        // Nom d'utilisateur déjà pris
        throw ('Ce nom d\'utilisateur est déjà pris. Veuillez le modifier.');
      } else {
        // Erreur lors de l'inscription
        throw ('Erreur lors de l\'inscription de l\'artisan');
      }
    } catch (error) {
      throw ('$error');
    }
  }



  Future<Utilisateur> getClientById(int id) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/getClient/$id/');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print(responseBody);
        try {
          return Utilisateur.fromJson(responseBody);
        } catch (e) {
          final client =Utilisateur.fromJson(responseBody);
          print('ici$client');
          print("Erreur lors de la conversion de la réponse JSON en objet Client: $e");
          throw Exception('Erreur lors de la conversion de la réponse JSON en objet Client');
        }
      } else {
        throw Exception('Erreur lors de la récupération : ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erreur lors de la récupération de l\'artisan: $error');
    }
  }

  Future<Utilisateur> getGerantById(int id) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/getGerant/$id/');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        try {
          return Utilisateur.fromJson(responseBody);
        } catch (e) {
          final gerant =Utilisateur.fromJson(responseBody);
          print('ici$gerant');
          print("Erreur lors de la conversion de la réponse JSON en objet Gerant: $e");
          throw Exception('Erreur lors de la conversion de la réponse JSON en objet Gerant');
        }
      } else {
        throw Exception('Erreur lors de la récupération : ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erreur lors de la récupération de l\'artisan: $error');
    }
  }




}