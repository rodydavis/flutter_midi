import 'dart:async';
import 'dart:js' as js;
import 'package:flutter/widgets.dart';
import 'package:tonic/tonic.dart' as tonic;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:flutter/services.dart';

import 'src/platform_interface.dart';

class FlutterMidiPlugin extends FlutterMidiPlatform {
  static void registerWith(Registrar registrar) {
    WidgetsFlutterBinding.ensureInitialized();
    final instance = FlutterMidiPlugin();
    final MethodChannel channel = MethodChannel(
      'flutter_midi',
      const StandardMethodCodec(),
      registrar.messenger,
    );
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'play_midi_note':
        final int midi = call.arguments['note'];
        String _note = tonic.Pitch.fromMidiNumber(midi).toString();
        _note = _note.replaceAll('♭', 'b').replaceAll('♯', '#');
        js.context.callMethod('playNote', [_note]);
        return 'Result: $_note';
      case 'stop_midi_note':
        final int midi = call.arguments['note'];
        String _note = tonic.Pitch.fromMidiNumber(midi).toString();
        _note = _note.replaceAll('♭', 'b').replaceAll('♯', '#');
        // print('Midi -> $midi/$_note');
        js.context.callMethod('stopNote');
        return 'Result: $_note';
      default:
    }
  }
}
