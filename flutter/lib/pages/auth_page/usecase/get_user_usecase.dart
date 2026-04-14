import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/usecase/usecase.dart';
import '../model/user_model.dart';
import '../service/auth_service_api.dart';

final getUserUsecaseProvider = Provider<GetUserUsecase>((ref) {
  final service = ref.watch(authServiceApiProvider);
  return GetUserUsecase(ref, service);
});

class GetUserUsecase extends UseCase<String, Result<UserModel>> {
  final AuthServiceApi _service;

  GetUserUsecase(Ref ref, this._service) {
    this.ref = ref;
  }

  @override
  Future<Result<UserModel>> execute(String id) async {
    try {
      final res = await _service.getUser(id);
      return Result.success(res);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
