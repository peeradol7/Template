import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_response.freezed.dart';
part 'pagination_response.g.dart';

@Freezed(genericArgumentFactories: true)
class PaginationResponse<T> with _$PaginationResponse<T> {
  const factory PaginationResponse({
    @Default([]) List<T> items,
    required int pageNumber,
    required int totalPages,
    required int totalCount,
    @Default(false) bool hasPreviousPage,
    @Default(false) bool hasNextPage,
  }) = _PaginationResponse<T>;

  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PaginationResponseFromJson(json, fromJsonT);
}
