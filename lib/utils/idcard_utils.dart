import 'dart:io';
import 'dart:convert' as convert;
import 'package:flutter/services.dart';

/**
 * 身份证读卡器插件
 */
class IDCardUtils{

  static const MethodChannel _channel = const MethodChannel('idcard_plugin');

  /**
   * 初始化并连接机器
   */
  static Future<bool> initDevice() async {
      bool init = await _channel.invokeMethod('init');
      print('initDevice------$init');
      if(init){
        bool connect = await _channel.invokeMethod('connect');
        return connect;
      }
      return false;
  }

  /**
   * 读取身份证信息
   */
  static Future<Map<String,dynamic>> read() async{
    String result = await _channel.invokeMethod('read');
    Map<String,dynamic> map = convert.jsonDecode(result);
    return map;
  }
}