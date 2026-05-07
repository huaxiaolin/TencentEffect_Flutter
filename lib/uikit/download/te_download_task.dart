import 'dart:io';

import '../../uikit/download/te_download_state.dart';
import '../model/te_ui_property.dart';


/// 下载进度回调
typedef TEDownloadProgressCallback = void Function(String url, int received, int total, double progress);

/// 下载状态变化回调
typedef TEDownloadStateCallback = void Function(String url, TEDownloadState state);

/// 下载任务
class TEDownloadTask {
  /// 下载URL
  final String url;

  /// 本地保存目录
  final String localDir;

  /// 文件名
  final String fileName;

  /// 关联的 TEMotionDLModel
  final TEMotionDLModel? dlModel;

  /// 当前下载状态
  TEDownloadState state;

  /// 下载进度 (0.0 - 1.0)
  double progress;

  /// 已下载字节数
  int receivedBytes;

  /// 总字节数
  int totalBytes;

  /// 错误信息
  String? errorMessage;

  /// 创建时间
  final DateTime createTime;

  /// 进度回调
  TEDownloadProgressCallback? onProgress;

  /// 状态回调
  TEDownloadStateCallback? onStateChanged;

  TEDownloadTask({
    required this.url,
    required this.localDir,
    required this.fileName,
    this.dlModel,
    this.state = TEDownloadState.idle,
    this.progress = 0.0,
    this.receivedBytes = 0,
    this.totalBytes = 0,
    this.onProgress,
    this.onStateChanged,
  }) : createTime = DateTime.now();

  /// 从 TEMotionDLModel 创建下载任务（异步方法）
  static TEDownloadTask fromDLModel(TEMotionDLModel dlModel) {
    return TEDownloadTask(
      url: dlModel.url ?? '',
      localDir: dlModel.localDir ?? '',
      fileName: dlModel.fileName ?? '',
      dlModel: dlModel,
    );
  }

  /// 获取完整的本地文件路径
  String get localFilePath {
    String dir = localDir;
    if (!dir.endsWith(Platform.pathSeparator)) {
      dir = '$dir${Platform.pathSeparator}';
    }
    return '$dir$fileName';
  }

  /// 获取解压后的文件路径（如果是zip文件）
  String get extractedFilePath {
    if (fileName.endsWith('.zip')) {
      final nameWithoutZip = fileName.substring(0, fileName.length - 4);
      String dir = localDir;
      if (!dir.endsWith(Platform.pathSeparator)) {
        dir = '$dir${Platform.pathSeparator}';
      }
      return '$dir$nameWithoutZip';
    }
    return localFilePath;
  }

  /// 是否为zip文件
  bool get isZipFile => fileName.endsWith('.zip');

  /// 更新进度
  void updateProgress(int received, int total) {
    receivedBytes = received;
    totalBytes = total;
    progress = total > 0 ? received / total : 0.0;
    onProgress?.call(url, received, total, progress);
  }

  /// 更新状态
  void updateState(TEDownloadState newState) {
    state = newState;
    onStateChanged?.call(url, newState);
  }

  @override
  String toString() {
    return 'TEDownloadTask{url: $url, state: $state, progress: ${(progress * 100).toStringAsFixed(1)}%}';
  }
}
