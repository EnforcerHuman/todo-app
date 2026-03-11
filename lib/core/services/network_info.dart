import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../error/app_exception.dart';

abstract class NetworkInfo {
  Future<void> ensureConnected();
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({InternetConnection? internetConnection})
    : _internetConnection = internetConnection ?? InternetConnection();

  final InternetConnection _internetConnection;

  @override
  Future<void> ensureConnected() async {
    final hasInternetAccess = await _internetConnection.hasInternetAccess;

    if (!hasInternetAccess) {
      throw AppException(
        'No internet connection. Check your network and try again.',
      );
    }
  }
}
