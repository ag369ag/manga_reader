import 'package:flutter/material.dart';

class WidgetCustomTextField extends StatelessWidget {
  final TextEditingController textController;
  final Function(String)? textChangedEvent;
  const WidgetCustomTextField({super.key, required this.textController, required this.textChangedEvent});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      onChanged: textChangedEvent,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.all(0)
      ),
    );
  }
}
