import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/addPost_page/data/models/Comment.dart';
import 'package:tadaa/features/addPost_page/data/models/Post.dart';
import 'package:tadaa/features/addPost_page/domain/repositories/post_repository.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostEvent.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostState.dart';
import 'dart:io';

import 'package:tadaa/features/wallet_page/domain/repository/walletRepository.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;
  final WalletRepository _walletRepository;


PostBloc(this._postRepository, this._walletRepository) : super(PostInitial()) {

    on<CreatePostEvent>((event, emit) async {
      emit(PostLoading());
      try {
        String? imageUrl;
        if (event.imageFile != null) {
          // Upload the image and get the URL
          imageUrl = await _postRepository.uploadImage(event.imageFile!);
        }
        // Create the post with or without the image URL
        final postWithImage = event.post.copyWith(image: imageUrl);
        final postId = await _postRepository.createPost(postWithImage, event.userId);
        emit(PostCreateSuccess(postId));
      } catch (e) {
        emit(PostError('Failed to create post: $e'));
      }
    });

     on<UpdatePostEvent>((event, emit) async {
      emit(PostLoading());
      try {
        String? imageUrl;
        if (event.imageFile != null) {
          // Upload the new image and get the URL
          imageUrl = await _postRepository.uploadImage(event.imageFile!);
        }
        
        // Create the updated post with or without the new image URL
        final updatedPost = event.updatedPost.copyWith(image: imageUrl ?? event.updatedPost.image);
        
        await _postRepository.updatePost(event.postId, updatedPost);
        emit(PostUpdateSuccess()); // Create a PostUpdateSuccess state
      } catch (e) {
        emit(PostError('Failed to update post: $e'));
      }
    });

    /*on<FetchPostsEvent>((event, emit) async {
      emit(PostLoading());
      try {
        final posts = await _postRepository.fetchPostsByType(event.type);
        emit(PostFetchSuccess(posts));
      } catch (e) {
        emit(PostError('Failed to fetch posts: $e'));
      }
    });*/
   on<FetchAllPostsEvent>((event, emit) async {
  emit(PostLoading());
  try {
    final posts = await _postRepository.fetchAllPosts();
    emit(PostFetchSuccess(posts)); // Assuming your PostFetchSuccess accepts a single list of posts
  } catch (e) {
    emit(PostError('Failed to fetch posts: $e'));
  }
});

/*on<DeletePostEvent>((event, emit) async {
      emit(PostLoading());
      try {
        await _postRepository.deletePost(event.postId);
        // Optionally refetch posts if needed
        final posts = await _postRepository.fetchAllPosts();
        emit(PostFetchSuccess(posts)); // Emit the updated list of posts
      } catch (e) {
        emit(PostError('Failed to delete post: $e'));
      }
    });*/
    on<DeletePostEvent>((event, emit) async {
  emit(PostLoading());  // Emit loading state to show the progress indicator
  try {
    await _postRepository.deletePost(event.postId);
    
    // Emit success state after the post is deleted
    emit(PostDeleteSuccess()); 

    // Optionally, you can re-fetch the posts to update the list after deletion
    final posts = await _postRepository.fetchAllPosts();
    emit(PostFetchSuccess(posts));  // Emit the updated list of posts
  } catch (e) {
    emit(PostError('Failed to delete post: $e'));  // Emit error state if deletion fails
  }
});


    
    on<LikePostEvent>((event, emit) async {
 // emit(PostLoading());
  try {
    // Call the likePost method from your repository
    String result = await _postRepository.likePost(event.postId, event.uid);
    
    if (result == 'success') {
      // Assuming success means we don't need to do anything extra
     // emit(PostFetchSuccess([])); // This state could be different depending on your UI flow.
    } else {
      emit(PostError('Failed to like post'));
    }
  } catch (e) {
    emit(PostError('Error liking post: $e'));
  }
});

 
 on<AddCommentEvent>((event, emit) async {
      emit(PostLoading());
      try {
        await _postRepository.addComment(event.postId, event.comment,event.userId);
        emit(CommentAddSuccess());
      } catch (e) {
        emit(PostError('Failed to add comment: $e'));
      }
    });

   on<FetchCommentsEvent>((event, emit) async {
      emit(PostLoading());
      try {
        final comments = await _postRepository.fetchComments(event.postId);
        emit(PostCommentsFetchSuccess(comments));
      } catch (e) {
        emit(PostError('Failed to fetch comments: $e'));
      }
    });

    on<UpdateCommentEvent>((event, emit) async {
  emit(PostLoading());
  try {
    await _postRepository.updateComment(event.postId, event.commentId, event.newContent);
    emit(CommentAddSuccess());  // Emit success state after the comment is updated
  } catch (e) {
    emit(PostError('Failed to update comment: $e'));
  }
});
  
  on<LikeCommentEvent>((event, emit) async {
  try {
    // Call the likeComment method from your repository
    String result = await _postRepository.likeComment(event.postId, event.commentId, event.uid);
    
    if (result == 'success') {
      // Optionally, emit success state or perform any additional actions if needed
    } else {
      emit(PostError('Failed to like comment'));
    }
  } catch (e) {
    emit(PostError('Error liking comment: $e'));
  }
});



  on<FetchPostsByUserIdEvent>((event, emit) async {
  emit(PostLoading());
  try {
    final posts = await _postRepository.fetchPostsByUserId(event.userId);
    emit(PostUserFetchSuccess(posts));
  } catch (e) {
    emit(PostError('Failed to fetch posts: $e'));
  }
});


 

    


  }
}
