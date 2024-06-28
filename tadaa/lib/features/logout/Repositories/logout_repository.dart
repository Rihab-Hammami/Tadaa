import 'package:tadaa/features/logout/data/logout_service.dart';

class LogoutRepository {
  final LogoutService _logoutService;

  LogoutRepository(this._logoutService);

  Future<bool> logout(String realm, String refreshToken) async {
    return await _logoutService.logout(realm, refreshToken);
  }
}
