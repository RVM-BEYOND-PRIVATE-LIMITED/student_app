import 'package:core_network/core_network.dart';

import '../api/student_api.dart';
import '../network/student_auth_interceptor.dart';
import 'student_session.dart';

/// Renews the student's access token through `POST /v1/auth/refresh`
/// (contract 0.1.0): the refresh token is used once, the reply is a new pair,
/// and both go back into [StudentSession].
///
/// The API is attached after the client exists: the client's auth interceptor
/// needs this renewer, and this renewer needs the client. Nothing renews
/// before [attach] runs, which happens when the client is first built.
class ApiSessionRenewer implements SessionRenewer {
  ApiSessionRenewer(this._session);

  final StudentSession _session;
  StudentApi? _api;

  void attach(StudentApi api) => _api = api;

  @override
  Future<bool> renew() async {
    final api = _api;
    if (api == null) return false;
    try {
      final refreshToken = await _session.refreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;
      final installId = await _session.installId();
      final pair = await api.refreshSession(
        refreshToken: refreshToken,
        installId: installId,
      );
      if (!pair.hasRefreshToken) return false;
      await _session.saveTokens(
        accessToken: pair.accessToken,
        refreshToken: pair.refreshToken,
      );
      return true;
    } on Failure {
      return false;
    } catch (_) {
      return false;
    }
  }
}
