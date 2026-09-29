import 'dart:async';

abstract class Event {
  const Event();
}

class EventBus {
  final StreamController<Event> _streamController;

  EventBus({bool sync = false})
      : _streamController = StreamController<Event>.broadcast(sync: sync);

  static final EventBus instance = EventBus();

  Stream<T> on<T extends Event>() {
    return _streamController.stream.where((event) => event is T).cast<T>();
  }

  void fire(Event event) {
    _streamController.add(event);
  }

  void destroy() {
    _streamController.close();
  }
}
