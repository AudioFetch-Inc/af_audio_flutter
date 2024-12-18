
import 'af_audio_flutter_platform_interface.dart';

class AfAudioFlutter {
  Future<String?> getPlatformVersion() {
    return AfAudioFlutterPlatform.instance.getPlatformVersion();
  }

  Future<bool?> startService() {
    return AfAudioFlutterPlatform.instance.startService();
  }

  Future<bool?> startAudio(String ip, int ch) {
    return AfAudioFlutterPlatform.instance.startAudio(ip,ch);
  }

  Future<bool?> muteAudio() {
    return AfAudioFlutterPlatform.instance.muteAudio();
  }

  Future<bool?> unMuteAudio() {
    return AfAudioFlutterPlatform.instance.unMuteAudio();
  }

}
