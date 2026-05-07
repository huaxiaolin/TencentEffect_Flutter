import 'dart:convert';
import '../../model/xmagic_property.dart';
import '../tencent_effect_api_base.dart';

/// Android Api
class TencentEffectApiAndroid extends TencentEffectApiBase {
  static const String TAG = "TencentEffectApiAndroid";

  Map<String, AddAiModeCallBack> _addAiModeCallBackMap = new Map();

  @override
  String get tag => TAG;


  @override
  void handleTipsNeedShow(Map parameter) {
    Map map = parameter['data'];
    String tips = map['tips'] as String;
    String tipsIcon = map['tipsIcon'] as String;
    int type = map['type'] as int;
    int duration = map['duration'] as int;
    xmagicTipsListener?.tipsNeedShow(tips, tipsIcon, type, duration);
  }

  @override
  void handleTipsNeedHide(Map parameter) {
    Map map = parameter['data'];
    String tips = map['tips'] as String;
    String tipsIcon = map['tipsIcon'] as String;
    int type = map['type'] as int;
    xmagicTipsListener?.tipsNeedHide(tips, tipsIcon, type);
  }

  @override
  void handlePlatformSpecificCallback(String methodName, Map parameter) {
    if (methodName == "addAiMode") {
      Map map = parameter['data'];
      String inputDir = map['input'] as String;
      int code = map['code'] as int;
      AddAiModeCallBack callBack = _addAiModeCallBackMap[inputDir] as AddAiModeCallBack;
      callBack(inputDir, code);
      _addAiModeCallBackMap.remove(inputDir);
    } else if (methodName == "onXmagicPropertyError") {
      Map map = parameter['data'];
      String msg = map['msg'] as String;
      int code = map['code'] as int;
      if (onCreateXmagicApiErrorListener != null) {
        onCreateXmagicApiErrorListener!(msg, code);
      }
    }
  }

  @override
  XmagicProperty parsePropertyFromKey(dynamic key) {
    return XmagicProperty.fromJson(json.decode(key));
  }

  // ==================== Android 平台特有方法 ====================

  /// 添加 AI 模型，
  void addAiMode(String inputDir, String resDir, AddAiModeCallBack callBack) {
    this._addAiModeCallBackMap[inputDir] = callBack;
    Map<String, String> parameter = {"input": inputDir, "res": resDir};
    channel.invokeMethod("addAiMode", parameter);
  }

  /// 设置动态库路径并加载，so的位置需要在 内部安装目录下
  Future<bool> setLibPathAndLoad(String libPath) async {
    var result = await channel.invokeMethod("setLibPathAndLoad", libPath);
    return result;
  }
}

typedef AddAiModeCallBack = void Function(String inputDir, int code);