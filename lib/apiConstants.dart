import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
class ApiConstants {
  //static const String baseUrl = "http://cpa.pythonanywhere.com";
  static const String baseUrl = 'http://10.0.2.2:8000';
  static Future<void> uploadFileIfNotNull(File file, String fieldName, http.MultipartRequest request) async {
    if (file != null) {
      final fileStream = http.ByteStream(Stream.castFrom(file.openRead()));
      final fileLength = await file.length();

      // Créer un champ de fichier multipart
      final multipartFile = http.MultipartFile(
        fieldName,
        fileStream,
        fileLength,
        filename: file.path,
      );

      // Ajouter le fichier à la demande multipart
      request.files.add(multipartFile);
    }
  }
}
abstract class PdfLoaderService {
  Future<String?> fetchAndSavePDF(int idArtisan, BuildContext context);
}
