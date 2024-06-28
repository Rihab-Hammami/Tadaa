import 'package:tadaa/features/sign_up_screen/domain/repositories/realm_repository.dart';

class VerifyRealmUseCase {
  final RealmRepository repository;

  VerifyRealmUseCase(this.repository);

  Future<bool> call(String realm) async {
    return await repository.verifyRealm(realm);
  }
}
