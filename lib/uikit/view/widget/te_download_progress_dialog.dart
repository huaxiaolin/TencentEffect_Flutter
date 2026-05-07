import 'package:flutter/material.dart';
import '../../download/te_download_manager.dart';
import '../../download/te_download_state.dart';
import '../../model/te_ui_property.dart';

/// 下载进度对话框
/// 
/// 显示一个圆形进度条，用于展示素材下载进度
class TEDownloadProgressDialog {
  
  /// 显示下载进度对话框
  /// 
  /// [context] BuildContext
  /// [uiProperty] 需要下载的素材属性
  /// 
  /// 返回 true 表示下载成功，false 表示下载失败或取消
  static Future<bool> show(BuildContext context, TEUIProperty uiProperty) async {
    double progress = 0.0;
    TEDownloadState downloadState = TEDownloadState.idle;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // 开始下载（只在首次构建时触发）
            if (downloadState == TEDownloadState.idle) {
              downloadState = TEDownloadState.downloading;
              TEDownloadManager.instance.downloadMaterial(
                uiProperty,
                onProgress: (url, received, total, p) {
                  setDialogState(() {
                    progress = p;
                  });
                },
                onStateChanged: (url, state) {
                  setDialogState(() {
                    downloadState = state;
                  });
                  // 下载完成或失败时关闭对话框
                  if (state == TEDownloadState.completed) {
                    // 下载成功后将 dlModel 设置为 null，下次点击时不再触发下载
                    uiProperty.dlModel = null;
                    Navigator.of(dialogContext).pop(true);
                  } else if (state == TEDownloadState.failed) {
                    Navigator.of(dialogContext).pop(false);
                  }
                },
              );
            }

            return AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                width: 65,
                height: 65,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 背景圆环
                    CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 5,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha:0.3),
                      ),
                    ),
                    // 进度圆环
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 5,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        downloadState == TEDownloadState.failed 
                            ? Colors.redAccent 
                            : Colors.lightBlueAccent,
                      ),
                    ),
                    // 中间的百分比文字
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    return result ?? false;
  }
}
