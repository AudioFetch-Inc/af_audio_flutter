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

  } else if ([@"stopService" isEqualToString:call.method]) {
    AudioManager* audioManager = AudioManager.shared;
    [audioManager stopService];
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

  } else if ([@"printLog" isEqualToString:call.method]) {
    AudioManager* audioManager = AudioManager.shared;
    char* cLog = [audioManager memlog_get];
    if (strlen(cLog) > 0) {
        NSLog(@"Log: %s", cLog);
        [audioManager memlog_clear];
    }
    result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
