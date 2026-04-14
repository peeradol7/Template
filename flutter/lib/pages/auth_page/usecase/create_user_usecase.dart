import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/usecase/usecase.dart';
import '../model/create_user_request.dart';
import '../service/auth_service_api.dart';

final createUserUsecaseProvider = Provider<CreateUserUsecase>((ref) {
  final service = ref.watch(authServiceApiProvider);
  return CreateUserUsecase(ref, service);
});

class CreateUserUsecase extends UseCase<CreateUserRequest, Result<dynamic>> {
  final AuthServiceApi _service;

  CreateUserUsecase(Ref ref, this._service) {
    this.ref = ref;
  }

  @override
  Future<Result<dynamic>> execute(CreateUserRequest request) async {
    try {
      final res = await _service.createUser(request);
      return Result.success(res);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
