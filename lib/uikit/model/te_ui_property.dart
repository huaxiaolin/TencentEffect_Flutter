import 'dart:io';
import 'dart:convert';

import '../../uikit/model/te_json_decoder.dart';

import '../constant/te_constant.dart';

class TEUIProperty {
  int id = -1;
  String? displayName;
  String? displayNameEn;
  String? icon;
  String? resourceUri;
  String? downloadPath;

  String? titleType;

  List<TEUIProperty>? propertyList;
  TESDKParam? sdkParam;
  List<TESDKParam>? paramList;

  TEUIProperty? parentUIProperty;
  UICategory? uiCategory;
  TEMotionDLModel? dlModel;
  bool verticalLayout = false;
  bool hasSubTitle = false;

  int uiState = 0;

  int getUiState() {
    return uiState;
  }

  void setUiState(int uiState) {
    this.uiState = uiState;
  }

  TEUIProperty(
      this.displayName,
      this.displayNameEn,
      this.icon,
      this.resourceUri,
      this.downloadPath,
      this.propertyList,
      this.sdkParam,
      this.uiState);

  bool isNoneItem() {
    return (sdkParam == null && propertyList == null && paramList == null);
  }

  bool isGSV2ImportImageItem() {
    return (uiCategory == UICategory.GREEN_BACKGROUND_V2_ITEM_IMPORT_IMAGE);
  }

  bool isBeautyMakeupNoneItem() {
    if (sdkParam != null && (sdkParam!.resourcePath == null || sdkParam!.resourcePath!.isEmpty)) {
      switch (sdkParam!.effectName) {
        case TEffectName.BEAUTY_MOUTH_LIPSTICK:
        case TEffectName.BEAUTY_FACE_SOFTLIGHT:
        case TEffectName.BEAUTY_FACE_RED_CHEEK:
        case TEffectName.BEAUTY_FACE_MAKEUP_EYE_SHADOW:
        case TEffectName.BEAUTY_FACE_MAKEUP_EYE_LINER:
        case TEffectName.BEAUTY_FACE_MAKEUP_EYELASH:
        case TEffectName.BEAUTY_FACE_MAKEUP_EYE_SEQUINS:
        case TEffectName.BEAUTY_FACE_MAKEUP_EYEBROW:
        case TEffectName.BEAUTY_FACE_MAKEUP_EYEBALL:
          return true;
        default:
          return false;
      }
    }
    return false;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is int) return value != 0;
    return false;
  }

  static UICategory? _parseUICategory(dynamic value) {
    if (value == null) return null;
    String str = value.toString();
    switch (str) {
      case 'BEAUTY': return UICategory.BEAUTY;
      case 'BODY_BEAUTY': return UICategory.BODY_BEAUTY;
      case 'LUT': return UICategory.LUT;
      case 'MOTION': return UICategory.MOTION;
      case 'MAKEUP': return UICategory.MAKEUP;
      case 'SEGMENTATION': return UICategory.SEGMENTATION;
      case 'LIGHT_MAKEUP': return UICategory.LIGHT_MAKEUP;
      case 'BEAUTY_TEMPLATE': return UICategory.BEAUTY_TEMPLATE;
      case 'GREEN_BACKGROUND_V2_ITEM': return UICategory.GREEN_BACKGROUND_V2_ITEM;
      case 'GREEN_BACKGROUND_V2_ITEM_IMPORT_IMAGE': return UICategory.GREEN_BACKGROUND_V2_ITEM_IMPORT_IMAGE;
      default: return null;
    }
  }

  TEUIProperty.fromJson(Map<String, dynamic> json) {
    var rawId = json['id'];
    if (rawId is int) {
      id = rawId;
    } else if (rawId is String) {
      id = int.tryParse(rawId) ?? -1;
    } else {
      id = -1;
    }
    displayName = json['displayName'];
    displayNameEn = json['displayNameEn'];
    icon = json['icon'];
    resourceUri = json['resourceUri'];
    downloadPath = json['downloadPath'];
    verticalLayout = _parseBool(json['verticalLayout']);
    hasSubTitle = _parseBool(json['hasSubTitle']);
    // Parse uiCategory from JSON string (e.g., "GREEN_BACKGROUND_V2_ITEM")
    if (json['uiCategory'] != null) {
      uiCategory = _parseUICategory(json['uiCategory']);
    }
    propertyList = TEJsonDecoder.decodeTEUIPropertyList(json['propertyList']);
    Map<String, dynamic>? tempSdkParam = json['sdkParam'];
    sdkParam = tempSdkParam != null ? TESDKParam.fromJson(tempSdkParam) : null;
    if (json['paramList'] != null) {
      paramList = (json['paramList'] as List).map((e) => TESDKParam.fromJson(e as Map<String, dynamic>)).toList();
    }
    var tempState = json['uiState'];
    if (tempState != null) {
      uiState = tempState;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['displayName'] = displayName;
    data['displayNameEn'] = displayNameEn;
    data['icon'] = icon;
    data['resourceUri'] = resourceUri;
    data['downloadPath'] = downloadPath;
    data['verticalLayout'] = verticalLayout;
    data['hasSubTitle'] = hasSubTitle;
    data['propertyList'] = propertyList?.map((e) => e.toJson()).toList();
    data['sdkParam'] = sdkParam?.toJson();
    data['paramList'] = paramList?.map((e) => e.toJson()).toList();
    data['uiState'] = uiState;
    return data;
  }
}

