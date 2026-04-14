import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_user_request.freezed.dart';
part 'create_user_request.g.dart';

@freezed
class CreateUserRequest with _$CreateUserRequest {
  const factory CreateUserRequest({
    required String username,
    required String email,
    required String password,
  }) = _CreateUserRequest;

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserRequestFromJson(json);
}
