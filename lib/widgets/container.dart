import 'package:flutter/material.dart';


class CustomContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final double? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final Widget? child;
  final Function? onTap;
  final BoxBorder? boxborder;


  const CustomContainer({
    super.key,
    this.height,
    this.width,
    this.color,
    this.decoration,
    this.borderRadius,
    this.onTap,
    this.margin,
    this.padding,
    this.child,
    this.boxborder

  });


  @override
  Widget build(BuildContext context) {
    return InkWell(


      onTap: () async {
        onTap!();
      },
      child: Container(
        padding: padding,
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius ?? 30),
            border: boxborder
        ),


        child: child,
      ),
    );
  }
}
