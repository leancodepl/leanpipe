import 'package:leancode_pipe/leancode_pipe/pipe_connection_state.dart';
import 'package:leancode_pipe/signalr_core/signalr_core.dart';

abstract final class PipeConnectionStateMapper {
  static PipeConnectionState fromHubConnectionState(
    HubConnectionState? state,
  ) =>
      switch (state) {
        HubConnectionState.disconnected => PipeConnectionState.disconnected,
        HubConnectionState.connecting => PipeConnectionState.connecting,
        HubConnectionState.connected => PipeConnectionState.connected,
        HubConnectionState.reconnecting => PipeConnectionState.reconnecting,
        HubConnectionState.disconnecting => PipeConnectionState.disconnecting,
        null => PipeConnectionState.disconnected,
      };
}
