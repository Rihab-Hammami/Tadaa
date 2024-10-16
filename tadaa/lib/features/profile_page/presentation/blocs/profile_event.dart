import 'package:tadaa/features/profile_page/data/models/userModel.dart';

abstract class ProfileEvent {}

class FetchProfile extends ProfileEvent {
  final String uid;

  FetchProfile(this.uid);
}
class UpdateBio extends ProfileEvent {
  final String bio;

  UpdateBio(this.bio);
}
class UpdatePosition extends ProfileEvent {
  final String position;

  UpdatePosition(this.position);
}

class UpdateBirthday extends ProfileEvent {
  final DateTime birthday;

  UpdateBirthday(this.birthday);
}

class UpdateProfilePicture extends ProfileEvent {
  final String profilePictureUrl;

  UpdateProfilePicture(this.profilePictureUrl);

}
//class FetchAllUsers extends ProfileEvent {}

