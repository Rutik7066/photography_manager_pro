// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:jk_photography_manager/widgets/events/all_events.dart';
import 'package:jk_photography_manager/widgets/events/new_event.dart';

class Event extends StatelessWidget {
  const Event({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Row(
              //   children: [
              //     Text(
              //       'Event',
              //       style: style.textTheme.headline5,
              //     )
              //   ],
              // ),
              SizedBox(
               width: 500,
                child: TabBar(
                  tabs: [
                    Tab(child: Text('New Event', style: style.textTheme.bodyLarge)),
                    Tab(child: Text('All Event', style: style.textTheme.bodyLarge)),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    NewEvent(),
                    AllEvents(),
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
