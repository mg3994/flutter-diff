import 'dart:async';

class MethodCall {
  final String method;
  final dynamic arguments;

  const MethodCall(this.method, [this.arguments]);
}

typedef Future<dynamic> MethodCallHandler(MethodCall call);

class MethodChannel {
  final String name;
  static final Map<String, MethodCallHandler> _mockHandlers = {};

  const MethodChannel(this.name);

  void setMethodCallHandler(MethodCallHandler? handler) {
    if (handler == null) {
      _mockHandlers.remove(name);
    } else {
      _mockHandlers[name] = handler;
    }
  }

  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) async {
    final call = MethodCall(method, arguments);
    final handler = _mockHandlers[name];
    if (handler != null) {
      final result = await handler(call);
      return result as T?;
    }
    return null;
  }
}
