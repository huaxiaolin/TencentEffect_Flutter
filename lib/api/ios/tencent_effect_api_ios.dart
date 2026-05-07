import '../../model/xmagic_property.dart';
import '../tencent_effect_api_base.dart';

/// iOS Api
class TencentEffectApiIOS extends TencentEffectApiBase {
  static const String TAG = "TencentEffectApiIOS";

  @override
  String get tag => TAG;


  @override
  void handleTipsNeedShow(Map parameter) {
    String tips = parameter['tips'] as String;
    String tipsIcon = parameter['tipsIcon'] as String;
    int type = parameter['type'] as int;
    int duration = parameter['duration'] as int;
    xmagicTipsListener?.tipsNeedShow(tips, tipsIcon, type, duration);
  }

  @override
  void handleTipsNeedHide(Map parameter) {
    String tips = parameter['tips'] as String;
    String tipsIcon = parameter['tipsIcon'] as String;
    int type = parameter['type'] as int;
    xmagicTipsListener?.tipsNeedHide(tips, tipsIcon, type);
  }

  @override
  XmagicProperty parsePropertyFromKey(dynamic key) {
    return XmagicProperty.fromJson(key);
  }
}