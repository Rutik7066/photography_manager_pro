import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  MyIconButton({
    Key? key,
    this.iconSize,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);
  double? iconSize;
  final IconData iconData;
  Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius:  iconSize ?? 20,
      iconSize: iconSize ?? 20,
      onPressed: onPressed,
      icon: Icon(iconData,color: Colors.indigoAccent,),
    );
  }
}
