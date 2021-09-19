# typed_event_bus

Simple event bus with typed event and subscription chain

## Usage
To use this plugin, add `typed_event_bus` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

### Example

``` dart
import 'package:typed_event_bus/typed_event_bus.dart';

enum Events {
  test,
  testWithData,
}

void main() {
  final bus = TypedEventBus<Events>();

  final subscription = bus.onEvent(Events.test, () {
    print('Catch test event');
  }).onDataEvent<String>(Events.testWithData, (data) {
    print('only testWithData with String: $data');
  }).onDataEvent<int>(Events.testWithData, (data) {
    print('only testWithData with int: $data');
  }).onDataEvent(Events.testWithData, (data) {
    print('all testWithData: $data');
  }).onData<DateTime>((data) {
    print('all events with DateTime: $data');
  });

  bus.emit(Events.test);
  bus.emit(Events.testWithData, 'Hi');
  bus.emit(Events.testWithData, 1);
  bus.emitData('Hi');
  bus.emitData(DateTime.now());

  subscription.dispose();
  bus.dispose();
}
```

## License

The MIT License (MIT)