class TESDKParam {
  static const String BEAUTY_TEMPLATE_EFFECT_NAME = "BEAUTY_TEMPLATE";

  static const String EXTRA_INFO_BG_TYPE_IMG = "0";
  static const String EXTRA_INFO_BG_TYPE_VIDEO = "1";

  static const List<String> EXTRA_INFO_SEG_TYPE_GREEN = ["green_background", "green_background_v2"];
  static const String EXTRA_INFO_SEG_TYPE_CUSTOM = "custom_background";
  static const String GREEN_PARAMS_V2 = "green_params_v2";

  static const String EXTRA_INFO_KEY_BG_TYPE = "bgType";
  static const String EXTRA_INFO_KEY_BG_PATH = "bgPath";
  static const String EXTRA_INFO_KEY_SEG_TYPE = "segType";
  static const String EXTRA_INFO_KEY_KEY_COLOR = "keyColor";
  static const String EXTRA_INFO_KEY_MERGE_WITH_CURRENT_MOTION = "mergeWithCurrentMotion";
  static const String EXTRA_INFO_KEY_LUT_STRENGTH = "makeupLutStrength";

  String? effectName;
  int effectValue = 0;
  String? resourcePath;
  Map<String, String>? extraInfo;

  /// Transient tag field for template data (not serialized to JSON)
  Object? tag;

  TESDKParam(
      {this.effectName,
      this.effectValue = 0,
      this.resourcePath,
      this.extraInfo});

  TESDKParam.fromJson(Map<String, dynamic> json) {
    effectName = json['effectName'];
    effectValue = json['effectValue'] ?? 0;
    resourcePath = json['resourcePath'];

    Map<String, dynamic>? tempExtraInfo = json['extraInfo'];
    if (tempExtraInfo != null) {
      extraInfo = tempExtraInfo.cast<String, String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['effectName'] = effectName;
    data['effectValue'] = effectValue;
    data['resourcePath'] = resourcePath;
    data['extraInfo'] = extraInfo;
    return data;
  }

  TESDKParam clone() {
    TESDKParam cloned = TESDKParam(
      effectName: effectName,
      effectValue: effectValue,
      resourcePath: resourcePath,
    );
    if (extraInfo != null) {
      cloned.extraInfo = Map<String, String>.from(extraInfo!);
    }
    return cloned;
  }
}

enum UICategory {
  BEAUTY,
  BODY_BEAUTY,
  LUT,
  MOTION,
  MAKEUP,
  SEGMENTATION,
  LIGHT_MAKEUP,
  BEAUTY_TEMPLATE,
  GREEN_BACKGROUND_V2_ITEM,
  GREEN_BACKGROUND_V2_ITEM_IMPORT_IMAGE,
}

class UIState {
  static const int CHECKED_AND_IN_USE = 2;
  static const int IN_USE = 1;
  static const int INIT = 0;
}

class TEMotionDLModel {
  String? localDir;
  String? fileName;
  String? url;

  String? getLocalDir() {
    return localDir;
  }

  void setLocalDir(String? _localDir) {
    if (_localDir == null) {
      return;
    }
    localDir = _localDir;
    if (localDir!.startsWith(Platform.pathSeparator, 0)) {
      localDir = localDir?.replaceFirst(Platform.pathSeparator, "");
    }
    if (localDir!.endsWith(Platform.pathSeparator)) {
      localDir = localDir?.substring(0, localDir!.length - 1);
    }
  }

