import 'package:bloc/bloc.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostState.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc(this.profileRepository) : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        UserModel user = await profileRepository.getUserProfile(event.uid);
        emit(ProfileLoaded(user));
        print('Profile loaded: ${user.points}');
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  
    on<UpdateBio>((event, emit) async {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        try {
          // Update the user's bio in the backend
          UserModel updatedUser = currentState.user.copyWith(aboutMe: event.bio);
          await profileRepository.updateUserProfile(updatedUser);
          
          // Emit the updated profile with the new bio
          emit(ProfileLoaded(updatedUser)); // Change back to ProfileLoaded with updated user
        } catch (e) {
          emit(ProfileError('Failed to update bio'));
        }
      } else {
        emit(ProfileError('Profile not loaded'));
      }
    });

    on<UpdateBirthday>((event, emit) async {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        try {
          // Update the user's birthday in the backend
          UserModel updatedUser = currentState.user.copyWith(birthday: event.birthday);
          await profileRepository.updateUserProfile(updatedUser);
          
          // Emit the updated profile with the new birthday
          emit(ProfileLoaded(updatedUser)); // Change back to ProfileLoaded with updated user
        } catch (e) {
          emit(ProfileError('Failed to update birthday'));
        }
      } else {
        emit(ProfileError('Profile not loaded'));
      }
    });

    on<UpdateProfilePicture>((event, emit) async {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        try {
          // Update the user's profile picture in the backend
          UserModel updatedUser = currentState.user.copyWith(profilePicture: event.profilePictureUrl);
          await profileRepository.updateUserProfile(updatedUser);

          // Emit the updated profile with the new profile picture
          emit(ProfileLoaded(updatedUser)); // Change back to ProfileLoaded with updated user
        } catch (error) {
          emit(ProfileError('Failed to update profile picture.'));
        }
      } else {
        emit(ProfileError('Profile not loaded'));
      }
    });
  
   

  }
}
