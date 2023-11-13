import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String username;
  final String role;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    this.role = 'user',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      username: json['username'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'username': username,
        'role': role,
      };

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        username,
        role,
      ];
}
