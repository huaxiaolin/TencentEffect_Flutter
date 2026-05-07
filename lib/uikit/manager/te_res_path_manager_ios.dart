import 'dart:io';

import 'package:path_provider/path_provider.dart';
import '../../uikit/manager/te_res_path_manager.dart';


class TEResPathManagerIos implements TEResPathManager {
  String? _resPath;

  @override
  Future<String> getLutDir() async {
    return "${await getResPath()}${Platform.pathSeparator}lut.bundle${Platform.pathSeparator}";
  }

  @override
  Future<String> getMakeUpDir() async {
    return "${await getResPath()}${Platform.pathSeparator}makeupMotionRes.bundle${Platform.pathSeparator}";
  }

  @override
  Future<String> getMotion2dDir() async {
    return "${await getResPath()}${Platform.pathSeparator}2dMotionRes.bundle${Platform.pathSeparator}";
  }

  @override
  Future<String> getMotion3dDir() async {
    return "${await getResPath()}${Platform.pathSeparator}3dMotionRes.bundle${Platform.pathSeparator}";
  }

  @override
  Future<String> getMotionGanDir() async {
    return "${await getResPath()}${Platform.pathSeparator}ganMotionRes.bundle${Platform.pathSeparator}";
  }

  @override
  Future<String> getMotionGestureDir() async {
    return "${await getResPath()}${Platform.pathSeparator}handMotionRes.bundle${Platform.pathSeparator}";
  }

  @override
  Future<String> getLightMakeupDir() async {
    return "${await getResPath()}${Platform.pathSeparator}lightMakeupRes.bundle${Platform.pathSeparator}";
  }

  @override
  Future<String> getResPath() async {
    if (_resPath == null) {
      Directory directory = await getApplicationSupportDirectory();
      _resPath = directory.path + Platform.pathSeparator + TEResPathManager.TE_RES_DIR_NAME;
    }
    return _resPath!;
  }

  @override
  Future<String> getSegDir() async {
    return "${await getResPath()}${Platform.pathSeparator}segmentMotionRes.bundle${Platform.pathSeparator}";
  }
}
