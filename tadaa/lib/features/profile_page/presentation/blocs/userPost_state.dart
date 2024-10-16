import 'package:equatable/equatable.dart';
import 'package:tadaa/features/addPost_page/data/models/Post.dart';

abstract class UserPostState extends Equatable {
  const UserPostState();

  @override
  List<Object> get props => [];
}

class UserPostInitial extends UserPostState {}

class UserPostLoading extends UserPostState {}

class UserPostLoaded extends UserPostState {
  final List<PostModel> posts;

  const UserPostLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class UserPostError extends UserPostState {
  final String message;

  const UserPostError(this.message);

  @override
  List<Object> get props => [message];
}
