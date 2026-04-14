import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../router/app_router.dart';
import 'provider_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final networkServiceProvider = Provider<Dio>((ref) {
  final navigatorKey = ref.read(navigatorKeyProvider);

  final options = BaseOptions(
    baseUrl: dotenv.env['API_URL'] ?? 'http://localhost:5197', // Target backend url from .env
    connectTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    contentType: Headers.jsonContentType,
    headers: {Headers.acceptHeader: Headers.jsonContentType},
  );

  final dio = Dio(options)
    ..interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      ProviderInterceptor(navigatorKey: navigatorKey),
    ]);

  return dio;
});
