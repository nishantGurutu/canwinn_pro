import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String? text;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final GestureTapCallback? onTap;

  const CommonButton(
      {this.text,
      this.color,
      this.width,
      this.height,
      this.borderRadius,
      this.textColor,
      this.fontSize,
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 40,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadius ?? 100)),
            color: color ?? Colors.white),
        child: Center(
          child: Text(
            text!,
            style: TextStyle(
                color: textColor ?? Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: fontSize ?? 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
