library typed_event_bus;

import 'dart:async';

class TypedEventBus<K> {
  final _eventController = StreamController<_Packet<K, dynamic>>.broadcast();

  Future<void> dispose() async {
    await _eventController.close();
  }

  /// Emit new event with [id] and [data]
  void emit<T>(K id, [T? data]) {
    _eventController.sink.add(_Packet<K, T>(id, data));
  }

  /// Emit new event with [data] only
  void emitData<T>(T data) {
    _eventController.sink.add(_Packet<K, T>(null, data));
  }

  /// Catch event with [id] without data
  EventBusSubscription onEvent(
    K id,
    void Function() onEvent,
  ) {
    return EventBusSubscription<K, Null>(
      id,
      (_) => onEvent(),
      _eventController.stream.listen(null),
      null,
    );
  }

  /// Catch event with [id] and data type is [T]
  EventBusSubscription onDataEvent<T>(
    K id,
    void Function(T data) onEvent,
  ) {
    return EventBusSubscription<K, T>(
      id,
      onEvent,
      _eventController.stream.listen(null),
      null,
    );
  }

  /// Catch event with data type is [T]
  EventBusSubscription onData<T>(
    void Function(T data) onEvent,
  ) {
    return EventBusSubscription<Null, T>(
      null,
      onEvent,
      _eventController.stream.listen(null),
      null,
    );
  }
}

class _Packet<K, V> {
  final K? id;
  final V? data;

  _Packet(this.id, this.data);
}

class EventBusSubscription<K, V> {
  final K _filterId;
  final void Function(V data) _onEvent;

  final StreamSubscription<_Packet> _subscription;
  final EventBusSubscription? _parent;

  EventBusSubscription(
    this._filterId,
    this._onEvent,
    this._subscription,
    this._parent,
  ) {
    _subscription.onData(_onData);
  }

  void _onData(_Packet packet) {
    if (_filterId == null) {
      if (packet.data is V) {
        _onEvent(packet.data as V);
      }
    } else {
      if (_filterId == packet.id) {
        if (packet.data is V) {
          _onEvent(packet.data as V);
        }
      }
    }
    _parent?._onData(packet);
  }

  EventBusSubscription onEvent(
    K id,
    void Function() onEvent,
  ) {
    return EventBusSubscription<K, Null>(
      id,
      (_) => onEvent(),
      _subscription,
      this,
    );
  }

  EventBusSubscription onDataEvent<T>(
    K id,
    void Function(T data) onEvent,
  ) {
    return EventBusSubscription<K, T>(
      id,
      onEvent,
      _subscription,
      this,
    );
  }

  EventBusSubscription onData<T>(void Function(T data) onEvent) {
    return EventBusSubscription<K?, T>(
      null,
      onEvent,
      _subscription,
      this,
    );
  }

  void dispose() {
    _subscription.cancel();
  }
}
