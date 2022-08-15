import 'dart:ui';

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  String hintText;
  Widget? prefix;
  int? minLines;
  int? maxLines;
  TextEditingController? controller;
  Function(String)? onChanged;
  Function()? onTap;
  Function()? onEditingComplete;
  TextStyle? textstyle;
  bool? obscureText;
  bool? readOnly;
  bool? enabled;
  double? height;
  double? width;
  MyTextField(
      {this.width,
      this.obscureText,
      this.height,
      this.enabled,
      this.textstyle,
      this.readOnly,
      this.onEditingComplete,
      this.maxLines,
      this.onTap,
      this.minLines,
      this.onChanged,
      this.controller,
      Key? key,
      required this.hintText,
      this.prefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    return SizedBox(
      width: width,
      child: TextField(
        obscureText: obscureText ?? false,
        style: textstyle ?? style.textTheme.bodyMedium,
        readOnly: readOnly ?? false,
        onEditingComplete: onEditingComplete,
        onTap: onTap,
        toolbarOptions: const ToolbarOptions(paste: true, copy: true, cut: true, selectAll: true),
        maxLines: maxLines ?? 1,
        minLines: minLines ?? 1,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            enabled: enabled ?? true,
            hintText: hintText,
            isDense: true,
            filled: true,
            hintStyle: textstyle ?? style.textTheme.bodyMedium,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(3), borderSide: BorderSide(width: 0.1, color: Color(0x1f000000))),
            prefixIcon: prefix,
            alignLabelWithHint: false),
      ),
    );
  }
}
