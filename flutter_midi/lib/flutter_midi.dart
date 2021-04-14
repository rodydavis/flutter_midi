import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

import 'src/cache.dart';
import 'src/platform_interface.dart';

class FlutterMidi extends FlutterMidiPlatform {
  static const MethodChannel _channel = MethodChannel('flutter_midi');

  /// Needed so that the sound font is loaded
  /// On iOS make sure to include the sound_font.SF2 in the Runner folder.
  /// This does not work in the simulator.
  @override
  Future<String?> prepare({
    required ByteData? sf2,
    String name = 'instrument.sf2',
  }) async {
    if (sf2 == null) return Future.value(null);
    if (kIsWeb) return _channel.invokeMethod('prepare_midi');
    File? _file = await writeToFile(sf2, name: name);
    if (_file == null) return null;
    return _channel.invokeMethod('prepare_midi', {'path': _file.path});
  }

  /// Needed so that the sound font is loaded
  /// On iOS make sure to include the sound_font.SF2 in the Runner folder.
  /// This does not work in the simulator.
  @override
  Future<String?> changeSound({
    required ByteData? sf2,
    String name = 'instrument.sf2',
  }) async {
    if (sf2 == null) return Future.value(null);
    File? _file = await writeToFile(sf2, name: name);
    if (_file == null) return null;

    final Map<dynamic, dynamic> mapData = <dynamic, dynamic>{};
    mapData['path'] = _file.path;
    debugPrint('Path => ${_file.path}');
    final String result = await _channel.invokeMethod('change_sound', mapData);
    debugPrint('Result: $result');
    return result;
  }

  /// Unmute the device temporarly even if the mute switch is on or toggled in settings.
  @override
  Future<String> unmute() async {
    final String result = await _channel.invokeMethod('unmute');
    return result;
  }

  /// Use this when stopping the sound onTouchUp or to cancel a long file.
  /// Not needed if playing midi onTap.
  @override
  Future<String?> stopMidiNote({required int midi}) async {
    return _channel.invokeMethod('stop_midi_note', {'note': midi});
  }

  /// Play a midi note from the sound_font.SF2 library bundled with the application.
  /// Play a midi note in the range between 0-256
  /// Multiple notes can be played at once as separate calls.
  @override
  Future<String?> playMidiNote({required int midi}) async {
    return _channel.invokeMethod('play_midi_note', {'note': midi});
  }
}
