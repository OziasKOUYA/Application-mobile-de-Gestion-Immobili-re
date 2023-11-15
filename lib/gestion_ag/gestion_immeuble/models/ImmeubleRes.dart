import 'package:gestion_immobiliere/register/models/Utilisateur.dart';

class ImmeubleRes {
  int? id;
  String? code;
  String? description;
  Utilisateur? proprietaire;

  ImmeubleRes({this.id, this.code, this.description, this.proprietaire});

  factory ImmeubleRes.fromJson(Map<String, dynamic> json) {
    return ImmeubleRes(
      id: json['id'],
      code: json['code'],
      description: json['description'],
      proprietaire: Utilisateur.fromJson(json['proprietaire']),
    );
  }

}
