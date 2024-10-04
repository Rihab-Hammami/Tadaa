
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String name;
  final int points;
  final String role;
  final String username;

  User({
    required this.email,
    required this.name,
    required this.points,
    required this.role,
    required this.username,
  });

  @override
  List<Object?> get props => [email, name, points, role, username];
}
