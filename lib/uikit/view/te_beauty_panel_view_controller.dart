import 'package:flutter/cupertino.dart';
import '../model/te_ui_property.dart';

class TEBeautyPanelController {
  ValueChanged<TEUIProperty>? _onCheckPanelViewItem;
  ValueGetter<Future<List<TESDKParam>>>? _getRevertPanelData;

  void bind({
    ValueChanged<TEUIProperty>? onCheckPanelViewItem,
    ValueGetter<Future<List<TESDKParam>>>? getRevertPanelData,
  }) {
    _onCheckPanelViewItem = onCheckPanelViewItem;
    _getRevertPanelData = getRevertPanelData;
  }

  void checkPanelViewItem(TEUIProperty uiProperty) {
    _onCheckPanelViewItem?.call(uiProperty);
  }

  Future<List<TESDKParam>?> getRevertPanelData() {
    return _getRevertPanelData?.call() ?? Future.value(<TESDKParam>[]);
  }

  void dispose() {
    _onCheckPanelViewItem = null;
    _getRevertPanelData = null;
  }
}
