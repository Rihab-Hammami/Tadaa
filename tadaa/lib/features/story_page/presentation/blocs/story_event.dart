import 'package:equatable/equatable.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';
import 'dart:io';

abstract class StoryEvent extends Equatable {
  const StoryEvent();

  @override
  List<Object?> get props => [];
}

// Event to handle adding a story, with optional image file
class AddStoryEvent extends StoryEvent {
  final StoryModel story;
  final File? imageFile; // Optional image file to upload

  const AddStoryEvent({required this.story, this.imageFile});

  @override
  List<Object?> get props => [story, imageFile];
}
class FetchStoriesByTypeEvent extends StoryEvent {
  final String type;

  const FetchStoriesByTypeEvent({required this.type});

  @override
  List<Object?> get props => [type];
}
class FetchAllStoriesEvent extends StoryEvent {}

class ViewStoryEvent extends StoryEvent {
  final String storyId;
  final String userId;

  const ViewStoryEvent({required this.storyId, required this.userId});

  @override
  List<Object?> get props => [storyId, userId];
}


class DeleteStoryEvent extends StoryEvent {
  final String storyId;
  final String? mediaUrl;  // Media URL if the story contains media

  const DeleteStoryEvent({required this.storyId, this.mediaUrl});

  @override
  List<Object?> get props => [storyId, mediaUrl];
}