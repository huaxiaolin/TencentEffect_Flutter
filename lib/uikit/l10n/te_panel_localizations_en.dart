import 'te_panel_localizations.dart';
import '../model/te_ui_property.dart';

/// The translations for English (`en`).
class TEPanelLocalizationsEn extends TEPanelLocalizations {
  TEPanelLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get makeup => 'Makeup';

  @override
  String get lut => 'Lut';

  @override
  String get revert => 'Revert';

  @override
  String? getDisplayName(TEUIProperty uiProperty) {
    return uiProperty.displayNameEn;
  }
}
