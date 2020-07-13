import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AndroidBackTop {
  static const String CHANNEL = "android/back/desktop";

  //设置回退到手机桌面
  static Future<bool> backDeskTop() async {
    final platform = MethodChannel(CHANNEL);
    //通知安卓返回,到手机桌面
    try {
      final bool out = await platform.invokeMethod('backDesktop');
//      if (out) debugPrint('返回到桌面');
    } on PlatformException catch (e) {
//      debugPrint("通信失败(设置回退到安卓手机桌面:设置失败)");
//      print(e.toString());
    }
    return Future.value(false);
  }

  static Future setBadges(String badge) async{
    final platform = MethodChannel(CHANNEL);
    //通知安卓返回,到手机桌面
    try {
      Map<String,String> map = {"badge":badge};
      await platform.invokeMethod('setBadges',map);
//      if (out) debugPrint('返回到桌面');
    } on PlatformException catch (e) {
//      debugPrint("通信失败(设置回退到安卓手机桌面:设置失败)");
//      print(e.toString());
    }
    return Future.value(false);
  }
}