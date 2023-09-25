import 'dart:async';

import 'package:leancode_pipe/leancode_pipe/contracts/topic.dart';
import 'package:leancode_pipe/leancode_pipe/topic_subscription.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'common/mocks.dart';

void main() {
  group(
    'TopicSubscription states stream controller tests',
    () {
      late Topic<Object> topic;
      late TopicSubscription topicSubscription;

      setUp(() {
        topic = MockTopic();
        topicSubscription = TopicSubscription(
          topic,
          'id',
          TopicSubscriptionSubscribing(),
        );
      });

      test(
        'TopicSubscription closes states stream controller when dispose() is called',
        () async {
          expect(topicSubscription.stateSubject.isClosed, false);

          await topicSubscription.close();

          expect(topicSubscription.stateSubject.isClosed, true);
          expect(topicSubscription.isClosed, true);
        },
      );
    },
  );

  group(
    'TopicSubscription subscribed state tests',
    () {
      late Topic<Object> topic;
      late MockBehaviorSubject<TopicSubscriptionState> stateSubject;
      late TopicSubscription topicSubscription;
      late TopicSubscriptionSubscribed<Object> subscribedState;

      setUp(() {
        topic = MockTopic();
        stateSubject = MockBehaviorSubject();
        topicSubscription = TopicSubscription.subject(
          topic,
          'id',
          stateSubject,
        );

        final registeredSubscriptions = List.generate(5, (_) {
          final controller = StreamController<Object>.broadcast();
          return RegisteredSubscription<Object>(
            id: 'id',
            controller: controller,
            unsubscribe: controller.close,
          );
        });

        subscribedState = TopicSubscriptionSubscribed<Object>(
          registeredSubscriptions: registeredSubscriptions,
        );
      });

      test(
        'TopicSubscription in Subscribed state closes notification stream '
        'controllers for all registered subscriptions, when dispose() is called',
        () async {
          when(stateSubject.close).thenAnswer((_) async {});
          when(() => topicSubscription.stateSubject.value)
              .thenReturn(subscribedState);

          for (final sub in subscribedState.registeredSubscriptions) {
            expect(sub.controller.isClosed, false);
          }

          await topicSubscription.close();

          for (final sub in subscribedState.registeredSubscriptions) {
            expect(sub.controller.isClosed, true);
          }
          expect(topicSubscription.isClosed, true);
        },
      );
    },
  );
}
