import 'package:flutter/material.dart';
import '../../constant/te_constant.dart';
import '../../model/te_ui_property.dart';

class SliderViewModel {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final bool isShowSliderTypeLayout;
  final List<bool> selectedList;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;
  final ValueChanged<int> onSliderTypeClick;

  SliderViewModel({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.isShowSliderTypeLayout,
    required this.selectedList,
    required this.onChanged,
    required this.onChangeEnd,
    required this.onSliderTypeClick,
  });

  SliderViewModel copyWith({
    double? value,
    List<bool>? selectedList,
  }) {
    return SliderViewModel(
      value: value ?? this.value,
      min: min,
      max: max,
      divisions: divisions,
      isShowSliderTypeLayout: isShowSliderTypeLayout,
      selectedList: selectedList ?? this.selectedList,
      onChanged: onChanged,
      onChangeEnd: onChangeEnd,
      onSliderTypeClick: onSliderTypeClick,
    );
  }
}

class SliderAdapter {
  static SliderViewModel? fromSDKParam(
    TESDKParam? sdkParam,
    List<bool> selectedList, {
    required ValueChanged<double> onValueChange,
    required ValueChanged<double> onChangeEnd,
    required ValueChanged<int> onTypeClick,
  }) {
    if (sdkParam == null) return null;

    // Beauty template should not show slider
    if (sdkParam.effectName == TESDKParam.BEAUTY_TEMPLATE_EFFECT_NAME) return null;

    // MOTION and SEGMENTATION should not show slider (range 0,0)
    if (sdkParam.effectName == TEffectName.EFFECT_MOTION ||
        sdkParam.effectName == TEffectName.EFFECT_SEGMENTATION) return null;

    bool isShowSliderTypeLayout = (sdkParam.effectName == TEffectName.EFFECT_MAKEUP ||
            sdkParam.effectName == TEffectName.EFFECT_LIGHT_MAKEUP) &&
        (sdkParam.extraInfo?[TESDKParam.EXTRA_INFO_KEY_LUT_STRENGTH] != null);

    EffectValueType valueType = EffectValueType.getEffectValueType(sdkParam);
    bool isShowSlider = valueType != EffectValueType.RANGE_0_0;

    if (!isShowSlider) return null;

    double currentProgress;
    double progressMax;
    double progressMin;

    bool isLutMode = isShowSliderTypeLayout && selectedList.length > 1 && selectedList[1];

    if (isLutMode) {
      String? makeupLutStrength = sdkParam.extraInfo?[TESDKParam.EXTRA_INFO_KEY_LUT_STRENGTH];
      currentProgress = makeupLutStrength != null ? double.parse(makeupLutStrength) : 0.0;
      progressMax = 100;
      progressMin = 0;
    } else {
      currentProgress = sdkParam.effectValue.toDouble();
      progressMax = valueType.max.toDouble();
      progressMin = valueType.min.toDouble();
    }

    int divisions = (progressMax - progressMin).toInt();
    if (divisions <= 0) divisions = 100;

    return SliderViewModel(
      value: currentProgress,
      min: progressMin,
      max: progressMax,
      divisions: divisions,
      isShowSliderTypeLayout: isShowSliderTypeLayout,
      selectedList: selectedList,
      onChanged: onValueChange,
      onChangeEnd: onChangeEnd,
      onSliderTypeClick: onTypeClick,
    );
  }

  static void updateSDKParam(TESDKParam sdkParam, double value, bool isLutMode) {
    int localValue = value.round();
    if (isLutMode) {
      sdkParam.extraInfo?[TESDKParam.EXTRA_INFO_KEY_LUT_STRENGTH] = localValue.toString();
    } else {
      sdkParam.effectValue = localValue;
    }
  }
}
