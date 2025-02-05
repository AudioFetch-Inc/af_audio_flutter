package com.audiofetch.af_audio_flutter;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import android.app.Activity;


// af_audio imports
import com.audiofetch.afaudiolib.bll.app.AFAudioService;
import com.audiofetch.afaudiolib.api.AfApi;
import android.content.ServiceConnection;
import android.content.ComponentName;
import android.os.IBinder;
import android.content.Intent;
import android.content.Context;
import android.os.Handler;
import android.util.Log;
import java.util.HashMap;
import java.util.Iterator;
import java.util.ArrayList;


/** AfAudioFlutterPlugin */
public class AfAudioFlutterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  // AFAudio
  protected AFAudioService mAFAudioSvc = null;
  protected boolean mIsAFAudioSvcBound = false;
  protected ServiceConnection mAFAudioSvcConn = null;
  protected Handler mUiHandler = new Handler();

  private Context context;
  private Activity activity;

  @Override
  public void onDetachedFromActivity() {
    //TODO("Not yet implemented")
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    //TODO("Not yet implemented")
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    //TODO("Not yet implemented")
  }


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "af_audio_flutter");
    channel.setMethodCallHandler(this);

    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } 
    else if (call.method.equals("startService")) {
      startAFAudioService();
      result.success(true);
    }
    else if (call.method.equals("stopService")) {
      stopAFAudioService();
      result.success(true);
    }
    else if (call.method.equals("startAudio")) {
      // Tell the audio service to play that channel

      // get parameters
      String ip = call.argument("ip");
      int ch = call.argument("ch");
      AFAudioService.api().setApbAndChannel( ip, ch, "Ch 0");
      result.success(true);
    }
    else if (call.method.equals("muteAudio")) {
      AFAudioService.api().muteAudio();
      result.success(true);
    }
    else if (call.method.equals("unMuteAudio")) {
      AFAudioService.api().unmuteAudio();
      result.success(true);
    }

    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  protected void startAFAudioService() {
      if (mAFAudioSvc == null) {
          final Intent serviceIntent = new Intent(activity, AFAudioService.class);
          // Start audio service in as a foreground service
          //bye Context context = getApplicationContext();
          context.startForegroundService(serviceIntent);
          //bindService(new Intent(this, AFAudioService.class), getAFAudioServiceConnection(), 0);
          activity.bindService(new Intent(activity, AFAudioService.class), getAFAudioServiceConnection(), 0);
      }
  }

    // Connect to the started AF audio service.
    protected ServiceConnection getAFAudioServiceConnection() {
        if (mAFAudioSvcConn == null) {
            mAFAudioSvcConn = new ServiceConnection() {
                @Override
                public void onServiceConnected(ComponentName className, IBinder service) {
                    if (service instanceof AFAudioService.AFAudioBinder) {
                        //LG.Debug(TAG, "AFAudioService connected");
                        AFAudioService.AFAudioBinder binder = (AFAudioService.AFAudioBinder) service;
                        mAFAudioSvc = binder.getService();

                        if (null != mAFAudioSvc) {
                            //Context ctx = getApplicationContext();
                            // app context must be set before initing audio subsystem
                            AFAudioService.api().setAppContext( context ); //getApplicationContext() );
                            AFAudioService.api().initAudioSubsystem();

                            mIsAFAudioSvcBound = true;
                            mAFAudioSvc.hideNotifcations();

                            mUiHandler.post(new Runnable() {
                                @Override
                                public void run() {
                                    startAFAudioServiceAudio();
                                }
                            });

                            // Subscribe to API messages.
                            //doSubscriptions();
                        }
                    }
                }

                @Override
                public void onServiceDisconnected(ComponentName componentName) {
                    mIsAFAudioSvcBound = false;
                    mAFAudioSvcConn = null;
                    mAFAudioSvc = null;
                }
            };
        }
        return mAFAudioSvcConn;
    }


    // Tell the AF Audio service to start playing audio.
    protected boolean startAFAudioServiceAudio() {
        boolean started = false;
        if (mAFAudioSvc != null) {
            started = true;
            mUiHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    AFAudioService.api().startAudio();
                }
            }, 500);
        }
        return started;
    }

    // Tell the AF Audio service to stop playing audio.
    protected void stopAFAudioService() {
        if (mAFAudioSvc != null) {
            mAFAudioSvc.hideNotifcations();
            if (mIsAFAudioSvcBound && null != mAFAudioSvcConn) {
                activity.unbindService(mAFAudioSvcConn);
            }
            mAFAudioSvc.quit();
            mAFAudioSvc = null;
        }
    }
}
