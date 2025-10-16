import 'package:flutter/material.dart';

class WidgetCustomFloatingActionButton extends StatelessWidget {
  final IconData buttonIcon;
  final VoidCallback buttonFunction;
  const WidgetCustomFloatingActionButton({
    super.key,
    required this.buttonFunction,
    required this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: buttonFunction,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(30),
      ),
      child: Icon(buttonIcon, color: Colors.white70, size: 36),
    );
  }
}
