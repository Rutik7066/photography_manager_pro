import 'package:flutter/material.dart';
import 'package:jk_photography_manager/widgets/whatsapp/recovery_campaign.dart';
import 'package:jk_photography_manager/widgets/whatsapp/todays_celebrations.dart';
import 'package:jk_photography_manager/widgets/whatsapp/whatsapp_campaign.dart';

class Whatsapp extends StatelessWidget {
  const Whatsapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     mainAxisSize: MainAxisSize.max,
            //     children: [
            //       Text(
            //         'Whatsapp',
            //         style: style.textTheme.headline5,
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              width: 750,
              child: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      'Today Celebrations',
                      style: style.textTheme.bodyLarge,
                    ),
                  ),
                
                  Tab(
                    child: Text(
                      'Recovery Campaign',
                      style: style.textTheme.bodyLarge,
                    ),
                  ),
                   Tab(
                    child: Text(
                      'Whatsapp Bulk Sender',
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
                    child: TodaysCelebrations(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: RecoveryCampaign(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: WhatsappCampaign(),
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
