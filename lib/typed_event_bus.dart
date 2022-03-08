library typed_event_bus;

import 'dart:async';

mixin _Subscription {
  EventBusSubscription onEvent<T extends Object>(
    void Function(T data) onEvent,
  );
}

class TypedEventBus with _Subscription {
  final _eventController = StreamController.broadcast();

  Future<void> dispose() async {
    await _eventController.close();
  }

  /// Emit new event with [data]
  void emit<T extends Object>(T data) {
    _eventController.sink.add(data);
  }

  /// Catch event with data type is [T]
  EventBusSubscription onEvent<T extends Object>(
    void Function(T data) onEvent,
  ) {
    return EventBusSubscription<T>(
      onEvent,
      _eventController.stream.listen(null),
      null,
    );
  }
}

class EventBusSubscription<T extends Object> with _Subscription {
  final void Function(T data) _onEvent;

  final StreamSubscription _subscription;
  final EventBusSubscription? _parent;

  EventBusSubscription(
    this._onEvent,
    this._subscription,
    this._parent,
  ) {
    _subscription.onData(_onData);
  }

  void _onData(dynamic data) {
    if (data is T) {
      _onEvent(data);
    }

    _parent?._onData(data);
  }

  /// Catch event with data type is [T]
  EventBusSubscription onEvent<V extends Object>(
    void Function(V data) onEvent,
  ) {
    return EventBusSubscription<V>(
      onEvent,
      _subscription,
      this,
    );
  }

  void dispose() {
    _subscription.cancel();
  }
}
