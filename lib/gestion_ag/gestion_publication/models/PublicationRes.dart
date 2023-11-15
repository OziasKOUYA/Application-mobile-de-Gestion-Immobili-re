import '../../gestion_immeuble/models/Immeuble.dart';
import '../../gestion_immeuble/models/ImmeubleRes.dart';

class PublicationRes {
  int? id;
  String? contenu;
  String? image;
  DateTime? datePublication;
  ImmeubleRes? immeuble;

  PublicationRes({
    this.id,
    this.contenu,
    this.image,
    this.datePublication,
    this.immeuble,
  });

  factory PublicationRes.fromJson(Map<String, dynamic> json) {
    return PublicationRes(
      id: json['id'],
      contenu: json['contenu'],
      image: json['image'],
      datePublication: DateTime.parse(json['date_publication']),
      immeuble: ImmeubleRes.fromJson(json['immeuble']),
    );
  }


}
