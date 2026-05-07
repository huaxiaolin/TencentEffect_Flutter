import 'package:flutter/material.dart';
import '../../uikit/view/widget/revert_button.dart';
import '../../uikit/view/widget/compare_button.dart';
import '../../uikit/view/widget/te_download_progress_dialog.dart';
import '../config/te_res_config.dart';
import '../download/te_material_checker.dart';
import '../model/te_ui_property.dart';
import '../producer/te_general_data_producer.dart';
import '../producer/te_panel_data_producer.dart';
import '../l10n/te_panel_localizations.dart';
import '../utils/te_producer_utils.dart';
import 'te_beauty_panel_view_callback.dart';
import 'te_beauty_panel_view_controller.dart';
import 'widget/beauty_panel_slider.dart';
import 'model/te_slider_view_model.dart';

class TEBeautyPanelView extends StatefulWidget {
  final TEBeautyPanelController? controller;
  final TEBeautyPanelViewCallBack? _beautyPanelViewCallBack;

  final int onSliderUpdateValueType;
  final TEPanelDataProducer? panelDataProducer;

  const TEBeautyPanelView(
    this._beautyPanelViewCallBack,
    this.panelDataProducer,
    this.controller, {
    super.key,
    this.onSliderUpdateValueType = 1,
  });

  @override
  State<StatefulWidget> createState() {
    return TEPanelViewState();
  }
}

class TEPanelViewState extends State<TEBeautyPanelView> {
  final ScrollController _scrollController = ScrollController();
  final List<double> _listViewOffset = [];
  Map<String, double> typeDataListViewOffset = {};
  SliderViewModel? _sliderViewModel;
  String _subTitleName = "";

  TESDKParam? _currentSDKParam;

  bool _isShowSubTitleLayout = false;

  /// Whether to show sub-tab bar (for hasSubTitle items)
  bool _isShowSubTabBar = false;
  List<TEUIProperty>? _subTabItems;
  int _selectedSubTabIndex = 0;

  List<TEUIProperty>? _currentList;
  List<TEUIProperty>? _panelViewData;

  final List<bool> _selectedList = [true, false];

  /// Whether to use grid layout (for verticalLayout items)
  bool _useGridLayout = false;

  late TEPanelDataProducer _tePanelDataProducer;

