import Cocoa
import FlutterMacOS
import AVFoundation

public class FlutterMidiPlugin: NSObject, FlutterPlugin {
  var message = "Please Send Message"
  var _arguments = [String: Any]()
  var au: AudioUnitMIDISynth!
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_midi", binaryMessenger: registrar.messenger)
    let instance = FlutterMidiPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case "prepare_midi":
        let map = call.arguments as? Dictionary<String, String>
       let data = map?["path"]
      let url = URL(fileURLWithPath: data!)
         au = AudioUnitMIDISynth(soundfont: url)
          print("Valid URL: \(url)")
        let message = "Prepared Sound Font"
        result(message)
    case "change_sound":
        let map = call.arguments as? Dictionary<String, String>
        let data = map?["path"]
        let url = URL(fileURLWithPath: data!)
        au.prepare(soundfont: url)
        print("Valid URL: \(url)")
        let message = "Prepared Sound Font"
        result(message)
      case "unmute":
        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print(error)
        }
        let message = "unmuted Device"
        result(message)
      case "play_midi_note":
        _arguments = call.arguments as! [String : Any];
        let midi = _arguments["note"] as? Int
        au.playPitch(midi:  midi ?? 60)
        let message = "Playing: \(String(describing: midi!))"
        result(message)
      case "stop_midi_note":
      _arguments = call.arguments as! [String : Any];
       let midi = _arguments["note"] as? Int
      au.stopPitch(midi:  midi ?? 60)
        let message = "Stopped: \(String(describing: midi!))"
        result(message)
      default:
        result(FlutterMethodNotImplemented)
        break
    }
  }
}
