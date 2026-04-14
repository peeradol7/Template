import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/usecase/usecase.dart';
import '../service/auth_service_api.dart';

final deleteUserUsecaseProvider = Provider<DeleteUserUsecase>((ref) {
  final service = ref.watch(authServiceApiProvider);
  return DeleteUserUsecase(ref, service);
});

class DeleteUserUsecase extends UseCase<String, Result<void>> {
  final AuthServiceApi _service;

  DeleteUserUsecase(Ref ref, this._service) {
    this.ref = ref;
  }

  @override
  Future<Result<void>> execute(String id) async {
    try {
      await _service.deleteUser(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
