import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../theme/app_colors.dart';

class BaseToast {
  BaseToast._();

  static void showSuccess({required String message, String? title}) {
    _showToast(
      title: title ?? 'Success',
      message: message,
      type: ToastificationType.success,
      icon: const Icon(Icons.check_circle_outline, color: AppColors.success),
      primaryColor: AppColors.success,
    );
  }

  static void showError({required String message, String? title}) {
    _showToast(
      title: title ?? 'Error',
      message: message,
      type: ToastificationType.error,
      icon: const Icon(Icons.error_outline, color: AppColors.error),
      primaryColor: AppColors.error,
    );
  }

  static void showWarning({required String message, String? title}) {
    _showToast(
      title: title ?? 'Warning',
      message: message,
      type: ToastificationType.warning,
      icon: const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
      primaryColor: AppColors.warning,
    );
  }

  static void showInfo({required String message, String? title}) {
    _showToast(
      title: title ?? 'Info',
      message: message,
      type: ToastificationType.info,
      icon: const Icon(Icons.info_outline, color: AppColors.info),
      primaryColor: AppColors.info,
    );
  }

  static void _showToast({
    required String title,
    required String message,
    required ToastificationType type,
    required Icon icon,
    required Color primaryColor,
  }) {
    toastification.show(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      description: Text(message),
      type: type,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 3),
      icon: icon,
      primaryColor: primaryColor,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
    );
  }
}
