abstract class FlutterZeroPlugin {
  final String name;
  const FlutterZeroPlugin(this.name);

  void onAppInit() {}
  void onNativeEvent(String eventName, Map<String, dynamic> data) {}
}

class PluginRegistry {
  static final Map<String, FlutterZeroPlugin> _plugins = {};

  static void register(FlutterZeroPlugin plugin) {
    _plugins[plugin.name] = plugin;
    plugin.onAppInit();
  }

  static void unregister(String pluginName) {
    _plugins.remove(pluginName);
  }

  static void dispatchNativeEvent(String eventName, Map<String, dynamic> data) {
    for (final plugin in _plugins.values) {
      plugin.onNativeEvent(eventName, data);
    }
  }

  static bool isRegistered(String pluginName) => _plugins.containsKey(pluginName);
}
