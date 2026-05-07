import 'package:flutter/cupertino.dart';

import '../model/te_ui_property.dart';
import 'te_beauty_panel_view.dart';

abstract class TEBeautyPanelViewCallBack {
  /// Used when updating beauty attributes
  void onUpdateEffect(TESDKParam sdkParam);

  /// Used for updating multiple beauty attributes
  void onUpdateEffectList(List<TESDKParam> sdkParams);

  /// Returns the default beauty effect list attributes
  void onDefaultEffectList(List<TESDKParam> paramList);

  /// Triggered when Green Screen or Custom segmentation is clicked
  void onClickCustomSeg(TEUIProperty uiProperty);

  void onRevertBtnClick(BuildContext context, TEBeautyPanelView panelView);

  /// Used to reset beauty effects and panel UI
  void revertEffectAndPanelView(BuildContext context);

  /// Called when a title tab is clicked
  void onTitleClick(TEUIProperty uiProperty);

  /// 对比按钮点击事件
  void onCompareBtnPressed(bool pressed);
}
