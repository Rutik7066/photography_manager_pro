// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_title_bar.dart';
import 'navigation.dart';

class MainContent extends StatelessWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigation = Provider.of<Navigation>(context);
    return SizedBox(
     // color: Colors.orange[50],
     height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          CustomTitleBar(),
          Expanded(
            child: navigation.selectedWidget,
          )
        ],
      ),
    );
  }
}
