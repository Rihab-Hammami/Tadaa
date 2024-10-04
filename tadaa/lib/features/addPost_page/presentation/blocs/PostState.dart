import 'package:equatable/equatable.dart';
import 'package:tadaa/features/addPost_page/data/models/Comment.dart';
import 'package:tadaa/features/addPost_page/data/models/Post.dart';

abstract class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostCreateSuccess extends PostState {
  final String postId;

  PostCreateSuccess(this.postId);

  @override
  List<Object?> get props => [postId];
}

class ImageUploadSuccess extends PostState {
  final String imageUrl;

  ImageUploadSuccess(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}
class PostUpdateSuccess extends PostState {}


class PostFetchSuccess extends PostState {
  final List<PostModel> posts;

  PostFetchSuccess(this.posts);

  @override
  List<Object?> get props => [posts];
}
class PostUserFetchSuccess extends PostState {
  final List<PostModel> posts;

  PostUserFetchSuccess(this.posts);
   @override
  List<Object?> get props => [posts];
}


class CommentAddSuccess extends PostState {}
class PostCommentsFetchSuccess extends PostState {
  final List<CommentModel> comments;

  PostCommentsFetchSuccess(this.comments);

  @override
  List<Object?> get props => [comments];
}

class PostDeleteSuccess extends PostState {}
class PostError extends PostState {
  final String message;

  PostError(this.message);

  @override
  List<Object?> get props => [message];
}