  @override
  initState() {
    super.initState();
    if (widget.panelDataProducer != null) {
      _tePanelDataProducer = widget.panelDataProducer!;
    } else {
      _tePanelDataProducer = TEGeneralDataProducer();
      _tePanelDataProducer.setPanelDataList(TEResConfig.getConfig().defaultPanelDataList);
    }
    _getPanelViewData();
    widget.controller?.bind(onCheckPanelViewItem: checkPanelViewItem, getRevertPanelData: getRevertPanelData);
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _getPanelViewData({bool forceRefreshData = false}) async {
    var data = await _tePanelDataProducer.getPanelData(forceRefreshData: forceRefreshData);
    if (widget._beautyPanelViewCallBack != null) {
      List<TESDKParam> usedProperties = _tePanelDataProducer.getUsedProperties();
      widget._beautyPanelViewCallBack?.onDefaultEffectList(usedProperties);
    }
    var dataList = _tePanelDataProducer.getFirstCheckedItems();
    setState(() {
      _panelViewData = data;
      _currentList = dataList;
      _isShowSubTabBar = false;
      _updateLayoutMode();
    });
  }

  Future<List<TESDKParam>> getRevertPanelData() async {
    List<TESDKParam> result = await _tePanelDataProducer.getRevertData();
    _getPanelViewData();
    _setSliderState(null);
    return result;
  }

  void _updateLayoutMode() {
    if (_currentList != null && _currentList!.isNotEmpty) {
      TEUIProperty? parent = _currentList![0].parentUIProperty;
      _useGridLayout = parent != null
          ? (parent.parentUIProperty != null ? parent.parentUIProperty!.verticalLayout : parent.verticalLayout)
          : false;
    } else {
      _useGridLayout = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50, child: _sliderViewModel != null ? _buildSlider(context) : Container()),
        Container(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CompareButton(
                  onPressDown: () {
                    widget._beautyPanelViewCallBack?.onCompareBtnPressed(true);
                  },
                  onPressUp: (){
                    widget._beautyPanelViewCallBack?.onCompareBtnPressed(false);
                  },
                ),
              ),
              Container(
                  color: TEResConfig.getConfig().panelBackgroundColor,
                  child: Column(
                    children: [
                      _isShowSubTitleLayout ? _buildSubTitleLayout() : _buildMainTitleLayout(context),
                      Container(height: 1, color: const Color(0x19FFFFFF), margin: const EdgeInsets.only(bottom: 5)),
                      if (_isShowSubTabBar && _subTabItems != null) _buildSubTabBar(context),
                      SizedBox(
                        height: _useGridLayout ? 130 : 100,
                        child: _useGridLayout ? _buildGridView() : _buildListView(),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListView() {
    return Container(
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: buildListViewItem,
        itemCount: _currentList?.length,
      ),
      margin: const EdgeInsets.only(top: 10),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 0.75,
      ),
      itemBuilder: buildListViewItem,
      itemCount: _currentList?.length,
    );
  }

  Widget _buildSubTabBar(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _subTabItems?.length ?? 0,
        itemBuilder: (context, index) {
          TEUIProperty item = _subTabItems![index];
          bool isSelected = index == _selectedSubTabIndex;
          return TextButton(
            onPressed: () {
              setState(() {
                _selectedSubTabIndex = index;
                _currentList = item.propertyList;
                _updateLayoutMode();
              });
              _scrollController.jumpTo(0);
              _setSliderState(null);
            },
            child: Text(
              TEPanelLocalizations.of(context).getDisplayName(item) ?? '',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubTitleLayout() {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          iconSize: 22,
          onPressed: onSubTitleBackBtnClick,
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        Text(_subTitleName, style: const TextStyle(color: Colors.white)),
        Container(width: 30),
      ],
    );
  }

  Widget _buildMainTitleLayout(BuildContext context) {
    List<Widget> titlesView = [];
    if (_panelViewData == null) {
      return Container();
    }
    bool hasFirstItemChecked = false;
    for (TEUIProperty property in _panelViewData!) {
      titlesView.add(
        TextButton(
          onPressed: () {
            _onMainTitleItemClick(property);
          },
          child: Text(
            TEPanelLocalizations.of(context).getDisplayName(property)!,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  property.uiState == UIState.CHECKED_AND_IN_USE && !hasFirstItemChecked ? Colors.blue : Colors.white,
            ),
          ),
        ),
      );
      if (property.uiState == UIState.CHECKED_AND_IN_USE) {
        hasFirstItemChecked = true;
      }
    }
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: titlesView,
            ),
          ),
        ),
        RevertButton(
          onPressed: () {
            widget._beautyPanelViewCallBack?.onRevertBtnClick(context, widget);
          },
        ),
      ],
    );
  }

  Widget _buildSlider(BuildContext context) {
    if (_sliderViewModel == null) return Container();
    return BeautyPanelSlider(
      isShowSliderTypeLayout: _sliderViewModel!.isShowSliderTypeLayout,
      selectedList: _sliderViewModel!.selectedList,
      onSliderTypeClick: _sliderViewModel!.onSliderTypeClick,
      value: _sliderViewModel!.value,
      min: _sliderViewModel!.min,
      max: _sliderViewModel!.max,
      divisions: _sliderViewModel!.divisions,
      onChanged: _sliderViewModel!.onChanged,
      onChangeEnd: _sliderViewModel!.onChangeEnd,
    );
  }

  void _onSliderTypeClick(index) {
    var length = _selectedList.length;
    setState(() {
      for (int i = 0; i < length; i++) {
        _selectedList[i] = index == i;
      }
    });
    _setSliderState(_currentSDKParam);
  }

