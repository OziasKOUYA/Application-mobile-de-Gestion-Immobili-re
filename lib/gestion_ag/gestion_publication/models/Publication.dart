class Publication {
  int? id;
  String? contenu;
  String? image;
  DateTime? datePublication;
  int? immeuble;

  Publication({
    this.id,
    this.contenu,
    this.image,
    this.datePublication,
    this.immeuble,
  });

  factory Publication.fromJson(Map<String, dynamic> json) {
    return Publication(
      id: json['id'],
      contenu: json['contenu'],
      image: json['image'],
      datePublication: json['date_publication'] != null
          ? DateTime.parse(json['date_publication'])
          : null,
      immeuble: json['immeuble'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contenu': contenu,
      'image':image,
      'date_publication': datePublication?.toIso8601String(),
      'immeuble': immeuble,
    };
  }
}
