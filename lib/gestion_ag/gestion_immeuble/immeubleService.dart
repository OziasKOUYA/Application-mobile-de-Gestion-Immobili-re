import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../connexion/apiService.dart';
import 'models/Immeuble.dart';



class ImmeubleService {
  Future<List<Immeuble>> getImmeubles(int id, BuildContext context) async {
    try {
      final response = await ApiService.makeRequest("/getAllImmeubles/$id", context, method: "GET");
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((item) => Immeuble.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load Immeubles');
      }
    } catch (e) {
      throw Exception('${e.toString()}');
    }
  }

  Future<void> addImmeuble(int idArtisan, Immeuble immeuble, BuildContext context) async {
    try {
      final response = await ApiService.makeRequest("/addImmeuble/$idArtisan", context,
          body: jsonEncode(immeuble.toJson()), method: "POST");

      if (response.statusCode == 200) {
        print('Immeuble added successfully.');
      } else {
        throw Exception('Failed to add Immeuble.');
      }
    } catch (e) {
      throw Exception('Failed to add Immeuble: ${e.toString()}');
    }
  }

  Future<void> updateImmeuble(int idArtisan, Immeuble immeuble, BuildContext context) async {
    try {
      final response = await ApiService.makeRequest("/updateImmeuble/${immeuble.id}", context,
          body: jsonEncode(immeuble.toJson()), method: "PUT");

      if (response.statusCode != 200) {
        throw Exception('Failed to update Immeuble');
      }
    } catch (e) {
      throw Exception('Failed to update Immeuble: ${e.toString()}');
    }
  }

  Future<void> deleteImmeuble(int id, BuildContext context) async {
    try {
      final response = await ApiService.makeRequest("/deleteImmeuble/$id", context, method: "DELETE");

      if (response.statusCode != 200) {
        throw Exception('Failed to delete Immeuble');
      }
    } catch (e) {
      throw Exception('Failed to delete Immeuble: ${e.toString()}');
    }
  }
}
