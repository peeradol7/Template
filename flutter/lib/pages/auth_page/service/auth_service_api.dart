import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../model/create_user_request.dart';
import '../model/update_user_request.dart';
import '../model/user_model.dart';
import '../../../core/network/network_service.dart';

part 'auth_service_api.g.dart';

final authServiceApiProvider = Provider<AuthServiceApi>((ref) {
  final dio = ref.watch(networkServiceProvider);
  return AuthServiceApi(dio);
});

@RestApi()
abstract class AuthServiceApi {
  factory AuthServiceApi(Dio dio) = _AuthServiceApi;

  @POST('/api/auth')
  Future<dynamic> createUser(
    @Body() CreateUserRequest request,
  );

  @GET('/api/auth/{id}')
  Future<UserModel> getUser(
    @Path('id') String id,
  );

  @PUT('/api/auth/{id}')
  Future<dynamic> updateUser(
    @Path('id') String id,
    @Body() UpdateUserRequest request,
  );

  @DELETE('/api/auth/{id}')
  Future<void> deleteUser(
    @Path('id') String id,
  );
}
