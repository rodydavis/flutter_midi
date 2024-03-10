package com.appleeducate.fluttermidi;

import android.content.Context;

import androidx.annotation.NonNull;

import cn.sherlock.com.sun.media.sound.SF2Soundbank;
import cn.sherlock.com.sun.media.sound.SoftSynthesizer;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.BinaryMessenger;

import java.io.File;
import java.io.IOException;

import jp.kshoji.javax.sound.midi.InvalidMidiDataException;
import jp.kshoji.javax.sound.midi.MidiUnavailableException;
import jp.kshoji.javax.sound.midi.Receiver;
import jp.kshoji.javax.sound.midi.ShortMessage;

/**
 * FlutterMidiPlugin
 */
public class FlutterMidiPlugin implements MethodCallHandler, FlutterPlugin {
    private SoftSynthesizer synth;
    private Receiver recv;
    private MethodChannel methodChannel;
    private Context applicationContext;

    /**
     * Plugin registration.
     */
    @SuppressWarnings("deprecation")
    public static void registerWith(Registrar registrar) {
        final FlutterMidiPlugin instance = new FlutterMidiPlugin();
        instance.onAttachedToEngine(registrar.context(), registrar.messenger());
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    /*
      "Also, note that the plugin should still contain the static registerWith() method
      to remain compatible with apps that don’t use the v2 Android embedding.
      (See Upgrading pre 1.12 Android projects for details.) The easiest thing to
      do (if possible) is move the logic from registerWith() into a private method that
      both registerWith() and onAttachedToEngine() can call. Either registerWith() or
      onAttachedToEngine() will be called, not both."

      - https://flutter.dev/docs/development/packages-and-plugins/plugin-api-migration
    */
    private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
        methodChannel = new MethodChannel(messenger, "flutter_midi");
        methodChannel.setMethodCallHandler(new FlutterMidiPlugin());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        applicationContext = null;
        methodChannel.setMethodCallHandler(null);
        methodChannel = null;
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "prepare_midi":
            case "change_sound":
                try {
                    String _path = call.argument("path");
                    File _file = new File(_path);
                    SF2Soundbank sf = new SF2Soundbank(_file);
                    synth = new SoftSynthesizer();
                    synth.open();
                    synth.loadAllInstruments(sf);
                    synth.getChannels()[0].programChange(0);
                    synth.getChannels()[1].programChange(1);
                    recv = synth.getReceiver();
                    result.success(null);
                } catch (IOException | MidiUnavailableException e) {
                    e.printStackTrace();
                    result.error(e.getMessage(), null, null);
                }
                break;
            case "play_midi_note": {
                int _note = call.argument("note");
                int _velocity = call.argument("velocity");
                try {
                    ShortMessage msg = new ShortMessage();
                    msg.setMessage(ShortMessage.NOTE_ON, 0, _note, _velocity);
                    recv.send(msg, -1);
                    result.success(null);
                } catch (InvalidMidiDataException e) {
                    e.printStackTrace();
                    result.error(e.getMessage(), null, null);
                }
                break;
            }
            case "stop_midi_note": {
                int _note = call.argument("note");
                int _velocity = call.argument("velocity");
                try {
                    ShortMessage msg = new ShortMessage();
                    msg.setMessage(ShortMessage.NOTE_OFF, 0, _note, _velocity);
                    recv.send(msg, -1);
                    result.success(null);
                } catch (InvalidMidiDataException e) {
                    e.printStackTrace();
                    result.error(e.getMessage(), null, null);
                }
                break;
            }
            default:
                break;
        }
    }
}
