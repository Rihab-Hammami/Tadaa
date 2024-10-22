// users_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/directory_page/presentation/blocs/users_event.dart';
import 'package:tadaa/features/directory_page/presentation/blocs/users_state.dart';

import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/user/userInfo.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ProfileRepository profileRepository;


  UserBloc(this.profileRepository) : super(UserInitial()) {
    on<FetchAllUsers>((event, emit) async {
      emit(UsersLoading());
      try {
        final uid = await UserInfo.getUserId();
        final users = await profileRepository.getAllUsers();
       final filteredUsers = users.where((user) => user.uid != uid).toList();
         emit(UsersLoaded(filteredUsers));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
