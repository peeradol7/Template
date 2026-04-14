import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BaseLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const BaseLoadingIndicator({
    Key? key,
    this.size = 40.0,
    this.color,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget loadingWidget = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? AppColors.primary,
        strokeWidth: 3.0,
      ),
    );

    if (message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loadingWidget,
          const SizedBox(height: 16),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
        ],
      );
    }

    return Center(child: loadingWidget);
  }
}
