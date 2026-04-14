import 'package:flutter/material.dart';
import 'base_button.dart';

class BaseDialog {
  BaseDialog._();

  static Future<T?> showConfirmDialog<T>(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            BaseButton(
              text: cancelText,
              type: BaseButtonType.text,
              isFullWidth: false,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            BaseButton(
              text: confirmText,
              type: isDestructive ? BaseButtonType.danger : BaseButtonType.primary,
              isFullWidth: false,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}
