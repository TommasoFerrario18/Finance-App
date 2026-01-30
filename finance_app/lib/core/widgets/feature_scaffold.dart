import 'package:flutter/material.dart';

class FeatureScaffold extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;

  const FeatureScaffold({
    super.key,
    this.title,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(title: Text(title!), actions: actions)
          : null,
      body: SafeArea(child: child),
    );
  }
}
