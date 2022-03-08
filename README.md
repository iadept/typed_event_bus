# typed_event_bus

Simple event bus with typed event and subscription chain

## Usage
To use this plugin, add `typed_event_bus` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

### Example

``` dart
import 'package:typed_event_bus/typed_event_bus.dart';

class TestEvent {}

class TestDataEvent {
  final String message;

  TestDataEvent(this.message);
}

void main() {
  final bus = TypedEventBus();

  final subscription = bus.onEvent<TestEvent>((_) {
    print('Catch only TestEvent data');
  }).onEvent<TestDataEvent>((data) {
    print('Catch only TestDataEvent data');
    print('With message ${data.message}')
  });

  bus.emit<TestEvent>(TestEvent());
  bus.emit(TestDataEvent('from'));

  subscription.dispose();
  bus.dispose();
}
```

## License

The MIT License (MIT)