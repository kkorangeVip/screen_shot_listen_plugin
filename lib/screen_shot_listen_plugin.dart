import 'package:flutter/services.dart';

class ScreenShotListenPlugin {
  static final ScreenShotListenPlugin instance = ScreenShotListenPlugin._internal();

  static const MethodChannel _channel = MethodChannel("screen_shot_listen_plugin");
  static const EventChannel _screenShotEventChannel =
  EventChannel("cece_screen_shot_listen_event_channel");

  Function(String path)? screenShotListener;
  Function()? noPermissionListener;

  ScreenShotListenPlugin._internal() {
    _screenShotEventChannel.receiveBroadcastStream().listen((data) {
      if (data['code'] == 0) {
        screenShotListener?.call(data['path']);
      } else if (data['code'] == -1) {
        noPermissionListener?.call();
      }
    });
  }

  Future<void> startListen() async {
    await _channel.invokeMethod("startListen");
  }

  Future<void> stopListen() async {
    await _channel.invokeMethod("stopListen");
  }

  void setListeners({
    Function(String path)? onScreenShot,
    Function()? onNoPermission,
  }) {
    screenShotListener = onScreenShot;
    noPermissionListener = onNoPermission;
  }
}