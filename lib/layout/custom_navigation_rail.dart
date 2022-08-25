// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/layout/nav_item.dart';
import 'package:jk_photography_manager/layout/navigation.dart';
import 'package:jk_photography_manager/page/bill.dart';
import 'package:jk_photography_manager/page/customer.dart';
import 'package:jk_photography_manager/page/event.dart';
import 'package:jk_photography_manager/page/finance.dart';
import 'package:jk_photography_manager/page/setting.dart';
import 'package:jk_photography_manager/page/studio.dart';
import 'package:jk_photography_manager/page/whatsapp.dart';
import 'package:jk_photography_manager/whatsapp_services/whatsapp_function.dart';
import 'package:provider/provider.dart';

import '../auth/auth.dart';
import '../auth/m_user.dart';

class CustomNavigationRail extends StatefulWidget {
  const CustomNavigationRail({Key? key}) : super(key: key);

  @override
  State<CustomNavigationRail> createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  TextEditingController _numController = TextEditingController();
  TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var navigation = Provider.of<Navigation>(context);
    var auth = Provider.of<Auth>(context);
    MUser user = auth.giveMetheUser();
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.black87,
      ),
      child: Column(
        children: [
          NavBarItem(
            icon: Ionicons.camera_outline,
            onTap: () {
              navigation.select(0);
            },
            active: navigation.selectedIndex == 0,
            name: 'Home',
          ),
          NavBarItem(
            name: 'Event',
            icon: Icons.edit_calendar_outlined,
            onTap: () {
              navigation.select(1);
            },
            active: navigation.selectedIndex == 1,
          ),
          NavBarItem(
            name: 'Bill',
            icon: Ionicons.md_receipt_outline,
            onTap: () {
              navigation.select(2);
            },
            active: navigation.selectedIndex == 2,
          ),
          NavBarItem(
            name: 'Expense',
            icon: Icons.currency_rupee,
            onTap: () {
              navigation.select(3);
            },
            active: navigation.selectedIndex == 3,
          ),
          NavBarItem(
            name: 'Customer',
            icon: Ionicons.person_outline,
            onTap: () {
              navigation.select(4);
            },
            active: navigation.selectedIndex == 4,
          ),
          NavBarItem(
            name: 'Whatsapp',
            icon: Icons.whatsapp,
            onTap: () {
              navigation.select(5);
            },
            active: navigation.selectedIndex == 5,
          ),
          NavBarItem(
            name: 'Quotation',
            icon: AntDesign.book,
            onTap: () {
              navigation.select(6);
            },
            active: navigation.selectedIndex == 6,
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: IconButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Send To Whatsapp'),
                          content: SizedBox(
                            height: 200,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: SizedBox(
                                    width: 300,
                                    child: MyTextField(
                                      hintText: 'Message...',
                                      maxLines: 3,
                                      minLines: 3,
                                      controller: _msgController,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: SizedBox(
                                  width: 300,
                                  child: MyTextField(
                                    hintText: 'Numbers...',
                                    maxLines: 5,
                                    minLines: 5,
                                    controller: _numController,
                                  ),
                                ),
                              )
                            ]),
                          ),
                          actions: [
                            SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    String message = _msgController.text.isEmpty == true ? "Thank You so much for visiting ${user.userBussinessName}.\nWe are happy to have you." : _msgController.text;
                                    WhatsappFunction().sendMessage(number: _numController.text, message: message);

                                    
                                  },
                                  child: Text('Send')),
                            ),
                            SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel')),
                            )
                          ],
                        );
                      });
                },
                icon: Icon(
                  FontAwesome.send_o,
                  color: Colors.white,
                )),
          ),
          NavBarItem(
            name: 'Setting',
            icon: SimpleLineIcons.settings,
            onTap: () {
              navigation.select(7);
            },
            active: navigation.selectedIndex == 7,
          ),
        ],
      ),
    );
  }
}
