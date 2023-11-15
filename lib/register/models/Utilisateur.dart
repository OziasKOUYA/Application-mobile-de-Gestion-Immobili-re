class Utilisateur {
  int? id;
  String? username;
  String? nom;
  String? prenom;
  String? email;
  String? telephone;
  String? password;

  Utilisateur({
    this.id,
    this.username,
    this.nom,
    this.prenom,
    this.email,
    this.telephone,
    this.password,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'] as int?,
      username: json['username'] as String?,
      nom: json['nom'] as String?,
      prenom: json['prenom'] as String?,
      email: json['email'] as String?,
      telephone: json['telephone'] as String?,
      password: json['password'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'password': password,
    };
  }
}
