import 'package:flutter/material.dart';

class CustomResponsiveScreen extends StatelessWidget {
  final Widget mychild;
  const CustomResponsiveScreen({
    Key? key,
    required this.mychild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: mychild,
      ),
    );
  }
}
