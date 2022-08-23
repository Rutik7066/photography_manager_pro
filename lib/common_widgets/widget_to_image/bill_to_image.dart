import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/auth/auth.dart';
import 'package:jk_photography_manager/auth/m_user.dart';

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:jk_photography_manager/model/m_bill.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:widget_to_image/widget_to_image.dart';

class BillToImage extends StatefulWidget {
  MBill bill;

  BillToImage({
    required this.bill,
    Key? key,
  }) : super(key: key);

  @override
  State<BillToImage> createState() => _BillToImageState();
}

class _BillToImageState extends State<BillToImage> {
  String ref = '';

  GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    MUser user = auth.giveMetheUser();
    var style = Theme.of(context);
    String datef = '${widget.bill.created?.day}/${widget.bill.created?.month}/${widget.bill.created?.year}';
    return AlertDialog(
      content: RepaintBoundary(
        key: _imageKey,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 1050, minWidth: 550, maxWidth: 550),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(3)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 90,
                          child: AspectRatio(
                            aspectRatio: 2 / 2,
                            child: user.logo != null
                                ? Image.memory(user.logo!)
                                : Container(
                                    height: 100,
                                    width: 100,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 390,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 400,
                                child: AutoSizeText(
                                  user.userBussinessName,
                                  style: style.textTheme.headline6,
                                ),
                              ),
                              SizedBox(
                                width: 400,
                                child: AutoSizeText(
                                  'Mo. ${user.userNumber}',
                                  style: style.textTheme.bodyLarge,
                                ),
                              ),
                              SizedBox(
                                width: 400,
                                child: Wrap(
                                  children: [
                                    Text(
                                      user.userBussinessAddress,
                                      maxLines: 3,
                                      style: style.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
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
                              '${widget.bill.customername}',
                              style: style.textTheme.labelMedium,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                            child: Text(
                              'Bill# ${widget.bill.billindex}',
                              style: style.textTheme.labelMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                            child: Text(
                              'Date: $datef',
                              style: style.textTheme.labelMedium,
                            ),
                          )
                        ],
                      )
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
                            DataColumn2(
                              label: Text(
                                'Total',
                                style: style.textTheme.labelMedium,
                              ),
                              size: ColumnSize.S,
                            ),
                          ],
                          rows: List.generate(widget.bill.cart!.length, (index) {
                            Map<String, dynamic> product = widget.bill.cart![index];
                            List<String>? des = product['Description'];
                            print(des == null);
                            return DataRow2.byIndex(
                              specificRowHeight: des == null ? 40 : (des.length * style.textTheme.bodyLarge!.fontSize!) + style.textTheme.bodyMedium!.fontSize! + 32,
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
                                DataCell(Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      Text('${product['price']}', style: style.textTheme.labelMedium),
                                    ],
                                  ),
                                )),
                                DataCell(Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      Text('${product['qty']}', style: style.textTheme.labelMedium),
                                    ],
                                  ),
                                )),
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
                          })),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black,
                    width: 550,
                  ),
                  SizedBox(
                    height: 110,
                    width: 550,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 270,
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
                                        child: Text('Total:', style: style.textTheme.labelLarge),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text('Discount:', style: style.textTheme.labelLarge),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        child: Text('Final:', style: style.textTheme.labelLarge),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, bottom: 3),
                                        child: Text('Paid:', style: style.textTheme.labelLarge),
                                      ),
                                       Padding(
                                        padding: const EdgeInsets.only(left: 8, bottom: 3),
                                        child: Text('Unpaid:', style: style.textTheme.labelLarge),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, top: 3),
                                        child: Text('${widget.bill.total}', style: style.textTheme.labelLarge),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text('${widget.bill.discount}', style: style.textTheme.labelLarge),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        child: Text('${widget.bill.finalTotal}', style: style.textTheme.labelLarge),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, bottom: 3),
                                        child: Text('${widget.bill.paymentOrAdvance}', style: style.textTheme.labelLarge),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, bottom: 3),
                                        child: Text('${widget.bill.unPaid}', style: style.textTheme.labelLarge),
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
                          height: 110,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 270,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Jk Studio',
                                style: style.textTheme.bodyLarge,
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
      ),
      actions: [
        Text(
          ref,
          style: style.textTheme.bodyLarge!.copyWith(color: Colors.green),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: 30,
            child: OutlinedButton.icon(
              onPressed: () async {
                String? path = Directory.systemTemp.absolute.path;
                if (path != null) {
                  ByteData imagebyte = await WidgetToImage.repaintBoundaryToImage(_imageKey,);
                  Uint8List imageint = imagebyte.buffer.asUint8List();
                  Printer? printer = await Printing.pickPrinter(context: context);
                  if (printer != null) {
                    try {
                      await Printing.layoutPdf(onLayout: (_) => imageint);
                    } catch (e) {}
                  }
                }
              },
              icon: const Icon(MaterialIcons.print, size: 20),
              label: const Text(
                'Print'
              ),
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
                  ByteData imagebyte = await WidgetToImage.repaintBoundaryToImage(_imageKey,pixelRatio : 5);
                  Uint8List imageint = imagebyte.buffer.asUint8List();
                  File image = File("${path}/${widget.bill.customername} ${widget.bill.finalTotal}.png");
                  await image.writeAsBytes(imageint);
                  setState(() {
                    ref = 'Saved successfully !';
                  });
                }
              },
              icon: const Icon(Ionicons.download_outline, size: 20),
              label: const Text(
                'Download'
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close'
              ),
            ),
          ),
        ),
      ],
    );
  }
}
