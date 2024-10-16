import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/addPost_page/domain/repositories/post_repository.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/userPost_event.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/userPost_state.dart';

class UserPostBloc extends Bloc<UserPostEvent, UserPostState> {
  final PostRepository postRepository;

  UserPostBloc(this.postRepository) : super(UserPostInitial()) {
    on<FetchUserPosts>((event, emit) async {
      emit(UserPostLoading());
      try {
        final posts = await postRepository.fetchPostsByUserId(event.userId);
        emit(UserPostLoaded(posts));
      } catch (e) {
        emit(UserPostError('Failed to fetch posts: $e'));
      }
    });
  }
}
