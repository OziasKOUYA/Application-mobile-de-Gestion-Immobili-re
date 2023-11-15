import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int idUser;
  final String username;
  final String password;
  final String email;
  final String role;

  const User({
    required this.idUser,
    required this.username,
    required this.password,
    required this.email,
    required this.role,
  });

  @override
  List<Object?> get props => [idUser, username, password, email, role];

  static const empty = User(
    idUser: 0,
    username: '',
    password: '',
    email: '',
    role: '',
  );

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      idUser: map['idUser']?.toInt() ?? 0,
      username: map['username']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      role: map['role']?.toString() ?? '',
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idUser,
      'username': username,
      'password': password,
      'email': email,
      'role': role,
    };
  }
}
