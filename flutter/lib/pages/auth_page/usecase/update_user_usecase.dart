import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/usecase/usecase.dart';
import '../model/update_user_request.dart';
import '../service/auth_service_api.dart';

class UpdateUserParams {
  final String id;
  final UpdateUserRequest request;
  UpdateUserParams({required this.id, required this.request});
}

final updateUserUsecaseProvider = Provider<UpdateUserUsecase>((ref) {
  final service = ref.watch(authServiceApiProvider);
  return UpdateUserUsecase(ref, service);
});

class UpdateUserUsecase extends UseCase<UpdateUserParams, Result<dynamic>> {
  final AuthServiceApi _service;

  UpdateUserUsecase(Ref ref, this._service) {
    this.ref = ref;
  }

  @override
  Future<Result<dynamic>> execute(UpdateUserParams params) async {
    try {
      final res = await _service.updateUser(params.id, params.request);
      return Result.success(res);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
