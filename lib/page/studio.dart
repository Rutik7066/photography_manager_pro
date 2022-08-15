import 'package:flutter/material.dart';
import '../widgets/studio/history.dart';
import '../widgets/studio/today.dart';


class Studio extends StatefulWidget {
  const Studio({Key? key}) : super(key: key);

  @override
  State<Studio> createState() => _StudioState();
}

class _StudioState extends State<Studio> {
  

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  children: [
                    Text(
                      'Home',
                      style: style.textTheme.headline5,
                    )
                  ],
                ),
            ),
            SizedBox(
              width: 500,
              child: TabBar(
                tabs: [
                  Tab(child: Text('Today',     style: style.textTheme.bodyLarge,),),
                  Tab(child: Text('History',     style: style.textTheme.bodyLarge,)),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Today(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: History(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
