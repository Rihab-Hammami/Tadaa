import 'package:tadaa/features/sign_up_screen/data/data_sources/realm_api.dart.dart';
import 'package:tadaa/features/sign_up_screen/domain/repositories/realm_repository.dart';

class RealmRepositoryImpl implements RealmRepository {
  final RealmApi api;

  RealmRepositoryImpl(this.api);

  @override
  Future<bool> verifyRealm(String realm) async {
    return await api.verifyRealm(realm);
  }
}
