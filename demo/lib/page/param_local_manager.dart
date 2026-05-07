import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_effect_flutter/uikit/model/te_ui_property.dart';

class ParamLocalManager {
  static const String beautyParamKey = "beauty_Params_key";

  static void saveBeautyParam(List<TESDKParam> sdkParams) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String params = json.encode(sdkParams);
    sharedPreferences.setString(beautyParamKey, params);
  }

  static Future<List<TESDKParam>?> getBeautyParam() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? params = sharedPreferences.getString(beautyParamKey);
    if (params != null) {
      List<dynamic> data = json.decode(params);
      List<TESDKParam> resultData = [];
      for (var element in data) {
        resultData.add(TESDKParam.fromJson(element));
      }
      return resultData;
    }
    return null;
  }
}
