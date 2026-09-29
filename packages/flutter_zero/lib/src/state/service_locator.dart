import 'package:get_it/get_it.dart';

export 'package:get_it/get_it.dart';
export 'package:rxdart/rxdart.dart';

class ZeroServiceLocator {
  static final GetIt _getIt = GetIt.instance;

  static GetIt get instance => _getIt;

  static void registerSingleton<T extends Object>(T instance) {
    _getIt.registerSingleton<T>(instance);
  }

  static T get<T extends Object>() {
    return _getIt.get<T>();
  }
}
