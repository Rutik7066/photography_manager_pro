// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:jk_photography_manager/layout/main_content.dart';
import 'package:jk_photography_manager/layout/custom_navigation_rail.dart';


class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CustomNavigationRail(),
          VerticalDivider(width: 1, thickness: 1),
          Expanded(child: MainContent())
        ],
      ),
    );
  }
}
