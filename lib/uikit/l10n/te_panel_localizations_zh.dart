import 'te_panel_localizations.dart';
import '../model/te_ui_property.dart';

/// The translations for Chinese (`zh`).
class TEPanelLocalizationsZh extends TEPanelLocalizations {
  TEPanelLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get makeup => '美妆';

  @override
  String get lut => '滤镜';

  @override
  String get revert => '重置';

  @override
  String? getDisplayName(TEUIProperty uiProperty) {
    return uiProperty.displayName;
  }
}
