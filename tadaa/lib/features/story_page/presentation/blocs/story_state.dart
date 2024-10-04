import 'package:equatable/equatable.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';


abstract class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object?> get props => [];
}

class StoryInitial extends StoryState {}


class StoryAdding extends StoryState {}

// State when a story has been successfully added
class StoryAdded extends StoryState {
  final StoryModel story;

  const StoryAdded({required this.story});

  @override
  List<Object?> get props => [story];
}
class StoryLoading extends StoryState {}

// State when stories are successfully loaded
class StoryLoaded extends StoryState {
  final List<StoryModel> stories;
  StoryLoaded({required this.stories});
}

class StoryViewed extends StoryState {
  final String storyId;

  const StoryViewed({required this.storyId});

  @override
  List<Object?> get props => [storyId];
}


// State when there's an error while adding a story
class StoryError extends StoryState {
  final String error;

  const StoryError({required this.error});

  @override
  List<Object?> get props => [error];
}

