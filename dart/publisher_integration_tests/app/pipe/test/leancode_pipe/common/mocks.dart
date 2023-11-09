import 'package:leancode_pipe/leancode_pipe/contracts/topic.dart';
import 'package:leancode_pipe/leancode_pipe/pipe_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:uuid/uuid.dart';

final class MockBehaviorSubject<T extends Object> extends Mock
    implements BehaviorSubject<T> {}

final class MockPipeClient extends Mock implements PipeClient {}

final class MockHubConnection extends Mock implements HubConnection {}

final class MockTopic<T extends Object> extends Mock implements Topic<T> {
  MockTopic([this.id]);

  final String? id;

  @override
  bool operator ==(covariant MockTopic<T> other) {
    if (identical(this, other)) {
      return true;
    }

    return getFullName() == other.getFullName() && toJson() == other.toJson();
  }

  @override
  int get hashCode;
}

final class MockUuid extends Mock implements Uuid {}
