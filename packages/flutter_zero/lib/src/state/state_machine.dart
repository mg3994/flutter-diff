import 'change_notifier.dart';

class StateMachine<S, E> extends ValueNotifier<S> {
  final Map<S, Map<E, S>> _transitions;

  StateMachine(S initialState, this._transitions) : super(initialState);

  bool canTransition(E event) {
    return _transitions[value]?.containsKey(event) ?? false;
  }

  bool trigger(E event) {
    final nextState = _transitions[value]?[event];
    if (nextState != null) {
      value = nextState;
      return true;
    }
    return false;
  }
}
