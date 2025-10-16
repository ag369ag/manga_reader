import 'package:flutter/material.dart';

class WidgetCustomButton extends StatelessWidget {
  final bool isCloseButton;
  final String? buttonText;
  final VoidCallback buttonFunction;
  const WidgetCustomButton({
    super.key,
    required this.isCloseButton,
    required this.buttonText,
    required this.buttonFunction,
  });

  @override
  Widget build(BuildContext context) {
    return isCloseButton
        ? TextButton(
            onPressed: buttonFunction,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.black45),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
              ),
            ),
            child: Text("Close"),
          )
        : ElevatedButton(
            onPressed: buttonFunction,
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
              ),
            ),
            child: Text(buttonText!, style: TextStyle(color: Colors.white)),
          );
  }
}
