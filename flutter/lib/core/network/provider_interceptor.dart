import 'dart:async';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../local_storage/app_shared_preferences.dart';
import '../widgets/base_toast.dart';
import '../router/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProviderInterceptor extends Interceptor {
  static Completer<String?>? _tokenRefreshCompleter;

  final GlobalKey<NavigatorState> navigatorKey;

  ProviderInterceptor({required this.navigatorKey});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await AppSharedPreferences.getAccessToken;

      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      debugPrint('Error in onRequest: $e');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response != null) {
      final statusCode = err.response?.statusCode;
      debugPrint("Status code: $statusCode");

      if (statusCode == 498) {
        await forceLogout();
      } else if (statusCode == 401) {
        final newToken = await _getUpdatedToken();
        if (newToken != null) {
          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final response = await Dio().fetch(requestOptions);
          return handler.resolve(response);
        }
      } else if (statusCode == 403) {
        final context = navigatorKey.currentContext;
        if (context != null) {
          BaseToast.showError(message: 'Permission denied (403)');
          context.go('/auth');
        }
      }
      return handler.resolve(err.response!);
    } else {
      return super.onError(err, handler);
    }
  }

  Future<String?> _getUpdatedToken() async {
    if (_tokenRefreshCompleter != null) {
      return _tokenRefreshCompleter!.future;
    }

    _tokenRefreshCompleter = Completer<String?>();

    try {
      final token = await AppSharedPreferences.getAccessToken;
      if (token.isEmpty || JwtDecoder.isExpired(token)) {
        final newToken = await _refreshToken();

        if (newToken == null) {
          throw Exception("Refresh token returned null");
        }

        _tokenRefreshCompleter?.complete(newToken);
        return newToken;
      } else {
        _tokenRefreshCompleter?.complete(token);
        return token;
      }
    } catch (e) {
      debugPrint("Error in _getUpdatedToken: $e");
      _tokenRefreshCompleter?.completeError(e);
      await forceLogout();
    } finally {
      _tokenRefreshCompleter = null;
    }

    return null;
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await AppSharedPreferences.getRefreshToken;

      if (refreshToken.isNotEmpty) {
        final baseUrl = dotenv.env['API_URL'] ?? "http://localhost:5197";
        final response = await Dio().post(
          '$baseUrl/api/auth/renew', // Your refresh token endpoint
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200 && response.data != null) {
          final data = response.data;

          final newAccessToken = data['accessToken'] ?? "";
          final newRefreshToken = data['refreshToken'] ?? "";

          await AppSharedPreferences.setAccessToken(newAccessToken);
          await AppSharedPreferences.setRefreshToken(newRefreshToken);

          debugPrint("Access token successfully refreshed ✅");
          return newAccessToken;
        } else if (response.statusCode == 498) {
          await forceLogout();
        }
      }
    } catch (e) {
      debugPrint("Error in refreshing token: $e");
      await forceLogout();
    }

    return null;
  }

  Future<void> forceLogout() async {
    await AppSharedPreferences.clearAll();
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.go('/auth'); // Redirect to login page
    }
  }
}
