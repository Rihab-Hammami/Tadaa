import 'package:tadaa/features/addPost_page/data/models/Post.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;

  ProfileLoaded(this.user);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
class ProfileBioUpdated extends ProfileState {
  final String bio;

  ProfileBioUpdated(this.bio);
}

class ProfileBirthdayUpdated extends ProfileState {
  final DateTime birthday;

  ProfileBirthdayUpdated(this.birthday);
}

class ProfilePictureUpdated extends ProfileState {
  final String profilePictureUrl;

  ProfilePictureUpdated(this.profilePictureUrl);
}
/*class UsersLoading extends ProfileState {}
class UsersLoaded extends ProfileState {
  final List<UserModel> users;

  UsersLoaded(this.users);
}*/
class PostUserFetchSuccess extends ProfileState{
  final List<PostModel> posts;
  PostUserFetchSuccess(this.posts);
}