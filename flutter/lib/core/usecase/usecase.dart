import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class UseCase<Req, Res> {
  late Ref ref;
  Future<Res> execute(Req request);
}

class Result<T> {
  final T? data;
  final Exception? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  void when(
    void Function(T success) onSuccess,
    void Function(Exception error) onError,
  ) {
    if (error != null) {
      onError(error!);
    } else if (data != null) {
      onSuccess(data as T);
    }
  }
}
