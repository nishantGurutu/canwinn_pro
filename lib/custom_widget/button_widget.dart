import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget text;
  final VoidCallback onPressed;
  final Color color;
  final TextStyle textStyle;
  final double borderRadius;
  final EdgeInsets padding;
  final double elevation;
  final double width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 16.0),
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
    this.elevation = 2.0,
    required this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding,
          backgroundColor: color,
          elevation: elevation,
        ),
        onPressed: onPressed,
        child: text,
      ),
    );
  }
}
