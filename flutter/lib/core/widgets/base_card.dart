import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final Color? color;

  const BaseCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: cardContent,
      );
    }

    return Card(
      margin: margin,
      color: color,
      child: cardContent,
    );
  }
}
