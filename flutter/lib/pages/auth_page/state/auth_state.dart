import 'package:freezed_annotation/freezed_annotation.dart';
import '../model/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    String? errMsg,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    UserModel? currentUser,
  }) = _AuthState;
}
