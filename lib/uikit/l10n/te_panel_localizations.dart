import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'te_panel_localizations_en.dart';
import 'te_panel_localizations_zh.dart';
import '../model/te_ui_property.dart';


abstract class TEPanelLocalizations {
  TEPanelLocalizations(String locale) : localeName = locale;

  final String localeName;

  static TEPanelLocalizations of(BuildContext context) {
    final instance = Localizations.of<TEPanelLocalizations>(context, TEPanelLocalizations);
    if (instance != null) {
      return instance;
    }
    // Fallback: try to detect locale from context if delegate is not registered
    final locale = Localizations.localeOf(context);
    return lookupTEPanelLocalizations(locale);
  }

  static const LocalizationsDelegate<TEPanelLocalizations> delegate = _TEPanelLocalizationsDelegate();

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  String get makeup;
  String get lut;
  String get revert;
  String? getDisplayName(TEUIProperty uiProperty);
}

class _TEPanelLocalizationsDelegate extends LocalizationsDelegate<TEPanelLocalizations> {
  const _TEPanelLocalizationsDelegate();

  @override
  Future<TEPanelLocalizations> load(Locale locale) {
    return SynchronousFuture<TEPanelLocalizations>(lookupTEPanelLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_TEPanelLocalizationsDelegate old) => false;
}

TEPanelLocalizations lookupTEPanelLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return TEPanelLocalizationsEn();
    case 'zh': return TEPanelLocalizationsZh();
  }

  return TEPanelLocalizationsEn();
}
