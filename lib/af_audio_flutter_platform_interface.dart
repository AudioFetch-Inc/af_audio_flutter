import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'af_audio_flutter_method_channel.dart';

abstract class AfAudioFlutterPlatform extends PlatformInterface {
  /// Constructs a AfAudioFlutterPlatform.
  AfAudioFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static AfAudioFlutterPlatform _instance = MethodChannelAfAudioFlutter();

  /// The default instance of [AfAudioFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelAfAudioFlutter].
  static AfAudioFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AfAudioFlutterPlatform] when
  /// they register themselves.
  static set instance(AfAudioFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> printLog() {
    throw UnimplementedError('printLog() has not been implemented.');
  }

  Future<bool?> startService() {
    throw UnimplementedError('startService() has not been implemented.');
  }

  Future<bool?> stopService() {
    throw UnimplementedError('startService() has not been implemented.');
  }

  Future<bool?> startAudio(String ip, int channel) {
    throw UnimplementedError('startAudio() has not been implemented.');
  }

  Future<bool?> muteAudio() {
    throw UnimplementedError('muteAudio() has not been implemented.');
  }

  Future<bool?> unMuteAudio() {
    throw UnimplementedError('unMuteAudio() has not been implemented.');
  }


}
