import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadaa/features/sign_up_screen/domain/use_cases/verify_realm_use_case.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSignedUp extends SignUpState {
  final String realm;

  SignUpSignedUp(this.realm);
}

class SignUpVerified extends SignUpState {
  final String realm;

  SignUpVerified(this.realm);
}

class SignUpError extends SignUpState {
  final String message;

  SignUpError(this.message);
}

class SignUpBloc extends Cubit<SignUpState> {
  final VerifyRealmUseCase verifyRealmUseCase;

  SignUpBloc(this.verifyRealmUseCase) : super(SignUpInitial());

  void verifyRealm(String realm) async {
    emit(SignUpLoading());
    try {
      final isValid = await verifyRealmUseCase(realm);
      if (isValid) {
        emit(SignUpSignedUp(realm));
      } else {
        emit(SignUpError("Realm does not exist"));
      }
    } catch (e) {
      emit(SignUpError(e.toString()));
    }
  }

  void checkIfSignedUp() async {
    final prefs = await SharedPreferences.getInstance();
    final bool signedUp = prefs.getBool('signedUp') ?? false;
    final String? realm = prefs.getString('realm');

    if (signedUp && realm != null) {
      emit(SignUpVerified(realm));
    }
  }
}
