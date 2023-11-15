import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../apiConstants.dart';
import '../../connexion/apiService.dart';
import 'models/Publication.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'models/PublicationRes.dart';

class PublicationService {
  Future<List<PublicationRes>> getPublications( BuildContext context) async {
    try {
      final response = await ApiService.makeRequest("/gestionAg/publications/", context, method: "GET");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((item) => PublicationRes.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load Publications');
      }
    } catch (e) {
      throw Exception('${e.toString()}');
    }
  }

  Future<void> addPublication(int idArtisan, Publication publication, BuildContext context,File? image) async {

    try {
      print(publication.toJson());
      print(image?.path!);
        final uri = Uri.parse('${ApiConstants.baseUrl}/gestionAg/publications/');
        final request = http.MultipartRequest('POST', uri);
        request.headers['Content-Type'] = 'multipart/form-data';
        request.fields['contenu'] =publication.contenu!;




        if (image != null) {
          await ApiConstants.uploadFileIfNotNull(image!, 'image', request);
        }
      request.fields['immeuble'] = publication.immeuble.toString();


      final response = await http.Response.fromStream(await request.send());


        if (response.statusCode >= 200 && response.statusCode < 300){
        print('Publication added successfully.');
      } else {
        throw Exception('Failed to add Publication.');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to add Publication: ${e.toString()}');
    }
  }

  Future<void> updatePublication(int idArtisan, Publication publication, BuildContext context) async {
    try {
      final response = await ApiService.makeRequest("/updatePublication/${publication.id}", context,
          body: jsonEncode(publication.toJson()), method: "PUT");

      if (response.statusCode >= 200 && response.statusCode < 300){
        print('publication update  successfully.');
      } else {
        throw Exception('Failed publication update ');
      }
    } catch (e) {
      throw Exception('Failed to update Publication: ${e.toString()}');
    }
  }

  Future<void> deletePublication(int id, BuildContext context) async {
    try {
      final response = await ApiService.makeRequest("/gestionAg/publications/$id/", context, method: "DELETE");
      print (response.statusCode);

      if (response.statusCode >= 200 && response.statusCode < 300){
        print('Supression Reussie.');
      } else {
        throw Exception('Echec suppression.');
      }
    } catch (e) {
      throw Exception('Failed to delete Publication: ${e.toString()}');
    }
  }
}
