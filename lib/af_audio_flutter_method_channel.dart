import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'af_audio_flutter_platform_interface.dart';

/// An implementation of [AfAudioFlutterPlatform] that uses method channels.
class MethodChannelAfAudioFlutter extends AfAudioFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('af_audio_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> printLog() async {
    final success = await methodChannel.invokeMethod<bool>('printLog');
    return success;
  }

  @override
  Future<bool?> startService() async {
    final success = await methodChannel.invokeMethod<bool>('startService');
    return success;
  }

  @override
  Future<bool?> stopService() async {
    final success = await methodChannel.invokeMethod<bool>('stopService');
    return success;
  }

  @override
  Future<bool?> startAudio(String ip, int channel) async {
    final success = await methodChannel.invokeMethod<bool>('startAudio', {"ip": ip, "ch": channel});
    return success;
  }

  @override
  Future<bool?> muteAudio() async {
    final success = await methodChannel.invokeMethod<bool>('muteAudio');
    return success;
  }

  @override
  Future<bool?> unMuteAudio() async {
    final success = await methodChannel.invokeMethod<bool>('unMuteAudio');
    return success;
  }


}
