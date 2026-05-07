import 'package:flutter/material.dart';

class CommonDialog {
  /// 显示通用对话框
  /// [context] 上下文
  /// [title] 标题
  /// [content] 内容
  /// [leftText] 左侧按钮文案
  /// [rightText] 右侧按钮文案
  /// [onLeftPress] 左侧按钮点击事件，如果不传默认关闭弹窗
  /// [onRightPress] 右侧按钮点击事件，如果不传默认关闭弹窗
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    required String leftText,
    required String rightText,
    VoidCallback? onLeftPress,
    VoidCallback? onRightPress,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // 点击背景不关闭
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(leftText),
              onPressed: () {
                if (onLeftPress != null) {
                  onLeftPress();
                } else {
                  Navigator.of(context).pop(false);
                }
              },
            ),
            TextButton(
              child: Text(rightText),
              onPressed: () {
                if (onRightPress != null) {
                  onRightPress();
                } else {
                  Navigator.of(context).pop(true);
                }
              },
            ),
          ],
        );
      },
    );
  }







}
