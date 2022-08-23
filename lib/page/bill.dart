import 'package:flutter/material.dart';
import 'package:jk_photography_manager/widgets/bill/all_bills.dart';
import 'package:jk_photography_manager/widgets/bill/new_bill.dart';

class Bill extends StatelessWidget {
  const Bill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Row(
              //   children: [
              //     Text(
              //       'Bill',
              //       style: style.textTheme.headline5,
              //     )
              //   ],
              // ),
              SizedBox(
                width: 500,
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        'New Bill',
                        style: style.textTheme.bodyLarge,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'All Bill',
                        style: style.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: NewBill(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: AllBills(),
                    )
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
