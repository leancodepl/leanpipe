import 'package:leancode_pipe/leancode_pipe.dart';
import 'package:leancode_pipe/leancode_pipe/create_hub_connection.dart';
import 'package:leancode_pipe/leancode_pipe/pipe_connection_state_mapper.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'common/mocks.dart';
import 'common/utils.dart';

void main() {
  group('SignalR HubConnection tests', () {
    late PipeClient client;
    late HubConnection connection;

    setUp(() {
      client = MockPipeClient();
      connection = createHubConnection(pipeUrl: pipeUrl);
    });

    test(
        'Underlying SignalR connection is initialized when connect() and'
        'closed when disconnect() called', () async {
      when(() => client.connect()).thenAnswer((_) async => connection.start());
      when(() => client.disconnect()).thenAnswer(
        (_) async => connection.stop(),
      );
      when(() => client.connectionState).thenAnswer(
        (_) => PipeConnectionStateMapper.fromHubConnectionState(
          connection.state,
        ),
      );

      expect(client.connectionState, PipeConnectionState.disconnected);

      await client.connect();

      expect(client.connectionState, PipeConnectionState.connected);

      await client.disconnect();

      expect(client.connectionState, PipeConnectionState.disconnected);
    });
  });

  group('PipeClient connection tests', () {
    late HubConnection connection;
    late Uuid uuid;
    late PipeClient client;
    late Topic topic;

    setUp(() {
      connection = MockHubConnection();
      uuid = MockUuid();
      client = PipeClient.fromMock(hubConnection: connection, uuid: uuid);
      topic = MockTopic();
    });

    test(
      'PipeClient will only start internal connection if connection state '
      'is disconnected',
      () async {
        final otherStates = HubConnectionState.values.toList()
          ..remove(HubConnectionState.disconnected);
        var currentState = otherStates.first;

        prepareConnect(connection);
        when(() => connection.state).thenAnswer((_) => currentState);

        // Check other than disconnected states
        for (final state in otherStates) {
          currentState = state;

          await client.connect();
          verifyNever(() => connection.start());
        }

        // Check disconnected state
        currentState = HubConnectionState.disconnected;

        await client.connect();

        verify(() => connection.start()).called(1);
      },
    );

    test(
      'PipeClient will only disconnect if connection state is not disconnected',
      () async {
        final otherStates = HubConnectionState.values.toList()
          ..remove(HubConnectionState.disconnected);
        var currentState = HubConnectionState.disconnected;

        prepareConnect(connection);
        when(() => connection.state).thenAnswer((_) => currentState);
        when(() => connection.stop()).thenAnswer((_) async {});

        // Check disconnected state
        await client.disconnect();
        verifyNever(() => connection.stop());

        // Check other than disconnected states
        for (var i = 0; i < otherStates.length; i++) {
          currentState = otherStates[i];

          // After each verification, the number of method calls resets to 0
          verifyNever(connection.stop);
          await client.disconnect();
          verify(connection.stop).called(1);
        }
      },
    );

    test(
      'PipeClient disposes internal subscriptions on '
      'disconnect() call',
      () async {
        // Prepare general config
        prepareConnect(connection);
        prepareTopic(topic);
        when(() => connection.state)
            .thenAnswer((_) => HubConnectionState.disconnected);

        // Connect to catch on subscription result method
        final onSubscriptionResultMethod = await captureOnSubscriptionResult(
          connect: client.connect,
          connection: connection,
        );

        // Prepare connection to simulate backend sending subscription confirmation
        prepareSubscribeToAnswerWithData(
          connection: connection,
          uuid: uuid,
          answerCallback: (subscribeResult) =>
              onSubscriptionResultMethod([subscribeResult.toJson()]),
        );

        // Get subscription with the same id as defined in `subscriptionResult`
        final subscription = await client.subscribe(topic);

        when(() => connection.state)
            .thenAnswer((_) => HubConnectionState.connected);

        final onClose = await captureOnClose(
          connect: client.connect,
          connection: connection,
        );
        when(() => connection.stop()).thenAnswer((_) async {
          await onClose(null);
        });

        var isSubscriptionDone = false;
        var isSubscriptionCanceled = false;
        final sub = subscription
            .doOnCancel(() => isSubscriptionDone = true)
            .doOnCancel(() => isSubscriptionCanceled = true)
            .listen((_) {});

        // Check disconnected state
        await client.disconnect();
        verify(() => connection.stop()).called(1);

        await sub.cancel();

        expect(isSubscriptionDone, true);
        expect(isSubscriptionCanceled, true);
      },
    );
  });
}
