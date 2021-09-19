import 'dart:async';

import 'package:test/test.dart';
import 'package:typed_event_bus/typed_event_bus.dart';

enum Events {
  test,
  testWithData,
  finish,
}

void main() {
  late TypedEventBus<Events> bus;

  setUpAll(() => bus = TypedEventBus<Events>());

  tearDownAll(() {
    bus.dispose();
  });

  test('catch events', () async {
    final completer = Completer();
    final result = <dynamic>[];
    final subscription = bus.onEvent(Events.test, () {
      result.add(null);
    }).onDataEvent<String>(Events.testWithData, (data) {
      result.add(data);
    }).onDataEvent<int>(Events.testWithData, (data) {
      result.add(data);
    }).onDataEvent(Events.testWithData, (data) {
      result.add(data);
    }).onData<String>((data) {
      result.add(data);
    }).onEvent(Events.finish, () {
      completer.complete();
    });

    bus.emit(Events.test);
    bus.emit(Events.testWithData, 'test');
    bus.emit(Events.testWithData, 1);
    bus.emit(Events.finish);
    await completer.future;
    expect(completer.isCompleted, isTrue);
    expect(result, [null, 'test', 'test', 'test', 1, 1]);
    subscription.dispose();
  });
}
