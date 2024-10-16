import 'package:equatable/equatable.dart';

abstract class UserPostEvent extends Equatable {
  const UserPostEvent();

  @override
  List<Object> get props => [];
}

class FetchUserPosts extends UserPostEvent {
  final String userId;

  const FetchUserPosts(this.userId);

  @override
  List<Object> get props => [userId];
}
