import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/auth/auth.dart';
import 'package:jk_photography_manager/auth/m_user.dart';

import 'dart:io';

import 'package:jk_photography_manager/model/m_quotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:widget_to_image/widget_to_image.dart';
import '../../repo/whatsapptemplate.dart';
import '../../whatsapp_api.dart';

class QuotationToImage extends StatefulWidget {
  MQuotation qou;

  QuotationToImage({
    required this.qou,
    Key? key,
  }) : super(key: key);

  @override
  State<QuotationToImage> createState() => _QuotationToImageState();
}

class _QuotationToImageState extends State<QuotationToImage> {
  String ref = '';

  GlobalKey imageKey = GlobalKey();
  bool breakdown = true;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    MUser user = auth.giveMetheUser();
    var style = Theme.of(context);
    return AlertDialog(
      content: RepaintBoundary(
        key: imageKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 1050, minWidth: 550, maxWidth: 550),
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black), borderRadius: BorderRadius.zero),
            child: Column(
              children: [
                Text(
                  'Quotation/ Order Form',
                  style: style.textTheme.labelLarge,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 90,
                        child: AspectRatio(
                          aspectRatio: 2 / 2,
                          child: user.logo != null ? Image.memory(user.logo!) : Container(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.userBussinessName,
                              style: style.textTheme.headline6,
                            ),
                            AutoSizeText(
                              'Mo. ${user.userNumber}',
                              style: style.textTheme.bodyLarge,
                            ),
                            AutoSizeText(
                              user.userBussinessAddress,
                              maxLines: 3,
                              style: style.textTheme.bodyLarge,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 1,
                  color: Colors.black,
                  width: 550,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          child: Text(
                            '${widget.qou.name}',
                            style: style.textTheme.labelMedium,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  color: Colors.black,
                  width: 550,
                ),
                Flexible(
                  child: SizedBox(
                    width: 550,
                    child: DataTable2(
                      lmRatio: 1.5,
                      horizontalMargin: 10,
                      columnSpacing: 10,
                      headingRowHeight: 30,
                      showBottomBorder: true,
                      headingRowColor: MaterialStateProperty.all(const Color.fromARGB(71, 255, 172, 64)),
                      columns: [
                        DataColumn2(label: Text('No.', style: style.textTheme.labelMedium), fixedWidth: 45),
                        DataColumn2(label: Text('Product', style: style.textTheme.labelMedium), size: ColumnSize.L),
                        DataColumn2(label: Text('Price', style: style.textTheme.labelMedium), size: ColumnSize.S),
                        DataColumn2(label: Text('Qty', style: style.textTheme.labelMedium), fixedWidth: 80),
                        if (breakdown == true)
                          DataColumn2(
                            label: Text(
                              'Total',
                              style: style.textTheme.labelMedium,
                            ),
                            size: ColumnSize.S,
                          )
                      ],
                      rows: List.generate(
                        widget.qou.cart.length,
                        (index) {
                          Map<dynamic, dynamic> product = widget.qou.cart[index];
                          List<String>? des = product['Description'];
                          print(des == null);
                          return DataRow2.byIndex(
                            color: MaterialStateProperty.all(style.canvasColor),
                            specificRowHeight: des == null ? 40 : (des.length * style.textTheme.bodyLarge!.fontSize!) + style.textTheme.bodyMedium!.fontSize! + 36,
                            index: index,
                            cells: [
                              DataCell(Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    Text('${index + 1}', style: style.textTheme.labelMedium),
                                  ],
                                ),
                              )),
                              DataCell(Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product['product'], style: style.textTheme.labelMedium),
                                    if (des != null)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: List.generate(
                                              des.length,
                                              (index) => Text(
                                                    des[index],
                                                    style: style.textTheme.bodySmall,
                                                  ),
                                              growable: false),
                                        ),
                                      )
                                  ],
                                ),
                              )),
                              DataCell(
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      Text('${product['price']}', style: style.textTheme.labelMedium),
                                    ],
                                  ),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      Text('${product['qty']}', style: style.textTheme.labelMedium),
                                    ],
                                  ),
                                ),
                              ),
                              if (breakdown == true)
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      children: [
                                        Text('${product['totalprice']}', style: style.textTheme.labelMedium),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                //
                Container(
                  height: 1,
                  color: Colors.black,
                  width: 550,
                ),
                SizedBox(
                  height: 80,
                  width: 550,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8, top: 3),
                                      child: Text('Total:', style: style.textTheme.labelMedium),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text('Discount:', style: style.textTheme.labelMedium),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      child: Text('Final:', style: style.textTheme.labelMedium),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8, top: 3),
                                      child: Text('${widget.qou.total}', style: style.textTheme.labelMedium),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text('${widget.qou.discount}', style: style.textTheme.labelMedium),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      child: Text('${widget.qou.finalTotal}', style: style.textTheme.labelMedium),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 80,
                        color: Colors.black,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Customer Sign',
                                  style: style.textTheme.labelMedium,
                                ),
                                Text(
                                  '${user.userName}',
                                  style: style.textTheme.labelMedium,
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      actions: [
        Text(
          ref,
          style: style.textTheme.bodyLarge!.copyWith(color: Colors.green),
        ),
        Checkbox(
            value: breakdown,
            onChanged: (v) {
              setState(() {
                breakdown = v!;
              });
            }),
        Text(
          'Price Breakdown',
          style: style.textTheme.labelLarge,
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: 30,
            child: OutlinedButton.icon(
              onPressed: () async {
                String? path = await FilePicker.platform.getDirectoryPath();
                if (path != null) {
                  ByteData imagebyte = await WidgetToImage.repaintBoundaryToImage(imageKey, pixelRatio: 5);
                  Uint8List imageint = imagebyte.buffer.asUint8List();
                  File image = File("$path/${widget.qou.name} ${widget.qou.finalTotal}.png");
                  await image.writeAsBytes(imageint);
                  setState(() {
                    ref = 'Saved successfully !';
                  });
                }
              },
              icon: const Icon(Ionicons.download_outline, size: 20),
              label: const Text('Download'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: 30,
            child: OutlinedButton.icon(
              onPressed: () async {
                final tempDir = await getTemporaryDirectory();
                String path = '${tempDir.path}/temp.png';
                print(path);
                ByteData imagebyte = await WidgetToImage.repaintBoundaryToImage(imageKey, pixelRatio: 5);
                Uint8List imageint = imagebyte.buffer.asUint8List();
                File image = File(path);
                image.writeAsBytes(imageint).whenComplete(() {
                  String msg = WhatsAppTemplate().retriveMsg('') ?? '';
                  WhatsappApi().sendBill(msg: msg, number: '721965611' ?? '', path: path, fileName: path).then((value) {
                    if (value != 'error') {
                      final bar = SnackBar(
                        behavior: SnackBarBehavior.floating,
                        width: MediaQuery.of(context).size.height - 40,
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 5),
                        content: Text(
                          'Message Sent',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: style.textTheme.bodyLarge!.fontSize ?? 14,
                            fontWeight: style.textTheme.bodyLarge!.fontWeight,
                          ),
                        ),
                        action: SnackBarAction(label: 'Ok', textColor: Colors.white, onPressed: () {}),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(bar);
                    } else {
                      final bar = SnackBar(
                        behavior: SnackBarBehavior.floating,
                        width: MediaQuery.of(context).size.height - 40,
                        backgroundColor: style.errorColor,
                        duration: const Duration(seconds: 5),
                        content: Text(
                          'value.error.toString()',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: style.textTheme.bodyLarge!.fontSize ?? 14,
                            fontWeight: style.textTheme.bodyLarge!.fontWeight,
                          ),
                        ),
                        action: SnackBarAction(label: 'Ok', textColor: Colors.white, onPressed: () {}),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(bar);
                    }
                    Navigator.pop(context);
                  });
                });
              },
              icon: const Icon(FontAwesome.send, size: 13),
              label: const Text('Send'),
            ),
          ),
        ),
      ],
    );
  }
}
