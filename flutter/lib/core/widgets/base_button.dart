import 'package:flutter/material.dart';

enum BaseButtonType { primary, secondary, outline, text, danger }

class BaseButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final BaseButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;

  const BaseButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = BaseButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white),
            ),
          ),
        if (icon != null && !isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(icon, size: 20),
          ),
        Text(text),
      ],
    );

    Widget button;

    switch (type) {
      case BaseButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: buttonContent,
        );
        break;
      case BaseButtonType.secondary:
        button = ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200, foregroundColor: Colors.black87),
          onPressed: isLoading ? null : onPressed,
          child: buttonContent,
        );
        break;
      case BaseButtonType.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: buttonContent,
        );
        break;
      case BaseButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          child: buttonContent,
        );
        break;
      case BaseButtonType.danger:
        button = ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: isLoading ? null : onPressed,
          child: buttonContent,
        );
        break;
    }

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }
    return button;
  }
}
