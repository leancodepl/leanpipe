// In many places we wait for TimeoutException from the pipe client.
// Currently default signalR timeout is set to 30s. We had to increase the
// default test timeout from 30s to 60s to let those TimeoutExceptions occur
@Timeout(Duration(seconds: 60))
library;

import 'dart:async';

import 'package:leancode_pipe/leancode_pipe.dart';
import 'package:leancode_pipe/leancode_pipe/contracts/contracts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'common/mocks.dart';
import 'common/utils.dart';
import 'common/wait.dart';

void main() {
  group('PipeClient subscribe() tests', () {
    late HubConnection connection;
    late Uuid uuid;
    late PipeClient client;
    late Topic<String> topic;

    setUp(() {
      connection = MockHubConnection();
      uuid = MockUuid();
      client = PipeClient.fromMock(hubConnection: connection, uuid: uuid);
      topic = MockTopic();
    });

    group('Topic not registered before', () {
      test(
          'If topic is not registered before, subscribe() returns a valid '
          'pipe subscription', () async {
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

        verifySubscribeCalled(connection);
        expect(subscription, isA<PipeSubscription<String>>());
      });

      test(
          'If topic is not registered and backend service does not respond, '
          'subscribe() throws a TimeoutException', () async {
        // Prepare general config
        prepareConnect(connection);
        prepareTopic(topic);
        when(() => uuid.v1()).thenReturn('');
        when(() => uuid.v4()).thenReturn('');
        when(() => connection.state)
            .thenAnswer((_) => HubConnectionState.disconnected);

        // Simulate no response from backend (no onSubscriptionResult call)
        when(
          () => connection.send(
            methodName: 'SubscribeAsync',
            args: any(named: 'args'),
          ),
        ).thenAnswer((_) async {});

        await expectLater(
          () async => client.subscribe(topic),
          throwsA(const TypeMatcher<TimeoutException>()),
        );
      });
    });

    group('Topic already registered before', () {
      test(
          'If there is an ongoing subscription for the topic then any '
          'subscribe() calls for the same topic will only wait for the first '
          'subscription to complete and return pipe subscription without calling'
          'the backend service', () async {
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

        // We want to answer to the subscription only once because internal logic
        // should block any other subscription requests, waiting for the first
        // subscription to complete instead
        var isFirstAnswerToSubscribeRequest = true;

        // Prepare connection to simulate backend sending subscription confirmation
        prepareSubscribeToAnswerWithData(
          connection: connection,
          uuid: uuid,
          answerCallback: (subscribeResult) async {
            if (isFirstAnswerToSubscribeRequest) {
              isFirstAnswerToSubscribeRequest = false;

              await wait(seconds: 4);
              await onSubscriptionResultMethod([subscribeResult.toJson()]);
            }
          },
        );

        await Future.wait([
          () async {
            await client.subscribe(topic);
            verifySubscribeCalled(connection);
          }(),
          for (var i = 0; i < 5; i++)
            () async {
              // Give first subscription time send request to backend service
              await wait(milliseconds: 200);
              // Id no longer required
              await client.subscribe(topic);
              verifySubscribeCalled(connection, 0);
            }(),
        ]);
      });

      test(
          'If there is an ongoing subscription for a topic, which will not '
          'receive confirmation from backend, and an another subscription call '
          'is made for that topic, the first subscription should throw a '
          'TimeoutException and the second one should persue with the logic '
          '(try to connect to backend service)', () async {
        // Prepare general config
        prepareConnect(connection);
        prepareTopic(topic);
        when(() => uuid.v1()).thenReturn('');
        when(() => uuid.v4()).thenReturn('');
        when(() => connection.state)
            .thenAnswer((_) => HubConnectionState.disconnected);
        when(
          () => connection.send(
            methodName: 'SubscribeAsync',
            args: any(named: 'args'),
          ),
        ).thenAnswer((_) async {});

        await Future.wait([
          () async {
            // First subscription
            await expectLater(
              () => client.subscribe(topic),
              throwsA(const TypeMatcher<TimeoutException>()),
            );
            verifySubscribeCalled(connection);
          }(),
          () async {
            // Give first subscription time send request to backend service
            await wait(seconds: 5);

            // Connect to catch on subscription result method
            final onSubscriptionResultMethod =
                await captureOnSubscriptionResult(
              connect: client.connect,
              connection: connection,
            );

            prepareSubscribeToAnswerWithData(
              connection: connection,
              uuid: uuid,
              answerCallback: (subscribeResult) =>
                  onSubscriptionResultMethod([subscribeResult.toJson()]),
            );

            await client.subscribe(topic);

            verifySubscribeCalled(connection);
          }()
        ]);
      });

      test(
          'If subscription for a specific topic is already registered then '
          'on every further subscribe() call for that topic, return pipe '
          'subscription without calling backend service', () async {
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

        // We want to answer to the subscription only once because internal logic
        // should block any other subscription requests, waiting for the first
        // subscription to complete instead
        var isFirstAnswerToSubscribeRequest = true;

        // Prepare connection to simulate backend sending subscription confirmation
        prepareSubscribeToAnswerWithData(
          connection: connection,
          uuid: uuid,
          answerCallback: (subscribeResult) async {
            if (isFirstAnswerToSubscribeRequest) {
              isFirstAnswerToSubscribeRequest = false;

              await onSubscriptionResultMethod([subscribeResult.toJson()]);
            }
          },
        );

        // Get subscription with the same id as defined in `subscriptionResult`
        await client.subscribe(topic);
        verifySubscribeCalled(connection);

        await Future.wait<dynamic>([
          for (var i = 0; i < 5; i++)
            () async {
              await client.subscribe(topic);
              // Verify that request to backend was sent only once
              verifySubscribeCalled(connection, 0);
            }(),
        ]);
      });
    });

    test(
        'If subscription for a specific topic is in unsubscribing state, '
        'the next subscribe() call for that topic, will wait until unsubscribing '
        'is done, and persue with its logic to register a new subscription. '
        'Other calls on subscribe() for that topic should as well wait for the '
        'first one (after unsubscribe) finishes, and return pipe subscription '
        'without calling backend', () async {
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

      var subscriptionAnswerCounter = 0;
      prepareSubscribeToAnswerWithData(
        connection: connection,
        uuid: uuid,
        answerCallback: (subscribeResult) async {
          // Answer only to the first and seconds call:
          // - First is to register subscription that we will unsubscribe later
          // - Second is the first from many that we will register while topic
          //   subscription will be in unsubscribing state
          if (subscriptionAnswerCounter < 2) {
            subscriptionAnswerCounter++;

            await onSubscriptionResultMethod([subscribeResult.toJson()]);
          }
        },
      );

      // Start a connection to be able to unsubscribe
      final subscription = await client.subscribe(topic);
      verifySubscribeCalled(connection);

      // Prepare for unsubscribe
      prepareUnsubscribeToAnswerWithData(
        connection: connection,
        uuid: uuid,
        answerCallback: (result) async {
          await wait(seconds: 4);
          await onSubscriptionResultMethod([result.toJson()]);
        },
      );

      await Future.wait([
        () async {
          await subscription.unsubscribe();
          verifyUnsubscribeCalled(connection);
        }(),
        () async {
          await wait(milliseconds: 100);
          // First subscription
          expect(await client.subscribe(topic), isA<PipeSubscription>());
          verifySubscribeCalled(connection);
        }(),
        for (var i = 0; i < 4; i++)
          () async {
            // Give first subscription time send request to backend service
            await wait(milliseconds: 200);

            expect(await client.subscribe(topic), isA<PipeSubscription>());
            verifySubscribeCalled(connection, 0);
          }(),
      ]);
    });
  });

  group('PipeClient unsubscribe() tests', () {
    late HubConnection connection;
    late Uuid uuid;
    late PipeClient client;
    late Topic<String> topic;

    setUp(() {
      connection = MockHubConnection();
      uuid = MockUuid();
      client = PipeClient.fromMock(hubConnection: connection, uuid: uuid);
      topic = MockTopic();
    });

    test('Unsubscribes from a registered subscription', () async {
      // Prepare general config
      prepareConnect(connection);
      prepareTopic(topic);
      when(() => connection.state)
          .thenAnswer((_) => HubConnectionState.disconnected);

      // Prepare a subscription
      final onSubscriptionResultMethod = await captureOnSubscriptionResult(
        connect: client.connect,
        connection: connection,
      );

      prepareSubscribeToAnswerWithData(
        connection: connection,
        uuid: uuid,
        answerCallback: (subscribeResult) async {
          await onSubscriptionResultMethod([subscribeResult.toJson()]);
        },
      );

      // Start a connection to be able to unsubscribe
      final subscription = await client.subscribe(topic);
      verifySubscribeCalled(connection);

      prepareUnsubscribeToAnswerWithData(
        connection: connection,
        uuid: uuid,
        answerCallback: (unsubscribeResult) async {
          await onSubscriptionResultMethod([unsubscribeResult.toJson()]);
        },
      );

      // Prepare expected test result
      var isSubscriptionDone = false;
      final streamSub = subscription.listen(
        (_) {},
        onDone: () => isSubscriptionDone = true,
      );

      // Unsubscribe and expect the stream to be done
      await subscription.unsubscribe();
      verifyUnsubscribeCalled(connection);

      await wait(milliseconds: 500);

      // Clean up
      await streamSub.cancel();

      expect(isSubscriptionDone, true);
    });

    test(
        'Throws a StateError if topic is not registered (when already '
        'unsubscribed from that subscription)', () async {
      // Prepare general config
      prepareConnect(connection);
      prepareTopic(topic);
      when(() => connection.state)
          .thenAnswer((_) => HubConnectionState.disconnected);

      // Prepare a subscription
      final onSubscriptionResultMethod = await captureOnSubscriptionResult(
        connect: client.connect,
        connection: connection,
      );

      prepareSubscribeToAnswerWithData(
        connection: connection,
        uuid: uuid,
        answerCallback: (subscribeResult) async {
          await onSubscriptionResultMethod([subscribeResult.toJson()]);
        },
      );

      // Start a connection to be able to unsubscribe
      final subscription = await client.subscribe(topic);
      verifySubscribeCalled(connection);

      prepareUnsubscribeToAnswerWithData(
        connection: connection,
        uuid: uuid,
        answerCallback: (unsubscribeResult) async {
          await onSubscriptionResultMethod([unsubscribeResult.toJson()]);
        },
      );

      // Unsubscribe for the first time - should pass
      await subscription.unsubscribe();
      verifyUnsubscribeCalled(connection);

      // Unsubscribe for the second time - should throw a StateError
      expect(
        subscription.unsubscribe,
        throwsA(const TypeMatcher<StateError>()),
      );
    });

    test(
        'If there are x subscriptions registered on the same topic, '
        'only the last one should call unsubscribe in the backend service',
        () async {
      // Prepare general config
      prepareConnect(connection);
      prepareTopic(topic);
      when(() => connection.state)
          .thenAnswer((_) => HubConnectionState.disconnected);

      // Prepare a subscription
      final onSubscriptionResultMethod = await captureOnSubscriptionResult(
        connect: client.connect,
        connection: connection,
      );

      prepareSubscribeToAnswerWithData(
        connection: connection,
        uuid: uuid,
        answerCallback: (subscribeResult) async {
          await onSubscriptionResultMethod([subscribeResult.toJson()]);
        },
      );

      // Prepare subscriptions
      const subscriptionsCount = 5;
      final subscriptions = <PipeSubscription>[];
      await Future.wait([
        for (var i = 0; i < subscriptionsCount; i++)
          () async {
            subscriptions.add(await client.subscribe(topic));
          }(),
      ]);
      verifySubscribeCalled(connection);

      // Last subscription defined separatelly only for better scenario
      // visualisation, could be defined in subscriptions as well
      final lastSubscription = await client.subscribe(topic);

      prepareUnsubscribeToAnswerWithData(
        connection: connection,
        uuid: uuid,
        answerCallback: (unsubscribeResult) async {
          await onSubscriptionResultMethod([unsubscribeResult.toJson()]);
        },
      );

      // None of the subscriptions should call backend service because
      // there still is one registered subscription
      await Future.wait([
        for (final sub in subscriptions) sub.unsubscribe(),
      ]);
      verifyUnsubscribeCalled(connection, 0);

      // Verify that last subscription calls backend service
      await lastSubscription.unsubscribe();
      verifyUnsubscribeCalled(connection);
    });

    test(
        'If unsubscribe() called while subscription is in reconnecting state '
        'and while subscribtion call will finish successfully, '
        'unsubscribe call should wait for subscription to finish', () async {
      // Prepare general config
      prepareConnect(connection);
      prepareTopic(topic);
      when(() => connection.state)
          .thenAnswer((_) => HubConnectionState.disconnected);

      // Prepare a subscription
      final onSubscriptionResultMethod = await captureOnSubscriptionResult(
        connect: client.connect,
        connection: connection,
      );

      // Prepare subscription answer at first time immidiately, while later
      // (for reconnect) will answer with delay
      var shouldWaitBeforeAnswering = false;
      prepareSubscribeToAnswerWithData(
        connection: connection,
        uuid: uuid,
        answerCallback: (subscribeResult) async {
          if (shouldWaitBeforeAnswering) {
            await wait(seconds: 5);
          }

          await onSubscriptionResultMethod([subscribeResult.toJson()]);

          // Verify that unsubscribe didn't call backend service
          // before the reconnect was completed
          verifyUnsubscribeCalled(connection, 0);
        },
      );

      final subscription = await client.subscribe(topic);

      // Prepare reconnecting state scenario
      final onReconnected = await captureOnReconnected(
        connect: client.connect,
        connection: connection,
      );

      // Wait with answering to give time to unsubscribe to persue with its logic
      shouldWaitBeforeAnswering = true;
      unawaited(onReconnected(''));

      // Unsubscribe should wait for reconnect to finish up and then persue with
      // the logic
      prepareUnsubscribeToAnswerWithData(
        connection: connection,
        uuid: uuid,
        answerCallback: (unsubscribeResult) async {
          await onSubscriptionResultMethod([unsubscribeResult.toJson()]);
        },
      );

      // Unsubscribe and verify if it did work
      await subscription.unsubscribe();
      verifyUnsubscribeCalled(connection);
    });

    test(
        'If unsubscribe() called while subscription is in reconnecting state '
        'and while subscribtion call will fail, unsubscribe call should wait '
        'for subscription to finish and NOT send a call to the backend service',
        () async {
      // Prepare general config
      prepareConnect(connection);
      prepareTopic(topic);
      when(() => connection.state)
          .thenAnswer((_) => HubConnectionState.disconnected);

      // Prepare a subscription
      final onSubscriptionResultMethod = await captureOnSubscriptionResult(
        connect: client.connect,
        connection: connection,
      );

      // Prepare subscription answer at first time immidiately, while later
      // (for reconnect) will answer with delay
      var isFirstAnswer = true;
      prepareSubscribeToAnswerWithData(
        connection: connection,
        uuid: uuid,
        answerCallback: (subscriptionSuccededResult) async {
          final subscriptionFailedResult = SubscriptionResult(
            subscriptionId: subscriptionSuccededResult.subscriptionId,
            status: SubscriptionStatus.invalid,
            type: subscriptionSuccededResult.type,
          );

          if (isFirstAnswer) {
            await onSubscriptionResultMethod(
              [subscriptionSuccededResult.toJson()],
            );
            return;
          }

          // Wait with answering to give time to unsubscribe to persue with its logic
          await wait(seconds: 3);
          await onSubscriptionResultMethod([subscriptionFailedResult.toJson()]);

          // Verify that unsubscribe didn't call backend service
          // before the reconnect was completed (failed)
          verifyUnsubscribeCalled(connection, 0);
        },
      );

      final subscription = await client.subscribe(topic);

      // Prepare reconnecting state scenario
      final onReconnected = await captureOnReconnected(
        connect: client.connect,
        connection: connection,
      );

      isFirstAnswer = false;
      unawaited(onReconnected(''));

      // Unsubscribe should wait for reconnect to finish up and then persue with
      // the logic
      prepareUnsubscribeToAnswerWithData(
        connection: connection,
        uuid: uuid,
        answerCallback: (unsubscribeResult) async {
          await onSubscriptionResultMethod([unsubscribeResult.toJson()]);
        },
      );

      // Unsubscribe and verify if it did not call backend service
      // because failed to reconnect
      await subscription.unsubscribe();
      verifyUnsubscribeCalled(connection, 0);
    });
  });

  group('PipeClient reconnect() tests', () {
    late HubConnection connection;
    late Uuid uuid;
    late PipeClient client;

    setUp(() {
      connection = MockHubConnection();
      uuid = MockUuid();
      client = PipeClient.fromMock(hubConnection: connection, uuid: uuid);
    });

    test(
        'Reconnect calls subscribtion on backend for every registered topic '
        'subscription and triggers its onReconnect call', () async {
      // Prepare general config
      prepareConnect(connection);
      when(() => connection.state)
          .thenAnswer((_) => HubConnectionState.disconnected);

      // Prepare multiple topics
      const subscriptionsCount = 5;
      final topics = <MockTopic, bool>{};
      for (var i = 0; i < subscriptionsCount; i++) {
        final topic = MockTopic<String>('$i');
        when(topic.getFullName).thenReturn('name$i');
        when(topic.toJson).thenReturn(<String, dynamic>{
          'id': '$i',
        });
        topics.addAll({topic: false});
      }

      // Prepare a subscription
      final onSubscriptionResultMethod = await captureOnSubscriptionResult(
        connect: client.connect,
        connection: connection,
      );
      prepareSubscribeToAnswerWithDataPerTopic(
        connection: connection,
        uuid: uuid,
        count: subscriptionsCount,
        answerCallback: (result) async {
          await onSubscriptionResultMethod([result.toJson()]);
        },
      );

      await Future.wait([
        for (var i = 0; i < topics.length; i++)
          () async {
            final topic = topics.keys.elementAt(i);

            await client.subscribe(
              topic,
              onReconnect: () {
                topics[topic] = true;
              },
            );
          }(),
      ]);

      verifySubscribeCalled(connection, topics.length);

      // Prepare reconnecting state scenario
      final onReconnected = await captureOnReconnected(
        connect: client.connect,
        connection: connection,
      );

      await onReconnected('');

      // Verify that onReconnected called backend service
      // for every registered subscription for an unique topic
      verifySubscribeCalled(connection, topics.length);

      // Verify that every subscription got its onReconnect called
      for (final value in topics.values) {
        expect(value, true);
      }
    });
  });
}
