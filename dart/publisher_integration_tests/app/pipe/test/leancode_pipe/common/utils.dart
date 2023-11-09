import 'dart:async';

import 'package:leancode_pipe/leancode_pipe.dart';
import 'package:leancode_pipe/leancode_pipe/contracts/contracts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:uuid/uuid.dart';

import 'mocks.dart';

const pipeUrl = 'https://exampleapp.test.lncd.pl/leanpipe';

void prepareConnect(HubConnection connection) {
  when(() => connection.onreconnected(any())).thenAnswer((_) {});
  when(() => connection.onreconnecting(any())).thenAnswer((_) {});
  when(() => connection.onclose(any())).thenAnswer((_) {});
  when(() => connection.on(any(), any())).thenAnswer((_) async {});
  when(() => connection.start()).thenAnswer((_) async {});
}

void prepareTopic(Topic topic) {
  when(() => topic.getFullName()).thenReturn('name');
  when(() => topic.toJson()).thenReturn(<String, dynamic>{});
}

typedef OnSubscriptionResult = Future<void> Function(List<dynamic> args);
Future<OnSubscriptionResult> captureOnSubscriptionResult({
  required Future<void> Function() connect,
  required HubConnection connection,
}) async {
  await connect();
  return verify(
    () => connection.on(
      'subscriptionResult',
      captureAny(),
    ),
  ).captured.first as OnSubscriptionResult;
}

typedef OnReconnected = Future<void> Function(String? connectionId);
Future<OnReconnected> captureOnReconnected({
  required Future<void> Function() connect,
  required HubConnection connection,
}) async {
  await connect();
  return verify(
    () => connection.onreconnected(
      captureAny(),
    ),
  ).captured.first as OnReconnected;
}

typedef OnClose = Future<void> Function(Exception? exception);
Future<OnClose> captureOnClose({
  required Future<void> Function() connect,
  required HubConnection connection,
}) async {
  await connect();
  return verify(
    () => connection.onclose(
      captureAny(),
    ),
  ).captured.first as OnClose;
}

void prepareSubscribeToAnswerWithData({
  required HubConnection connection,
  required Uuid uuid,
  required Future<void> Function(SubscriptionResult) answerCallback,
}) {
  const id = 'subscriptionId';
  const subscriptionResult = SubscriptionResult(
    type: OperationType.subscribe,
    status: SubscriptionStatus.success,
    subscriptionId: id,
  );

  // Simulate getting data from backend service with prepared subscription result
  when(() => uuid.v1()).thenReturn(id);
  when(() => uuid.v4()).thenReturn(id);
  when(
    () => connection.send(
      methodName: 'Subscribe',
      args: any(named: 'args'),
    ),
  ).thenAnswer((_) async {
    unawaited(answerCallback(subscriptionResult));
  });
}

void prepareUnsubscribeToAnswerWithData({
  required HubConnection connection,
  required Uuid uuid,
  required Future<void> Function(SubscriptionResult) answerCallback,
}) {
  const id = 'subscriptionId';
  const subscriptionResult = SubscriptionResult(
    type: OperationType.unsubscribe,
    status: SubscriptionStatus.success,
    subscriptionId: id,
  );

  // Simulate getting data from backend service with prepared subscription result
  when(() => uuid.v1()).thenReturn(id);
  when(() => uuid.v4()).thenReturn(id);
  when(
    () => connection.send(
      methodName: 'Unsubscribe',
      args: any(named: 'args'),
    ),
  ).thenAnswer((_) async {
    unawaited(answerCallback(subscriptionResult));
  });
}

void verifySubscribeCalled(HubConnection connection, [int count = 1]) {
  // Using verify on a mock resets its callCount for the method
  Future<void> callback() {
    return connection.send(
      methodName: 'Subscribe',
      args: any(named: 'args'),
    );
  }

  if (count == 0) {
    verifyNever(callback);
  } else {
    verify(callback).called(count);
  }
}

void verifyUnsubscribeCalled(HubConnection connection, [int count = 1]) {
  // Using verify on a mock resets its callCount for the method
  Future<void> callback() {
    return connection.send(
      methodName: 'Unsubscribe',
      args: any(named: 'args'),
    );
  }

  if (count == 0) {
    verifyNever(callback);
  } else {
    verify(callback).called(count);
  }
}

void prepareSubscribeToAnswerWithDataPerTopic({
  required HubConnection connection,
  required Uuid uuid,
  required Future<void> Function(SubscriptionResult) answerCallback,
  required int count,
}) {
  var i = -1;
  // Simulate getting data from backend service with prepared subscription result
  when(() => uuid.v1()).thenReturn('${i}_v1');
  when(() => uuid.v4()).thenAnswer((_) {
    i++;
    if (i == count) {
      i = 0;
    }
    return i.toString();
  });

  when(
    () => connection.send(
      methodName: 'Subscribe',
      args: any(named: 'args'),
    ),
  ).thenAnswer((invocation) async {
    final args =
        invocation.namedArguments[const Symbol('args')] as List<dynamic>;
    final topicJson = (args.first as SubscriptionEnvelope).topic;
    final topicId = topicJson['id'] as String;
    final topic = MockTopic(topicId);

    final result = SubscriptionResult(
      type: OperationType.subscribe,
      status: SubscriptionStatus.success,
      subscriptionId: topic.id!,
    );
    unawaited(answerCallback(result));
  });
}
