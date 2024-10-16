import 'package:equatable/equatable.dart';
import 'package:tadaa/features/addPost_page/data/models/Comment.dart';
import 'package:tadaa/features/addPost_page/data/models/Post.dart';
import 'dart:io';

abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreatePostEvent extends PostEvent {
  final PostModel post;
  final File? imageFile;
  final String userId; 

  CreatePostEvent( {required this.post, required this.imageFile,required this.userId,});

  

  @override
  List<Object?> get props => [post, imageFile];
}
class UpdatePostEvent extends PostEvent {
  final String postId;
  final PostModel updatedPost;
  final File? imageFile;
  UpdatePostEvent({required this.postId, required this.updatedPost,required this.imageFile,});

  @override
  List<Object?> get props => [postId, updatedPost];
}


class FetchAllPostsEvent extends PostEvent {}


class LikePostEvent extends PostEvent {
  final String postId;
  final String uid;  // User ID who liked the post

  LikePostEvent({required this.postId, required this.uid});

  @override
  List<Object?> get props => [postId, uid];
}


class AddCommentEvent extends PostEvent {
  final String postId;          
  final CommentModel comment;    
  final String userId; 
  AddCommentEvent({required this.postId, required this.comment,required this.userId });

  @override
  List<Object?> get props => [postId, comment,userId];
}
class FetchCommentsEvent extends PostEvent {
  final String postId;

  FetchCommentsEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class DeletePostEvent extends PostEvent {
  final String postId;

  DeletePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}


class UpdateCommentEvent extends PostEvent {
  final String postId;       
  final String commentId;    
  final String newContent;   

  UpdateCommentEvent({required this.postId, required this.commentId, required this.newContent});

  @override
  List<Object?> get props => [postId, commentId, newContent];
}
class LikeCommentEvent extends PostEvent {
  final String postId;
  final String commentId;
  final String uid;

  LikeCommentEvent({
    required this.postId,
    required this.commentId,
    required this.uid,
  });

  @override
  List<Object?> get props => [postId, commentId, uid];
}

