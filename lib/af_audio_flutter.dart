
import 'af_audio_flutter_platform_interface.dart';

class AfAudioFlutter {

  bool isServiceRunning = false;


  Future<String?> getPlatformVersion() {
    return AfAudioFlutterPlatform.instance.getPlatformVersion();
  }

  Future<bool?> printLog() {
    return AfAudioFlutterPlatform.instance.printLog();
  }


  Future<bool?> startService() {
    isServiceRunning = true;
    return AfAudioFlutterPlatform.instance.startService();
  }

  Future<bool?> stopService() {
    isServiceRunning = false;
    return AfAudioFlutterPlatform.instance.stopService();
  }

  Future<bool?> startAudio(String ip, int ch) {
    if (isServiceRunning == true) {
      return AfAudioFlutterPlatform.instance.startAudio(ip,ch);
    }
    else {
      print("Audio service not running - call startService");
      return Future.value(false);
    }
  }

  Future<bool?> muteAudio() {
    if (isServiceRunning == true) {
      return AfAudioFlutterPlatform.instance.muteAudio();
    }
    else {
      print("Audio service not running - call startService");
      return Future.value(false);
    }
  }

  Future<bool?> unMuteAudio() {
    if (isServiceRunning == true) {
      return AfAudioFlutterPlatform.instance.unMuteAudio();
    }
    else {
      print("Audio service not running - call startService");
      return Future.value(false);
    }
  }

}
