import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'file_preview_widget.dart';
part 'file_preview_callback.dart';
part 'file_preview_controller.dart';

class FilePreview {
  static const MethodChannel _channel = MethodChannel('file_preview');

  static Future<bool> initTBS() async {
    final bool init = await _channel.invokeMethod('initTBS');
    return init;
  }

  static Future<bool> tbsHasInit() async {
    return await _channel.invokeMethod('tbsHasInit');
  }

  static Future<bool> deleteCache() async {
    return await _channel.invokeMethod('deleteCache');
  }

  static Future<String> tbsVersion() async {
    return await _channel.invokeMethod('tbsVersion');
  }

  static Future<String> tbsDebug() async {
    return await _channel.invokeMethod('tbsDebug');
  }

  static nativeMessageListener(Function func) {
    _channel.setMethodCallHandler((resultCall) {
      print('resultCall:${resultCall.toString()}');
      //处理原生 Android iOS 发送过来的消息
      var code = jsonDecode(resultCall.arguments)['arg1'];
      func(code);
      throw resultCall;
    });
  }
}
