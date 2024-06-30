import 'package:flutter/material.dart';




class CustomTextFormField extends StatefulWidget {
  String? labelText;
  String? hintText;
  final Color? cursorColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final double? borderradius;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  final double? cursorWidth; // Add cursor width
  final double? cursorHeight;

  final double? height;

  CustomTextFormField({super.key,
    this.cursorColor,
    this.cursorHeight,
    this.cursorWidth,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.borderradius,
    this.obscureText = false,
    this.enabled = true,
    required this.controller,
    this.onChanged,
    this.validator,
    this.height,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      obscuringCharacter: '*',
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      cursorColor: widget.cursorColor,
      cursorHeight: widget.cursorHeight,
      validator: widget.validator,
      decoration: InputDecoration(contentPadding: const EdgeInsets.all(11),
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderradius ?? 10.0),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),


        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red,),
          borderRadius: BorderRadius.circular(widget.borderradius ?? 10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 0.9, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(widget.borderradius ?? 10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(widget.borderradius ?? 10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(widget.borderradius ?? 10),
        ),
      ),
      style: TextStyle(fontSize: 14),
    );
  }
}