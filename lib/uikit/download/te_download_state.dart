/// 下载状态枚举
enum TEDownloadState {
  /// 未开始/空闲
  idle,

  /// 等待中（队列中）
  waiting,

  /// 下载中
  downloading,

  /// 解压中
  extracting,

  /// 下载完成
  completed,

  /// 下载失败
  failed,

  /// 已取消
  cancelled,
}

/// 下载结果
class TEDownloadResult {
  final bool success;
  final String? localPath;
  final String? errorMessage;
  final TEDownloadState state;

  TEDownloadResult({required this.success, this.localPath, this.errorMessage, this.state = TEDownloadState.completed});

  factory TEDownloadResult.success(String localPath) {
    return TEDownloadResult(success: true, localPath: localPath, state: TEDownloadState.completed);
  }

  factory TEDownloadResult.failure(String errorMessage) {
    return TEDownloadResult(success: false, errorMessage: errorMessage, state: TEDownloadState.failed);
  }

  factory TEDownloadResult.cancelled() {
    return TEDownloadResult(success: false, errorMessage: 'Download cancelled', state: TEDownloadState.cancelled);
  }
}
