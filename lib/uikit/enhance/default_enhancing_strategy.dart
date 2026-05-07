import '../constant/te_constant.dart';
import '../model/te_ui_property.dart';
import 'te_param_enhancing_strategy.dart';

/// Default implementation of [TEParamEnhancingStrategy].
/// Applies differentiated multipliers based on effect type.
class DefaultEnhancingStrategy implements TEParamEnhancingStrategy {
  @override
  int enhanceValue(TESDKParam param) {
    double multiple;
    switch (param.effectName) {
      case TEffectName.EFFECT_LUT:
      case TEffectName.EFFECT_MAKEUP:
      case TEffectName.EFFECT_MOTION:
      case TEffectName.EFFECT_SEGMENTATION:
      case TEffectName.BODY_AUTOTHIN_BODY_STRENGTH:
      case TEffectName.BODY_LEG_STRETCH:
      case TEffectName.BODY_ENLARGE_CHEST_STRENGTH:
      case TEffectName.BODY_SLIM_HEAD_STRENGTH:
      case TEffectName.BODY_SLIM_LEG_STRENGTH:
      case TEffectName.BODY_SLIM_ARM_STRENGTH:
      case TEffectName.BODY_WAIST_STRENGTH:
      case TEffectName.BODY_THIN_SHOULDER_STRENGTH:
        return param.effectValue;
      case TEffectName.BEAUTY_FACE_REMOVE_WRINKLE:
      case TEffectName.BEAUTY_FACE_REMOVE_LAW_LINE:
      case TEffectName.BEAUTY_MOUTH_LIPSTICK:
      case TEffectName.BEAUTY_WHITEN_0:
      case TEffectName.BEAUTY_WHITEN:
      case TEffectName.BEAUTY_WHITEN_2:
      case TEffectName.BEAUTY_WHITEN_3:
      case TEffectName.BEAUTY_FACE_SOFTLIGHT:
      case TEffectName.BEAUTY_FACE_SHORT:
      case TEffectName.BEAUTY_FACE_V:
      case TEffectName.BEAUTY_EYE_DISTANCE:
      case TEffectName.BEAUTY_NOSE_HEIGHT:
        multiple = 1.3;
        break;
      case TEffectName.BEAUTY_EYE_LIGHTEN:
        multiple = 1.5;
        break;
      case TEffectName.BEAUTY_FACE_RED_CHEEK:
        multiple = 1.8;
        break;
      default:
        multiple = 1.2;
        break;
    }
    return (multiple * param.effectValue).toInt();
  }
}
