import 'dart:async';

import 'package:test/test.dart';
import 'package:typed_event_bus/typed_event_bus.dart';

enum Events {
  test,
  testWithData,
  finish,
}

void main() {
  late TypedEventBus bus;

  setUpAll(() => bus = TypedEventBus());

  tearDownAll(() {
    bus.dispose();
  });

  test('catch events', () async {
    final completer = Completer();
    final result = <dynamic>[];
    final subscription = bus.onEvent<TestEvent>((_) {
      result.add('Hello');
    }).onEvent<TestDataEvent>((data) {
      result.add(data.message);
    }).onEvent<FinallyEvent>((_) {
      result.add('bus');
      completer.complete();
    });

    bus.emit<TestEvent>(TestEvent());
    bus.emit(TestDataEvent('from'));
    await Future.delayed(Duration(seconds: 1));
    bus.emit(FinallyEvent());
    await completer.future;
    expect(completer.isCompleted, isTrue);
    expect(result.join(' '), 'Hello from bus');
    subscription.dispose();
  });
}

class TestEvent {}

class TestDataEvent {
  final String message;

  TestDataEvent(this.message);
}

class FinallyEvent {}
