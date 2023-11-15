class Immeuble {
  int? id;
  String? code;
  String? description;
  int? proprietaire;

  Immeuble({this.id, this.code, this.description, this.proprietaire});

  factory Immeuble.fromJson(Map<String, dynamic> json) {
    return Immeuble(
      id: json['id'] as int?,
      code: json['code'] as String?,
      description: json['description'] as String?,
      proprietaire: json['proprietaire'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'proprietaire': proprietaire,
    };
  }
}
