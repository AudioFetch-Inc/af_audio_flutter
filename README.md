# af_audio_flutter

## Updated 11/25 for API 35 and 16kb load boundary requirements.

## Overview

Flutter plugin for AudioFetch SDK for iOS and Android host apps. This plugin, along with the af_disco_flutter discovery library (available under NDA) allows host apps implemented in Flutter to use the AudioFetch SDK to discover AudioFetch boxes and play real-time low-latency audio.

This repo contains both the AF audio plugin as well as the sample app that uses the AF audio plugin and the AF discovery plugin. The AF discovery plugin for Fluttr is in a separate repo called af_disco_flutter.


## Building and running the example

Clone the af_disco_flutter plugin and have it as a peer of this repo on your local drive:

    af_audio_flutter
    af_disco_flutter

The Flutter sample app is in the example directory of this repo, for both ios and android, and will build and run with the usual flutter commands:

    flutter run

On Android, the sample app will discover and play audio on both devices and simulators. On iOS, it will discovery and play in a simulator. To successfully discover on a device, the Multicast Entitlement must be requested from Apple, see the af-sdk-sample-ios repo for more information.


## Flutter App integration

This plugin can be integrated into your Flutter-based app, see the example directory for details, but here are high-level instructions. This assumes that your Flutter app is a peer of this repo cloned to your local drive, and that the af_disco_flutter is also a peer on your local drive as shown above.

pubspec.yaml, in dependencies add:

    af_audio_flutter:
      path: ../af_audio_flutter

    af_disco_module:
      path: ../af_disco_flutter/af_disco_module

Of course you can change the directory organization and adjust the paths in the pubspec.yaml accordingly.

In your dart file (for example main.dart), imports:

    import 'package:flutter/services.dart';
    import 'package:af_audio_flutter/af_audio_flutter.dart';
    import 'package:af_disco_module/AfDiscovery.dart';

At initialization time (for example in initState()):

    @override
    void initState() {
      super.initState();
      initPlatformState();

      // Init and start discovery
      AfDiscovery.init(this);
    }

    // Platform messages are asynchronous, so we initialize in an async method.
    Future<void> initPlatformState() async {
      String platformVersion;

      try {
        await _afAudioFlutterPlugin.startService();
      } on PlatformException {
        print("Failed to start audio service.");
      }
    }

Add discovery callback methods (called from af_disco_flutter):

    // callback from disco to here when we have new ip's
    void newDiscovery(String ip, Map<String, dynamic> hosts, List<Map<String,dynamic>> newChannels) {
      print("newDiscovery - new apb IP = $ip");
      print("--- hosts: $hosts");
      print("--- newChannels: $newChannels");

      // Keep track of all channels discovered to date
      setState( () {
        channels = newChannels;
      });

      // Note: this sets the channel list into the UI immediately upon discovery of any AF box
      // The AudioFetch listening app exits discovery only after a 6 second discovery
      // period. You may want to set a timer for the 6 second discovery and only call
      // setState to update the UI after this timer expires.
    }

    // callback from disco to here for logging
    void discoLog(String str) {
      print("AFDisco: $str");
    }

    // callback from afdiscovery - add channel
    void addFromApbJson(v) {
      // not used
    }

The discoLog and addFromApbJson methods can be ignored, the newDiscovery() is called once per AF box discovered on the local network. The hosts Map contains a map of ip address to decoded json information about every box and ususally isn't used. The newChannels contains a list of Maps that contain information about all channels found, in this sample app, it is an instance variable:

    List<Map<String,dynamic>> channels;

Each channel entry contains a uiChNum, an ip and a chNum. The uiChNum is the channel number displayed in the AudioFetch listening app available on the stores, and the ip and chNum are the ip address and box channel number corresponding to that channel.

To play an audio stream, call:

    startAudio(String ip, int ch) async {
      try {
        await _afAudioFlutterPlugin.startAudio(ip,ch);
      } on PlatformException {
        print("startAudio failed");
      }
    }

This starts audio on the specified ip and box channel number.

Similarly, to mute or unmute audio, call:

    muteAudio() async {
      try {
        await _afAudioFlutterPlugin.muteAudio();
      } on PlatformException {
        print("muteAudio failed");
      }
    }

    unMuteAudio() async {
      try {
        await _afAudioFlutterPlugin.unMuteAudio();
      } on PlatformException {
        print("unMuteAudio failed");
      }
    }

Finally, the audio service can be stopped and restarted:

    _afAudioFlutterPlugin.stopService();

    _afAudioFlutterPlugin.startService();

When the service is stopped, calls to play, mute, etc do not have any effect.


## iOS-specific Integration

To finish the integration of the audio lib on ios, the framework needs to be included.

For App target:
Build Settings > Link Binary with Libraries, add the AudioFetchSDK.xcframework

For both App target and Pods target:
Build Settings > Excluded Architectures, in Debug > Any iOS Simulator SDK, add arm64

Additionally, to run on devices you must obtain and install the Multicast Entitlement from Apple.


## Android Integration

Android requires a number of permissions for local network access and for the foreground audio service, please see the manifest file in this example.