  String? getFileName() {
    return fileName;
  }

  String? getFileNameNoZip() {
    if (fileName != null && fileName!.endsWith(".zip")) {
      return fileName!.substring(0, fileName!.length - ".zip".length);
    }
    return fileName;
  }

  void setFileName(String _fileName) {
    fileName = _fileName;
  }

  String? getUrl() {
    return url;
  }

  void setUrl(String _url) {
    url = _url;
  }

  TEMotionDLModel(String? _localDir, String? _fileName, String? _url) {
    setLocalDir(_localDir);
    fileName = _fileName;
    url = _url;
  }
}

class GreenBackgroundItemName {
  static const String BACKGROUND_V2_SIMILARITY = "green_background_v2.similarity";
  static const String BACKGROUND_V2_SMOOTH = "green_background_v2.smooth";
  static const String BACKGROUND_V2_CORROSION = "green_background_v2.corrosion";
  static const String BACKGROUND_V2_DE_SPILL = "green_background_v2.despill";
  static const String BACKGROUND_V2_DE_SHADOW = "green_background_v2.deshadow";
}

class EffectValueType {
  final int min;
  final int max;

  const EffectValueType(this.min, this.max);

  static const RANGE_0_0 = EffectValueType(0, 0);
  static const RANGE_0_POS100 = EffectValueType(0, 100);
  static const RANGE_NEG100_POS100 = EffectValueType(-100, 100);
  static const RANG_1_POS100 = EffectValueType(1, 100);
  static const RANG_0_POS3 = EffectValueType(0, 3);
  static const RANG_0_POS5 = EffectValueType(0, 5);

  int getMin() {
    return min;
  }

  int getMax() {
    return max;
  }

  static const Map<String, EffectValueType> VALUE_TYPE_MAP = {
    TEffectName.EFFECT_MOTION: EffectValueType.RANGE_0_0,
    TEffectName.EFFECT_SEGMENTATION: EffectValueType.RANGE_0_0,
    TEffectName.BEAUTY_CONTRAST: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_SATURATION: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_IMAGE_WARMTH: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_IMAGE_TINT: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_IMAGE_BRIGHTNESS: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_EYE_DISTANCE: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_EYE_ANGLE: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_EYE_WIDTH: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_EYE_HEIGHT: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_EYE_OUT_CORNER: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_EYE_POSITION: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_EYEBROW_ANGLE: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_EYEBROW_DISTANCE: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_EYEBROW_HEIGHT: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_EYEBROW_LENGTH: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_EYEBROW_THICKNESS: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_EYEBROW_RIDGE: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_NOSE_WING: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_NOSE_HEIGHT: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_NOSE_BRIDGE_WIDTH: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_NASION: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_MOUTH_SIZE: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_MOUTH_HEIGHT: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_MOUTH_WIDTH: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_MOUTH_POSITION: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_SMILE_FACE: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_FACE_THIN_CHIN: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_FACE_FOREHEAD: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BEAUTY_FACE_FOREHEAD2: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BODY_ENLARGE_CHEST_STRENGTH: EffectValueType.RANGE_NEG100_POS100,
    TEffectName.BODY_SLIM_ARM_STRENGTH: EffectValueType.RANGE_NEG100_POS100,
    // Green Background V2 sub-parameters
    GreenBackgroundItemName.BACKGROUND_V2_SIMILARITY: EffectValueType.RANGE_0_POS100,
    GreenBackgroundItemName.BACKGROUND_V2_SMOOTH: EffectValueType.RANG_1_POS100,
    GreenBackgroundItemName.BACKGROUND_V2_CORROSION: EffectValueType.RANG_0_POS3,
    GreenBackgroundItemName.BACKGROUND_V2_DE_SPILL: EffectValueType.RANGE_0_POS100,
    GreenBackgroundItemName.BACKGROUND_V2_DE_SHADOW: EffectValueType.RANG_0_POS5,
  };

  static EffectValueType getEffectValueType(TESDKParam teParam) {
    EffectValueType? type = VALUE_TYPE_MAP[teParam.effectName];
    if (type != null) {
      return type;
    } else {
      return EffectValueType.RANGE_0_POS100;
    }
  }
}
