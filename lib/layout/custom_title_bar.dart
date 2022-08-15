// ignore_for_file: prefer_const_constructors

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:jk_photography_manager/layout/theme.dart';
import 'package:jk_photography_manager/page/customer.dart';
import 'package:provider/provider.dart';

import 'navigation.dart';

class CustomTitleBar extends StatefulWidget {
  const CustomTitleBar({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomTitleBar> createState() => _CustomTitleBarState();
}

class _CustomTitleBarState extends State<CustomTitleBar> {
  bool _value = true;
  @override
  Widget build(BuildContext context) {
    var navigation = Provider.of<Navigation>(context);

    Color color = Colors.indigo;

    return WindowTitleBarBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Photography Manager",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: MoveWindow()),
          MinimizeWindowButton(
            animate: true,
            colors: WindowButtonColors(
              mouseOver: Colors.transparent,
              mouseDown: Colors.transparent,
              iconNormal: color, 
              iconMouseDown: color,
              iconMouseOver: color,
            ),
          ),
          MaximizeWindowButton(
            animate: true,
            colors: WindowButtonColors( 
              mouseOver: Colors.transparent,
              mouseDown: Colors.transparent,
              iconNormal: color,
              iconMouseDown: color,
              iconMouseOver: color,
            ),
          ),
          CloseWindowButton(
            animate: true,
            colors: WindowButtonColors(
              mouseOver: Colors.transparent,
              mouseDown: Colors.transparent,
              iconNormal: color,
              iconMouseDown: color,
              iconMouseOver: color,
            ),
          )
        ],
      ),
    );
  }
}
