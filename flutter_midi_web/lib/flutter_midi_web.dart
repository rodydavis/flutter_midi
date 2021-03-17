
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterMidiWeb {
  static const MethodChannel _channel =
      const MethodChannel('flutter_midi_web');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
