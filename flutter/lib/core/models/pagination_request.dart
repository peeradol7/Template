import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_request.freezed.dart';
part 'pagination_request.g.dart';

@freezed
class PaginationRequest with _$PaginationRequest {
  const factory PaginationRequest({
    @Default(1) int pageNumber,
    @Default(10) int pageSize,
    String? keyword,
  }) = _PaginationRequest;

  factory PaginationRequest.fromJson(Map<String, dynamic> json) =>
      _$PaginationRequestFromJson(json);
}
