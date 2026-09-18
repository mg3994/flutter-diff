import 'dart:async';
import 'dart:isolate';

typedef ComputeCallback<Q, R> = FutureOr<R> Function(Q message);

Future<R> computeIsolate<Q, R>(ComputeCallback<Q, R> callback, Q message) async {
  final receivePort = ReceivePort();
  final errorPort = ReceivePort();

  final isolate = await Isolate.spawn<_IsolateConfiguration<Q, R>>(
    _isolateEntry,
    _IsolateConfiguration<Q, R>(callback, message, receivePort.sendPort),
    onError: errorPort.sendPort,
  );

  final completer = Completer<R>();

  errorPort.listen((dynamic error) {
    if (!completer.isCompleted) {
      completer.completeError(Exception(error.toString()));
    }
  });

  receivePort.listen((dynamic result) {
    if (!completer.isCompleted) {
      completer.complete(result as R);
    }
    receivePort.close();
    errorPort.close();
    isolate.kill();
  });

  return completer.future;
}

class _IsolateConfiguration<Q, R> {
  final ComputeCallback<Q, R> callback;
  final Q message;
  final SendPort sendPort;

  _IsolateConfiguration(this.callback, this.message, this.sendPort);
}

void _isolateEntry<Q, R>(_IsolateConfiguration<Q, R> config) async {
  final result = await config.callback(config.message);
  config.sendPort.send(result);
}
