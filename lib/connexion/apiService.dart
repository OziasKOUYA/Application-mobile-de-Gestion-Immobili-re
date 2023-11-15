import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../apiConstants.dart';
import 'connexionUtils.dart';

class ApiService {
  static Future<http.Response> makeRequest(
      String endpoint,
      BuildContext context, {
        String? body,
        required String method,
      }) async {
    final isConnected = await InternetConnectivity.isConnected();
    if (!isConnected) {
      // Gérez le cas où il n'y a pas de connexion Internet ici
      throw Exception("Pas de connexion Internet.");
    }

    final fullUrl = "${ApiConstants.baseUrl}$endpoint";
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    http.Response response;
    if (method == "POST") {
      response = await http.post(Uri.parse(fullUrl), headers: headers, body: body);
    } else if (method == "GET") {
      response = await http.get(Uri.parse(fullUrl), headers: headers);
    } else if (method == "PUT") {
      response = await http.put(Uri.parse(fullUrl), headers: headers, body: body);
    } else if (method == "DELETE") {
      response = await http.delete(Uri.parse(fullUrl), headers: headers);
    } else {
      throw Exception("Méthode HTTP non prise en charge : $method");
    }

    return response;
  }
}
