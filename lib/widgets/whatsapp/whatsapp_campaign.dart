// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:jk_photography_manager/common_widgets/my_icon_button.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/whatsapp_services/whatsapp_function.dart';
import 'package:jk_photography_manager/whatsapp_services/whatsapp_provider.dart';
import 'package:provider/provider.dart';

class WhatsappCampaign extends StatefulWidget {
  const WhatsappCampaign({Key? key}) : super(key: key);

  @override
  State<WhatsappCampaign> createState() => _WhatsappCampaignState();
}

class _WhatsappCampaignState extends State<WhatsappCampaign> {
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    var whatsappPro = Provider.of<WhatsappProvider>(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 450,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: style.primaryColorLight),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Text('Attachment',
                                    style: style.textTheme.bodyMedium),
                              ),
                              MyIconButton(
                                iconData: MaterialIcons.attach_file,
                                onPressed: () async {
                                  await whatsappPro.pickfile();
                                },
                                iconSize: 18,
                              )
                            ],
                          ),
                        ),
                        Container(
                          color: style.primaryColorLight,
                          height: 1,
                        ),
                        if (whatsappPro.attachmentList != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: SizedBox(
                              height: 265,
                              child: ListView.separated(
                                separatorBuilder: (BuildContext context,
                                        int index) =>
                                    Container(height: 1.5, color: Colors.white),
                                shrinkWrap: true,
                                itemCount: whatsappPro.attachmentList.length,
                                itemBuilder: (context, index) {
                                  var fileimg =
                                      whatsappPro.attachmentList[index];
                                  File img = File(fileimg['path']);
                                  return ListTile(
                                    tileColor: Colors.grey.shade200,
                                    leading:
                                        Image.file(img, width: 50, height: 50),
                                    title: Text(fileimg['name']),
                                    trailing: IconButton(
                                        splashRadius: 20,
                                        iconSize: 20,
                                        onPressed: () =>
                                            whatsappPro.removefile(index),
                                        icon: const Icon(
                                          Icons.close,
                                        )),
                                  );
                                },
                              ),
                            ),
                          )
                        else
                          const SizedBox.expand()
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyTextField(
                  onChanged: (re) {
                    print(re);
                  },
                  controller: _messageController,
                  hintText: 'Type Message here.......',
                  maxLines: 16,
                  minLines: 16,
                ),
              ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: SizedBox(
                  height: 33,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      whatsappPro.login();
                    },
                    icon: const Icon(
                      FontAwesome.whatsapp,
                      size: 13,
                    ),
                    label: Text(
                      'Start & Log In Whatsapp',
                      style: style.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  height: 33,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      whatsappPro
                          .rutCampign(_messageController.value.text.toString())
                          .then(
                        (value) async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Campaign Report'),
                                content: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 500,
                                  child: DataTable2(
                                    columns: const [
                                      DataColumn2(label: Text('No.')),
                                      DataColumn2(label: Text('Name')),
                                      DataColumn2(label: Text('Number')),
                                      DataColumn2(label: Text('Status')),
                                    ],
                                    rows: List.generate(
                                      whatsappPro.msglog.length,
                                      (index) {
                                        Map log = whatsappPro.msglog[index];
                                        return DataRow.byIndex(
                                          index: index,
                                          cells: [
                                            DataCell(Text(index.toString())),
                                            DataCell(Text(log['name'])),
                                            DataCell(Text(log['number'])),
                                            DataCell(Text(log['status'])),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        String? path = await FilePicker.platform
                                            .getDirectoryPath();
                                        if (path != null) {
                                          whatsappPro.exportlog(path);
                                        }
                                      },
                                      child: const Text('Export CSV')),
                                  ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'))
                                ],
                              );
                            },
                          );
                          return null;
                        },
                      );
                    },
                    icon: const Icon(
                      FontAwesome.send,
                      size: 13,
                    ),
                    label: Text(
                      'Run Campaign',
                      style: style.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
