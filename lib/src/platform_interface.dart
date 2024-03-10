import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel.dart';

class FlutterMidiPlatform extends PlatformInterface {
  FlutterMidiPlatform() : super(token: _token);
  static final Object _token = Object();
  static FlutterMidiPlatform _instance = MethodChannelUrlLauncher();
  static FlutterMidiPlatform get instance => _instance;
  static set instance(FlutterMidiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Needed so that the sound font is loaded
  /// On iOS make sure to include the sound_font.SF2 in the Runner folder.
  /// This does not work in the simulator.
  Future<String?> prepare({
    required ByteData? sf2,
    String name = 'instrument.sf2',
  }) async {
    debugPrint('Setup Midi..');
    throw UnimplementedError('prepare() has not been implemented.');
  }

  /// Needed so that the sound font is loaded
  /// On iOS make sure to include the sound_font.SF2 in the Runner folder.
  /// This does not work in the simulator.
  Future<String?> changeSound({
    required ByteData? sf2,
    String name = 'instrument.sf2',
  }) async {
    throw UnimplementedError('changeSound() has not been implemented.');
  }

  /// Unmute the device temporarily even if the mute switch is on or toggled in settings.
  Future<String?> unmute() async {
    throw UnimplementedError('canLaunch() has not been implemented.');
  }

  /// Use this when stopping the sound onTouchUp or to cancel a long file.
  /// Not needed if playing midi onTap.
  /// Stop with velocity in the range between 0-127
  Future<String?> stopMidiNote({
    required int midi,
    int velocity = 64,
  }) async {
    throw UnimplementedError('stopMidiNote() has not been implemented.');
  }

  /// Play a midi note from the sound_font.SF2 library bundled with the application.
  /// Play a midi note in the range between 0-127
  /// Play with velocity in the range between 0-127
  /// Multiple notes can be played at once as separate calls.
  Future<String?> playMidiNote({
    required int midi,
    int velocity = 64,
  }) async {
    throw UnimplementedError('playMidiNote() has not been implemented.');
  }
}
