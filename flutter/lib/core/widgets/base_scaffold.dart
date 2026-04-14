import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final bool isLoading;

  const BaseScaffold({
    Key? key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar,
          body: body,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}
