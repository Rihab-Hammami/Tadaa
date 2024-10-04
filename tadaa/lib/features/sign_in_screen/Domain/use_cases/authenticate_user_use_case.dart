
import 'package:tadaa/features/sign_in_screen/data/repositories/authentication_repository.dart';

class AuthenticateUserUseCase {
  final AuthenticationRepository _repository;

  AuthenticateUserUseCase(this._repository);

  Future<Map<String, dynamic>> execute(String realm, String username, String password,) async {
    try {
      final response = await _repository.signIn(realm, username, password);
      return response;
    } catch (e) {
      rethrow; 
    }
  } 
}
