#import "AfAudioFlutterPlugin.h"
#import "AudioManager.h"


@implementation AfAudioFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"af_audio_flutter"
            binaryMessenger:[registrar messenger]];
  AfAudioFlutterPlugin* instance = [[AfAudioFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  
  } else if ([@"startService" isEqualToString:call.method]) {
    AudioManager* audioManager = AudioManager.shared;
    [audioManager startService];
    result(nil);

  } else if ([@"startAudio" isEqualToString:call.method]) {
    AudioManager* audioManager = AudioManager.shared;
    NSString* ip = call.arguments[@"ip"];
    NSString* ch = call.arguments[@"ch"];
    NSLog(@"ip: %@, ch: %@", ip, ch);
    [audioManager startAudioOn: ip channel: [ch integerValue]];
    result(nil);

  } else if ([@"muteAudio" isEqualToString:call.method]) {
    AudioManager* audioManager = AudioManager.shared;
    [audioManager muteAudio];
    result(nil);

  } else if ([@"unMuteAudio" isEqualToString:call.method]) {
    AudioManager* audioManager = AudioManager.shared;
    [audioManager unMuteAudio];
    result(nil);

  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