  Widget _buildListViewItemIcon(int index) {
    if (_currentList?[index].icon?.isNotEmpty ?? false) {
      return Container(
        width: 45,
        height: 45,
        padding: const EdgeInsets.all(1),
        decoration: _currentList?[index].uiState == UIState.CHECKED_AND_IN_USE
            ? BoxDecoration(
                border: Border.all(width: 1, color: Colors.blue.shade500),
                borderRadius: BorderRadius.circular(8),
              )
            : BoxDecoration(
                border: Border.all(width: 1, color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
        child: Image.asset("assets/${_currentList?[index].icon}", width: 45, height: 45),
      );
    }
    return Container();
  }

  Widget buildListViewItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        _onListViewItemClick(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(margin: const EdgeInsets.fromLTRB(10, 0, 10, 0), child: _buildListViewItemIcon(index)),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Text(
              _currentList?[index] == null
                  ? ""
                  : TEPanelLocalizations.of(context).getDisplayName(_currentList![index])!,
              style: const TextStyle(color: Colors.white, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: _isShowPoint(_currentList?[index]) ? Colors.blue : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(3)),
            ),
          ),
        ],
      ),
    );
  }

  bool _isShowPoint(TEUIProperty? uiProperty) {
    if (uiProperty == null) {
      return false;
    }
    if (UICategory.BEAUTY == uiProperty.uiCategory) {
      if (uiProperty.propertyList != null) {
        for (TEUIProperty uiProperty in uiProperty.propertyList!) {
          bool isShow = _isShowPoint(uiProperty);
          if (isShow) {
            return true;
          }
        }
      } else {
        int? value = uiProperty.sdkParam?.effectValue;
        if (value != null && value != 0 && uiProperty.uiState != UIState.INIT) {
          return true;
        }
      }
    }
    return false;
  }

  void onSubTitleBackBtnClick() {
    if (_currentList != null) {
      TEUIProperty titleProperty = _getParentProperty();
      TEUIProperty? parentUIProperty = titleProperty.parentUIProperty;
      if (parentUIProperty == null || parentUIProperty.parentUIProperty == null) {
        for (TEUIProperty property in _panelViewData!) {
          if (property.uiState == UIState.CHECKED_AND_IN_USE) {
            setState(() {
              _isShowSubTitleLayout = false;
              _isShowSubTabBar = false;
              _currentList = property.propertyList;
              _updateLayoutMode();
            });
            if (_listViewOffset.isNotEmpty) {
              _scrollController.jumpTo(_listViewOffset.removeLast());
            }
            _setSliderState(null);
            return;
          }
        }
      } else {
        setState(() {
          _isShowSubTitleLayout = true;
          _subTitleName = TEPanelLocalizations.of(context).getDisplayName(parentUIProperty)!;
          _currentList = parentUIProperty.propertyList;
          _updateLayoutMode();
        });
      }
      if (_listViewOffset.isNotEmpty) {
        _scrollController.jumpTo(_listViewOffset.removeLast());
      }
      _setSliderState(null);
    }
  }

  TEUIProperty _getParentProperty() {
    TEUIProperty uiProperty = _currentList![0];
    return uiProperty.parentUIProperty!;
  }

  void _onMainTitleItemClick(TEUIProperty uiProperty) {
    for (TEUIProperty property in _panelViewData!) {
      if (property.uiState == UIState.CHECKED_AND_IN_USE) {
        typeDataListViewOffset[_getTypeDataListViewOffsetKey(property)] = _scrollController.offset;
        break;
      }
    }
    _tePanelDataProducer.onTabItemClick(uiProperty);
    widget._beautyPanelViewCallBack?.onTitleClick(uiProperty);

    // Handle hasSubTitle: show sub-tab bar
    if (uiProperty.hasSubTitle && uiProperty.propertyList != null && uiProperty.propertyList!.isNotEmpty) {
      setState(() {
        _isShowSubTitleLayout = false;
        _isShowSubTabBar = true;
        _subTabItems = uiProperty.propertyList;
        _selectedSubTabIndex = 0;
        _currentList = uiProperty.propertyList![0].propertyList;
        _updateLayoutMode();
      });
    } else {
      setState(() {
        _isShowSubTitleLayout = false;
        _isShowSubTabBar = false;
        _subTabItems = null;
        _currentList = uiProperty.propertyList;
        _updateLayoutMode();
      });
    }
    double? offset = typeDataListViewOffset[_getTypeDataListViewOffsetKey(uiProperty)];
    _scrollController.jumpTo(offset ?? 0);
    _setSliderState(null);
  }

  void _onListViewItemClick(int index) async {
    TEUIProperty uiProperty = _currentList![index];

    // Check for green screen v2 import image item
    if (uiProperty.isGSV2ImportImageItem()) {
      TEUIProperty? parentProperty = uiProperty.parentUIProperty;
      if (parentProperty?.sdkParam?.extraInfo != null) {
        parentProperty!.sdkParam!.extraInfo![TESDKParam.GREEN_PARAMS_V2] =
            TEProducerUtils.getGreenParamsV2(parentProperty);
        uiProperty.sdkParam = parentProperty.sdkParam;
      }
      widget._beautyPanelViewCallBack?.onClickCustomSeg(uiProperty);
      return;
    }

    // Check for green screen / custom segmentation
    String? segType = uiProperty.sdkParam?.extraInfo?[TESDKParam.EXTRA_INFO_KEY_SEG_TYPE];
    if (segType != null &&
        (TESDKParam.EXTRA_INFO_SEG_TYPE_GREEN.contains(segType) || segType == TESDKParam.EXTRA_INFO_SEG_TYPE_CUSTOM)) {
      // Green screen V2: check if has background path, enter sub-items
      if (segType == TESDKParam.EXTRA_INFO_SEG_TYPE_GREEN[1]) {
        uiProperty.sdkParam?.extraInfo?[TESDKParam.GREEN_PARAMS_V2] = TEProducerUtils.getGreenParamsV2(uiProperty);
        if (uiProperty.sdkParam?.extraInfo?[TESDKParam.EXTRA_INFO_KEY_BG_PATH] != null &&
            uiProperty.sdkParam!.extraInfo![TESDKParam.EXTRA_INFO_KEY_BG_PATH]!.isNotEmpty) {
          _executeItemClickLogic(uiProperty);
          return;
        }
      }
      widget._beautyPanelViewCallBack?.onClickCustomSeg(uiProperty);
      return;
    }

    // Check if material needs download
    final TEMotionDLModel? dlModel = uiProperty.dlModel;
    if (dlModel != null) {
      dlModel.localDir = await TEProducerUtils.getAbsoluteLocalDir(dlModel.localDir!);
      if (!await TEMaterialChecker.isDownloaded(dlModel)) {
        final downloadSuccess = await _showDownloadDialog(uiProperty);
        if (!downloadSuccess) {
          return;
        }
      }
    }
    _executeItemClickLogic(uiProperty);
  }

  Future<bool> _showDownloadDialog(TEUIProperty uiProperty) async {
    return TEDownloadProgressDialog.show(context, uiProperty);
  }

  void _executeItemClickLogic(TEUIProperty uiProperty) {
    List<TEUIProperty>? resultList = _tePanelDataProducer.onItemClick(uiProperty);
    if (resultList != null && resultList.isNotEmpty) {
      _listViewOffset.add(_scrollController.offset);

      _currentSDKParam = null;
      setState(() {
        _currentList = resultList;
        _isShowSubTitleLayout = true;
        _isShowSubTabBar = false;
        _subTitleName = TEPanelLocalizations.of(context).getDisplayName(uiProperty)!;
        _panelViewData = _panelViewData;
        _updateLayoutMode();
      });
      _scrollController.jumpTo(0);
    } else {
      // Handle beauty template
      if (uiProperty.uiCategory == UICategory.BEAUTY_TEMPLATE) {
        widget._beautyPanelViewCallBack?.onUpdateEffect(uiProperty.sdkParam!);
        if (_tePanelDataProducer is TEGeneralDataProducer) {
          (_tePanelDataProducer as TEGeneralDataProducer).restoreUIStateFromParams(uiProperty.paramList);
        }
      } else if (uiProperty.isNoneItem()) {
        List<TESDKParam>? closeEffectList = _tePanelDataProducer.getCloseEffectItems(uiProperty);
        if (closeEffectList != null) {
          widget._beautyPanelViewCallBack?.onUpdateEffectList(closeEffectList);
        }
      } else {
        // Handle green screen V2 sub-item
        TESDKParam? paramToSend = _getSDKParamFromUIProperty(uiProperty);
        if (paramToSend != null) {
          widget._beautyPanelViewCallBack?.onUpdateEffect(paramToSend);
        }
      }
      _currentSDKParam = uiProperty.sdkParam;
    }
    _setSliderState(_currentSDKParam);
    setState(() {});
  }

  /// Get SDK param from UI property, with special handling for Green Screen V2
  TESDKParam? _getSDKParamFromUIProperty(TEUIProperty uiProperty) {
    if (uiProperty.uiCategory == UICategory.GREEN_BACKGROUND_V2_ITEM) {
      TEUIProperty? parentProperty = uiProperty.parentUIProperty;
      if (parentProperty?.sdkParam?.extraInfo != null) {
        String? bgPath = parentProperty!.sdkParam!.extraInfo![TESDKParam.EXTRA_INFO_KEY_BG_PATH];
        String? keyColor = parentProperty.sdkParam!.extraInfo![TESDKParam.EXTRA_INFO_KEY_KEY_COLOR];
        if ((bgPath == null || bgPath.isEmpty) && (keyColor == null || keyColor.isEmpty)) {
          return null;
        }
        parentProperty.sdkParam!.extraInfo![TESDKParam.GREEN_PARAMS_V2] =
            TEProducerUtils.getGreenParamsV2(parentProperty);
        return parentProperty.sdkParam;
      }
    }
    return uiProperty.sdkParam;
  }

  void _setSliderState(TESDKParam? sdkParam) {
    // Don't show slider for GREEN_BACKGROUND_V2_ITEM_IMPORT_IMAGE
    if (_currentList != null && _currentList!.isNotEmpty) {
      for (TEUIProperty item in _currentList!) {
        if (item.uiState == UIState.CHECKED_AND_IN_USE &&
            item.uiCategory == UICategory.GREEN_BACKGROUND_V2_ITEM_IMPORT_IMAGE) {
          setState(() {
            _sliderViewModel = null;
          });
          return;
        }
      }
    }

    _sliderViewModel = SliderAdapter.fromSDKParam(
      sdkParam,
      _selectedList,
      onValueChange: (value) {
        var localValue = value.round().toDouble();
        if (_sliderViewModel != null && localValue != _sliderViewModel!.value) {
          bool isLutMode = _sliderViewModel!.isShowSliderTypeLayout && _isSelectedLut();
          SliderAdapter.updateSDKParam(sdkParam!, localValue, isLutMode);

          // For green screen V2 sub-items, send parent sdkParam
          TESDKParam? paramToSend = sdkParam;
          if (_currentSDKParam != null) {
            TEUIProperty? gsv2Item = _findCurrentCheckedGSV2Item();
            if (gsv2Item != null) {
              paramToSend = _getSDKParamFromUIProperty(gsv2Item);
            }
          }

          if (widget.onSliderUpdateValueType == 1 && paramToSend != null) {
            widget._beautyPanelViewCallBack?.onUpdateEffect(paramToSend);
          }
          setState(() {
            _sliderViewModel = _sliderViewModel!.copyWith(value: localValue);
          });
        }
      },
      onChangeEnd: (value) {
        if (widget.onSliderUpdateValueType == 2 && sdkParam != null) {
          TESDKParam? paramToSend = sdkParam;
          TEUIProperty? gsv2Item = _findCurrentCheckedGSV2Item();
          if (gsv2Item != null) {
            paramToSend = _getSDKParamFromUIProperty(gsv2Item);
          }
          if (paramToSend != null) {
            widget._beautyPanelViewCallBack?.onUpdateEffect(paramToSend);
          }
        }
      },
      onTypeClick: _onSliderTypeClick,
    );
    setState(() {});
  }

  /// Find the currently checked GREEN_BACKGROUND_V2_ITEM in _currentList
  TEUIProperty? _findCurrentCheckedGSV2Item() {
    if (_currentList == null) return null;
    for (TEUIProperty item in _currentList!) {
      if (item.uiCategory == UICategory.GREEN_BACKGROUND_V2_ITEM && item.uiState == UIState.CHECKED_AND_IN_USE) {
        return item;
      }
    }
    return null;
  }

  bool _isSelectedLut() {
    return _selectedList[1];
  }

  void checkPanelViewItem(TEUIProperty uiProperty) {
    // Special handling for green screen V2 parent node (SEGMENTATION with segType=green_background_v2)
    String? segType = uiProperty.sdkParam?.extraInfo?[TESDKParam.EXTRA_INFO_KEY_SEG_TYPE];
    if (segType == TESDKParam.EXTRA_INFO_SEG_TYPE_GREEN[1] && uiProperty.uiCategory == UICategory.SEGMENTATION) {
      // Update state via producer
      List<TEUIProperty>? uiPropertyList = _tePanelDataProducer.onItemClick(uiProperty);
      if (uiPropertyList != null && uiPropertyList.isNotEmpty) {
        _listViewOffset.add(_scrollController.offset);
        setState(() {
          _currentList = uiPropertyList;
          _isShowSubTitleLayout = true;
          _isShowSubTabBar = false;
          _subTitleName = TEPanelLocalizations.of(context).getDisplayName(uiProperty) ?? '';
          _updateLayoutMode();
        });
        _scrollController.jumpTo(0);
      }
      // Simulate clicking the "import image" item
      TEUIProperty? importItem = TEProducerUtils.getImportTEUIPropertyItem(uiProperty);
      if (importItem != null) {
        _executeItemClickLogic(importItem);
      }
      return;
    }
    _tePanelDataProducer.onItemClick(uiProperty);
    setState(() {});
    _setSliderState(uiProperty.sdkParam);
  }

  String _getTypeDataListViewOffsetKey(TEUIProperty property) {
    return "${property.displayName}${property.displayNameEn}";
  }
}
