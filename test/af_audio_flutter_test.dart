import 'package:flutter_test/flutter_test.dart';
import 'package:af_audio_flutter/af_audio_flutter.dart';
import 'package:af_audio_flutter/af_audio_flutter_platform_interface.dart';
import 'package:af_audio_flutter/af_audio_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAfAudioFlutterPlatform
    with MockPlatformInterfaceMixin
    implements AfAudioFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AfAudioFlutterPlatform initialPlatform = AfAudioFlutterPlatform.instance;

  test('$MethodChannelAfAudioFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAfAudioFlutter>());
  });

  test('getPlatformVersion', () async {
    AfAudioFlutter afAudioFlutterPlugin = AfAudioFlutter();
    MockAfAudioFlutterPlatform fakePlatform = MockAfAudioFlutterPlatform();
    AfAudioFlutterPlatform.instance = fakePlatform;

    expect(await afAudioFlutterPlugin.getPlatformVersion(), '42');
  });
}
