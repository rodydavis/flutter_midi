package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import com.appleeducate.fluttermidi.FlutterMidiPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    FlutterMidiPlugin.registerWith(registry.registrarFor("com.appleeducate.fluttermidi.FlutterMidiPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
