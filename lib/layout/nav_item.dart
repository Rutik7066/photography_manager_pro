import 'package:flutter/material.dart';

class NavBarItem extends StatefulWidget {
  final IconData icon;
  final Function onTap;
  final bool active;
  final String name;
  NavBarItem({required this.icon, required this.onTap, required this.active, required this.name});
  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.onTap();
        },
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              Container(
                width: 85.0,
                child: Column(
                  children: [
                    // AnimatedContainer(
                    //   duration: Duration(milliseconds: 475),
                    //   height: 35.0,
                    //   width: 5.0,
                    //   decoration: BoxDecoration(
                    //     color: widget.active ? Colors.white : Colors.transparent,
                    //     borderRadius: BorderRadius.only(
                    //       topRight: Radius.circular(10.0),
                    //       bottomRight: Radius.circular(10.0),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        widget.icon,
                        color: widget.active ? Colors.white : Colors.white54,
                        size: 19.0,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(5),
                        child: Text('${widget.name}',
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                  color: widget.active ? Colors.white : Colors.white54,
                                )))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
