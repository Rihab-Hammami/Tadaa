import 'package:tadaa/features/profile_page/data/models/userModel.dart';

abstract class UserState  {}

class UserInitial extends UserState {}

class UsersLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<UserModel> users;

  UsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserError extends UserState {
  final String message;

   UserError(this.message);

  @override
  List<Object> get props => [message];
}
