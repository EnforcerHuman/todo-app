import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../error/app_exception.dart';
import '../services/network_info.dart';

class ApiService {
  ApiService({required http.Client client, required NetworkInfo networkInfo})
    : _client = client,
      _networkInfo = networkInfo;

  static const _timeout = Duration(seconds: 15);

  final http.Client _client;
  final NetworkInfo _networkInfo;

  Future<http.Response> get(Uri uri) {
    return _send(() => _client.get(uri));
  }

  Future<http.Response> post(Uri uri, {Map<String, dynamic>? body}) {
    return _send(() => _client.post(uri, body: _encodeBody(body)));
  }

  Future<http.Response> patch(Uri uri, {Map<String, dynamic>? body}) {
    return _send(() => _client.patch(uri, body: _encodeBody(body)));
  }

  Future<http.Response> delete(Uri uri) {
    return _send(() => _client.delete(uri));
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    await _networkInfo.ensureConnected();

    try {
      return await request().timeout(_timeout);
    } on SocketException {
      throw AppException(
        'Network request failed. Check your internet connection and try again.',
      );
    } on TimeoutException {
      throw AppException(
        'The request timed out. Check your connection and try again.',
      );
    }
  }

  String? _encodeBody(Map<String, dynamic>? body) {
    if (body == null) {
      return null;
    }
    return jsonEncode(body);
  }
}
