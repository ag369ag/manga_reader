import 'package:flutter/material.dart';

class WidgetCustomTextField extends StatelessWidget {
  final TextEditingController textController;
  const WidgetCustomTextField({super.key, required this.textController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.all(0)
      ),
    );
  }
}
