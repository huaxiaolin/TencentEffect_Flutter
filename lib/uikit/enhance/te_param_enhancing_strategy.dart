import '../model/te_ui_property.dart';

/// Interface for beauty enhancement mode.
/// Implementations can customize how effect parameter values are enhanced.
abstract class TEParamEnhancingStrategy {
  /// Returns the enhanced effectValue for the given param.
  int enhanceValue(TESDKParam param);
}
