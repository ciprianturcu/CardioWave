import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color borderColor;
  final VoidCallback? onPressed;

  const CustomButton({
    required this.label,
    required this.borderColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF414040),
            ),
          ),
        ),
      ),
    );
  }
}
