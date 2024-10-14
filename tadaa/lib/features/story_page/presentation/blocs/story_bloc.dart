import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/story_page/domain/repositories/storyRepository.dart';
import 'package:tadaa/features/story_page/presentation/blocs/story_event.dart';
import 'package:tadaa/features/story_page/presentation/blocs/story_state.dart';


class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryRepository storyRepository;

  StoryBloc( {required this.storyRepository}) : super(StoryInitial()) {
    // Handling the AddStoryEvent
    on<AddStoryEvent>((event, emit) async {
      emit(StoryAdding()); // Emit loading state

      try {
        // Call repository to add the story to Firestore
        await storyRepository.addStory(event.story, event.imageFile);

        // Emit success state once the story is added
        emit(StoryAdded(story: event.story));
      } catch (e) {
        // Emit error state if something goes wrong
        emit(StoryError(error: e.toString()));
      }
    });
    
    on<FetchStoriesByTypeEvent>((event, emit) async {
  emit(StoryLoading());
  
  try {
    final stories = await storyRepository.fetchStoriesByType(event.type);
    emit(StoryLoaded(stories: stories));
  } catch (e) {
    emit(StoryError(error: e.toString()));
  }
});
 on<FetchAllStoriesEvent>((event, emit) async {
      emit(StoryLoading()); // Emit loading state

      try {
        // Call repository to fetch all stories
        final stories = await storyRepository.fetchAllStories();
        
        // Emit success state with the fetched stories
        emit(StoryLoaded(stories: stories));
      } catch (e) {
        // Emit error state if something goes wrong
        emit(StoryError(error: e.toString()));
      }
    });

 on<ViewStoryEvent>((event, emit) async {
      emit(StoryLoading()); // Emit loading state

      try {
        // Call repository to view the story
        await storyRepository.viewStory(event.storyId, event.userId);

        // Emit success state after viewing the story
        emit(StoryViewed(storyId: event.storyId));
      } catch (e) {
        // Emit error state if something goes wrong
        emit(StoryError(error: e.toString()));
      }
    });

    on<DeleteStoryEvent>((event, emit) async {
  emit(StoryLoading()); // Emit loading state

  try {
    // Call repository to delete the story
    await storyRepository.deleteStory(event.storyId, event.mediaUrl);

    // Emit success state after the story is deleted
    emit(StoryDeleted(storyId: event.storyId));
  } catch (e) {
    // Emit error state if something goes wrong
    emit(StoryError(error: e.toString()));
  }
});
     
  }
}
