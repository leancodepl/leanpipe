import 'dart:async';
import 'dart:convert';

import 'package:dispose_scope/dispose_scope.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:leancode_pipe/leancode_pipe.dart';
import 'package:leancode_pipe_example/auction_contracts.dart';
import 'package:logging/logging.dart';

part 'screen_cubit.freezed.dart';

class ScreenCubit extends Cubit<DraftScreenState> with DisposeScope {
  ScreenCubit(this._pipeClient)
      : super(
          const DraftScreenState.disconnected(authorized: true),
        );

  final PipeClient _pipeClient;

  static const _exampleAppUrl = 'https://leanpipe-example.test.lncd.pl';
  static const leanPipeExampleUrl = '$_exampleAppUrl/pipe';

  StreamSubscription<AuctionNotification>? _auctionPipeSub;

  static final _logger = Logger('DraftScreenCubit');

  PipeSubscription<AuctionNotification>? subscription;

  Future<void> connect() async {
    emit(
      DraftScreenState.disconnected(
        connecting: true,
        authorized: state.authorized,
      ),
    );
    try {
      await _pipeClient.connect();

      emit(
        DraftScreenState.connected(
          data: 'connected\n\n',
          authorized: state.authorized,
        ),
      );
    } catch (err) {
      emit(
        DraftScreenState.disconnected(
          error: DraftScreenError.unknown,
          authorized: state.authorized,
        ),
      );
    }
  }

  Future<void> disconnect() async {
    try {
      await _pipeClient.disconnect();
      emit(DraftScreenState.disconnected(authorized: state.authorized));
    } catch (err) {
      emit(
        DraftScreenState.disconnected(
          error: DraftScreenError.unknown,
          authorized: state.authorized,
        ),
      );
    }
  }

  void _emitWithDataIfConnected(String data) {
    final state = this.state;
    if (state is! DraftScreenConnected) {
      return;
    }

    emit(
      state.copyWith(
        data: '${state.data}$data\n\n',
      ),
    );
  }

  Future<void> subscribe() async {
    if (state is! DraftScreenConnected) {
      return;
    }

    subscription = await _pipeClient.subscribe(
      Auction('', state.authorized),
      onReconnect: () {
        _logger.fine('Downloading data after subscription reconnect');
      },
    );
    _auctionPipeSub = subscription?.listen(
      (notification) {
        _emitWithDataIfConnected(notification.toString());
      },
      cancelOnError: true,
      onDone: () => _emitWithDataIfConnected('Auction subscription finished'),
      onError: (dynamic error) => _emitWithDataIfConnected(
        'Auction subscription caught error: $error;\nClosing the subscription\n\n',
      ),
    );
  }

  void switchAuthorization() {
    emit(state.copyWith(authorized: !state.authorized));
  }

  Future<void> unsubscribe() async {
    final state = this.state;
    if (state is! DraftScreenConnected) {
      return;
    }

    await subscription?.unsubscribe();
  }

  Future<void> placeBid(int amount) async {
    await Client().post(
      Uri.parse(
        'https://leanpipe-example.test.lncd.pl/cqrs/command/LeanPipe.Example.Contracts.PlaceBid',
      ),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'AuctionId': '',
        'Amount': amount,
        'UserId': '',
      }),
    );
  }

  Future<void> buy() async {
    await Client().post(
      Uri.parse(
        'https://leanpipe-example.test.lncd.pl/cqrs/command/LeanPipe.Example.Contracts.Buy',
      ),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'AuctionId': '',
        'UserId': '',
      }),
    );
  }

  @override
  Future<void> close() async {
    await _auctionPipeSub?.cancel();
    return super.close();
  }
}

@freezed
class DraftScreenState with _$DraftScreenState {
  const factory DraftScreenState.connected({
    required String data,
    required bool authorized,
  }) = DraftScreenConnected;
  const factory DraftScreenState.disconnected({
    required bool authorized,
    @Default(false) bool connecting,
    DraftScreenError? error,
  }) = DraftScreenDisconnected;
}

enum DraftScreenError {
  unknown,
  network,
}
