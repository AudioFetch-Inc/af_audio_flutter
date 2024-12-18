import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:af_audio_flutter/af_audio_flutter.dart';
import 'package:af_disco_module/AfDiscovery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _afAudioFlutterPlugin = AfAudioFlutter();

  List<Map<String,dynamic>> channels = [];

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();

    // Init and start discovery
    AfDiscovery.init(this);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    try {
          await _afAudioFlutterPlugin.startService();
    } on PlatformException {
      print("Failed to start audio service.");
    }
  }


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

  // callback from afdiscovery with complete APB information
  void addFromApbJson(v) {
    print("addFromApbJson: $v");
  }


  startAudio(String ip, int ch) async {
    try {
      await _afAudioFlutterPlugin.startAudio(ip,ch);
    } on PlatformException {
      print("startAudio failed");
    }
  }

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


  // Form a list of channel selections from our stored channels from discovery.
  List<Widget> channelList() {

    List<Widget> out = [];
    var i = 0;
    while (i < channels.length) {
      Map<String,dynamic> ch = channels[i];

      int uiChNum = ch["uiChNum"];
      String ip = ch["ip"];
      int chNum = ch["chNum"];
      out += [ 
          ListTile(
              leading: const Icon(Icons.audiotrack),
              title: Padding(padding:EdgeInsets.all(14), child: Text("Channel $uiChNum", style: Theme.of(context).textTheme.titleLarge)),
              onTap: () {
                print("play on chNum $chNum");
                startAudio(ip, chNum);
                setState( () {isPlaying = true;} );
              }
          )
      ];

      i += 1;
    }

    return out;
  }


  @override
  Widget build(BuildContext context) {

  var buttonStyle = TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.white,
                  minimumSize: Size(360, 50), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  padding: EdgeInsets.all(10),
                  textStyle: Theme.of(context).textTheme.headlineSmall,
              );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body:  
            Column( children: [
              Expanded( child:
                ListView(
                  shrinkWrap: true,
                  children: channelList(),
              ), ),

              Container( child: Column(children: [
                  SizedBox(height: 10),
                  (isPlaying == true) ? 
                      TextButton(
                      child: Text('Pause'),
                      style: buttonStyle,
                      onPressed: (() { 
                        muteAudio();
                        setState( () {isPlaying = false;});
                      }),
                    )
                  :
                    TextButton(
                      child: Text('Play'),
                      style: buttonStyle,
                      onPressed: (() { 
                        unMuteAudio();
                        setState( () {isPlaying = true;});
                      }),
                    )
                  ,
                  SizedBox(height: 10),
                ])),
              ]))
      );
  }
}
