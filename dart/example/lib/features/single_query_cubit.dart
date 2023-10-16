import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_contracts/leancode_contracts.dart';

typedef FutureFactory<T> = Future<QueryResult<T>> Function();

class SingleQueryCubit<T> extends Cubit<SingleQueryState<T>> {
  SingleQueryCubit({required FutureFactory<T> fetch})
      : _fetch = fetch,
        super(const SingleQueryLoading());

  final FutureFactory<T> _fetch;

  Future<void> fetch() async {
    emit(const SingleQueryLoading());

    final response = await _fetch();

    switch (response) {
      case QuerySuccess(:final data):
        emit(SingleQuerySuccess(data: data));
      case QueryFailure(:final error):
        emit(SingleQueryError(error: error));
    }
    if (response case QuerySuccess(:final data)) {
      emit(SingleQuerySuccess(data: data));
    }
  }
}

sealed class SingleQueryState<T> {
  const SingleQueryState();
}

class SingleQuerySuccess<T> extends SingleQueryState<T> {
  const SingleQuerySuccess({required this.data});

  final T data;
}

class SingleQueryLoading<T> extends SingleQueryState<T> {
  const SingleQueryLoading();
}

class SingleQueryError<T> extends SingleQueryState<T> {
  const SingleQueryError({required this.error});

  final QueryError error;
}
