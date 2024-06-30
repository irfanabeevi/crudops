import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  String? text;
  double? fontsize;
  FontWeight? fontWeight;
  Color? textclr;
  TextAlign? textAlign;
  String? fontfamily;
  TextDecoration? decoration;
  CustomText(
      {super.key,
      this.textAlign,
      this.decoration,
      this.fontWeight,
      this.fontfamily,
      this.fontsize,
      this.text,
      this.textclr});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? 'some text',
      textAlign: textAlign,
      style: TextStyle(
          fontSize: fontsize,
          fontWeight: fontWeight,
          color: textclr,
          fontFamily: 'Poppins',
          decoration: decoration),
    );
  }
}
