
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterMidiFfi {
  static const MethodChannel _channel =
      const MethodChannel('flutter_midi_ffi');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
