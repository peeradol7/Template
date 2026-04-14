import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/create_user_request.dart';
import '../model/update_user_request.dart';
import '../model/user_model.dart';
import '../state/auth_state.dart';
import '../usecase/create_user_usecase.dart';
import '../usecase/delete_user_usecase.dart';
import '../usecase/get_user_usecase.dart';
import '../usecase/update_user_usecase.dart';

final authControllerProvider =
    NotifierProvider.autoDispose<AuthController, AuthState>(
  () => AuthController(),
);

class AuthController extends AutoDisposeNotifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> fetchUser(String id) async {
    state = state.copyWith(isLoading: true, errMsg: null);

    final result = await ref.read(getUserUsecaseProvider).execute(id);

    result.when(
      (success) {
        state = state.copyWith(isLoading: false, currentUser: success);
      },
      (error) {
        state = state.copyWith(isLoading: false, errMsg: error.toString());
      },
    );
  }

  Future<bool> createUser(CreateUserRequest request) async {
    state = state.copyWith(isSubmitting: true, errMsg: null);

    final result = await ref.read(createUserUsecaseProvider).execute(request);

    bool isSuccess = false;
    result.when(
      (success) {
        state = state.copyWith(isSubmitting: false);
        isSuccess = true;
      },
      (error) {
        state = state.copyWith(isSubmitting: false, errMsg: error.toString());
        isSuccess = false;
      },
    );
    return isSuccess;
  }

  Future<bool> updateUser(String id, UpdateUserRequest request) async {
    state = state.copyWith(isSubmitting: true, errMsg: null);

    final params = UpdateUserParams(id: id, request: request);
    final result = await ref.read(updateUserUsecaseProvider).execute(params);

    bool isSuccess = false;
    result.when(
      (success) {
        state = state.copyWith(isSubmitting: false);
        isSuccess = true;
        // Optionally fetch updated user
        fetchUser(id);
      },
      (error) {
        state = state.copyWith(isSubmitting: false, errMsg: error.toString());
        isSuccess = false;
      },
    );
    return isSuccess;
  }

  Future<bool> deleteUser(String id) async {
    state = state.copyWith(isSubmitting: true, errMsg: null);

    final result = await ref.read(deleteUserUsecaseProvider).execute(id);

    bool isSuccess = false;
    result.when(
      (success) {
        state = state.copyWith(isSubmitting: false, currentUser: null);
        isSuccess = true;
      },
      (error) {
        state = state.copyWith(isSubmitting: false, errMsg: error.toString());
        isSuccess = false;
      },
    );
    return isSuccess;
  }
}
