import 'dart:core';
import 'dart:ui';
import '../model/te_panel_data_model.dart';
import '../model/te_ui_property.dart';

class TEResConfig {
  List<TEPanelDataModel> defaultPanelDataList = [];

  TEResConfig._internal();

  Color panelBackgroundColor = const Color(0x66000000);  //Default background color

  bool revertEffect2Json = true;   //如果设置为true,
  // 那么在点击面板还原按钮的时候就会还原到json配置的状态，否则还原到进入面板设置了 lastParam的状态

  bool cleanLightMakeup = false;   //此配置是当设置滤镜，或者单点美妆的时候是否清理轻美妆

  static TEResConfig? resConfig;

  static TEResConfig getConfig() {
    resConfig ??= TEResConfig._internal();
    return resConfig!;
  }

 
  void setBeautyRes(String resourcePath) {
    defaultPanelDataList.add(TEPanelDataModel(resourcePath, UICategory.BEAUTY));
  }


  void setBeautyBodyRes(String resourcePath) {
    defaultPanelDataList
        .add(TEPanelDataModel(resourcePath, UICategory.BODY_BEAUTY));
  }


  void setLutRes(String resourcePath) {
    defaultPanelDataList.add(TEPanelDataModel(resourcePath, UICategory.LUT));
  }


  void setMakeUpRes(String resourcePath) {
    defaultPanelDataList.add(TEPanelDataModel(resourcePath, UICategory.MAKEUP));
  }


  void setMotionRes(String resourcePath) {
    defaultPanelDataList.add(TEPanelDataModel(resourcePath, UICategory.MOTION));
  }


  void setSegmentationRes(String resourcePath) {
    defaultPanelDataList
        .add(TEPanelDataModel(resourcePath, UICategory.SEGMENTATION));
  }

  void setLightMakeupRes(String resourcePath) {
    defaultPanelDataList
        .add(TEPanelDataModel(resourcePath, UICategory.LIGHT_MAKEUP));
  }

  void setBeautyTemplateRes(String resourcePath) {
    defaultPanelDataList
        .add(TEPanelDataModel(resourcePath, UICategory.BEAUTY_TEMPLATE));
  }

  List<TEPanelDataModel> getPanelDataList() {
    return defaultPanelDataList;
  }
}
