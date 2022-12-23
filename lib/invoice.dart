import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/auth/auth.dart';
import 'package:jk_photography_manager/auth/m_user.dart';

import 'dart:io';

import 'package:jk_photography_manager/model/m_quotation.dart';
import 'package:provider/provider.dart';
import 'package:puppeteer/protocol/page.dart';
import 'package:widget_to_image/widget_to_image.dart';

class Invoice extends StatefulWidget {
  MQuotation qou;

  Invoice({
    required this.qou,
    Key? key,
  }) : super(key: key);

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  String ref = '';

  GlobalKey _imageKey = GlobalKey();
  bool breakdown = true;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    MUser user = auth.giveMetheUser();
    var style = Theme.of(context);
    return AlertDialog(
      content: RepaintBoundary(
        key: _imageKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 1050, minWidth: 550, maxWidth: 550),
          child: Container(
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
                      padding: const EdgeInsets.all(2.0),
                      child: SizedBox(
                        height: 60,
                        child: AspectRatio(
                          aspectRatio: 2.5 / 2,
                          child: user.logo != null ? Image.memory(user.logo!) : Container(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.userBussinessName,
                              style: style.textTheme.bodyLarge,
                            ),
                            AutoSizeText(
                              "Mo. ${user.userNumber} ${user.userBussinessAddress}",
                              maxLines: 2,
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
                ListRowHeding(
                  needBoder: false,
                  color: Colors.amber.shade200,
                  children: [
                    Text('Product Name', style: Theme.of(context).textTheme.labelMedium),
                    Text('Total Price', style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
                Container(
                  height: 1,
                  color: Colors.black,
                  width: 550,
                ),
                Expanded(
                  child: ColoredBox(
                    color: Colors.amber.shade100,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: true,
                      itemBuilder: (context, index) {
                        Map<dynamic, dynamic> product = widget.qou.cart[index];
                        List<String>? des = product['Description'];
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity(vertical: -4.0),
                          title: ListRowHeding(
                            needBoder: true,
                            color: Colors.amber.shade200,
                            children: [
                              Text(product['product'], style: style.textTheme.labelLarge),
                              Text('\u{20B9} ${product['totalprice']}', style: style.textTheme.labelLarge),
                            ],
                          ),
                          subtitle: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: List.generate(
                              des!.length,
                              growable: false,
                              (index) {
                                return ListRowHeding(needBoder: true, color: Colors.amber.shade100, children: [Text(des[index], style: style.textTheme.labelMedium)]);
                              },
                            ),
                          ),
                        );
                      },
                      itemCount: widget.qou.cart.length,
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.black,
                  width: 550,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(' कृपया फोनवर अपॉइनमेंट घेऊनच येणे.', style: style.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text('''
टिप - १) ऑर्डर दिलेले फोटो /अल्बम / कॅसेट / सीडी / डीव्हीडी ३० दिवसांत घेऊन जाणे. २) ७५ टक्केरक्‍कम अँडव्हान्स द्यावी लागेल.२५ ठक्के रक्‍कम फोटो सिलेक्शन च्या वेळेस द्यावी लागेल. ३) सॉफ्ट कॉपी साठी ऑर्डर बील च्या ३५ टक्के जादा चार्ज लागेल. तसेच फोटो रेझॉल्युशन १०० ही.पी.आय. असेल ४) मेकप च्या सेवेसाठी वेगळे चार्जेस द्यावे लागतील. तसेच मेकप मटेरियलच्या उपलब्धतेनुसारच ही सेवा देण्यात येईल. ५) अचानक येणाऱ्या काही तांत्रिक अडचणींमुळे ऑर्डर पूर्ण करण्यास उशीर होऊ शकतो. ६) एकदा सिलेक्ट केलेले फोटो, अल्बम पुन्हा बदलून मिळणार नाहीत. ७) व्हीडीओ शुटींग मधील गाणी उपलब्धतेनुसारच निवडण्यात येतील, ठराविकच गाण्यासाठी आग्रही असू नये. ८) कार्यक्रम वेळेवर सुरु न झाल्यास किंवा वेळेवर न संपल्यास ओव्हर टाईम चार्जेस प्रति व्यक्ती रु.१०००/- लागतील,''', style: style.textTheme.bodySmall!.copyWith(fontSize: 10, color: Colors.black87))
                  ],
                ),
                // Flexible(
                //   child: SizedBox(
                //     width: 550,
                //     child: DataTable2(
                //         lmRatio: 1.5,
                //         horizontalMargin: 10,
                //         columnSpacing: 10,
                //         headingRowHeight: 30,
                //         showBottomBorder: true,
                //         headingRowColor: MaterialStateProperty.all(const Color.fromARGB(71, 255, 172, 64)),
                //         columns: [
                //           DataColumn2(label: Text('No.', style: style.textTheme.labelMedium), fixedWidth: 45),
                //           DataColumn2(label: Text('Product', style: style.textTheme.labelMedium), size: ColumnSize.L),
                //           DataColumn2(label: Text('Price', style: style.textTheme.labelMedium), size: ColumnSize.S),
                //           DataColumn2(label: Text('Qty', style: style.textTheme.labelMedium), fixedWidth: 80),
                //           if (breakdown == true)
                //             DataColumn2(
                //               label: Text(
                //                 'Total',
                //                 style: style.textTheme.labelMedium,
                //               ),
                //               size: ColumnSize.S,
                //             )
                //         ],
                //         rows: List.generate(widget.qou.cart.length, (index) {
                //           Map<dynamic, dynamic> product = widget.qou.cart[index];
                //           List<String>? des = product['Description'];
                //           print(des == null);
                //           return DataRow2.byIndex(
                //             color: MaterialStateProperty.all(style.canvasColor),
                //             specificRowHeight: des == null ? 40 : (des.length * style.textTheme.bodyLarge!.fontSize!) + style.textTheme.bodyMedium!.fontSize! + 36,
                //             index: index,
                //             cells: [
                //               DataCell(Padding(
                //                 padding: const EdgeInsets.symmetric(vertical: 10),
                //                 child: Column(
                //                   children: [
                //                     Text('${index + 1}', style: style.textTheme.labelMedium),
                //                   ],
                //                 ),
                //               )),
                //               DataCell(Padding(
                //                 padding: const EdgeInsets.symmetric(vertical: 10),
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Text(product['product'], style: style.textTheme.labelMedium),
                //                     if (des != null)
                //                       Padding(
                //                         padding: const EdgeInsets.symmetric(vertical: 2),
                //                         child: ListView(
                //                           shrinkWrap: true,
                //                           children: List.generate(
                //                               des.length,
                //                               (index) => Text(
                //                                     des[index],
                //                                     style: style.textTheme.bodySmall,
                //                                   ),
                //                               growable: false),
                //                         ),
                //                       )
                //                   ],
                //                 ),
                //               )),
                //               DataCell(Padding(
                //                 padding: const EdgeInsets.symmetric(vertical: 10),
                //                 child: Column(
                //                   children: [
                //                     Text('${product['price']}', style: style.textTheme.labelMedium),
                //                   ],
                //                 ),
                //               )),
                //               DataCell(Padding(
                //                 padding: const EdgeInsets.symmetric(vertical: 10),
                //                 child: Column(
                //                   children: [
                //                     Text('${product['qty']}', style: style.textTheme.labelMedium),
                //                   ],
                //                 ),
                //               )),
                //               if (breakdown == true)
                //                 DataCell(
                //                   Padding(
                //                     padding: const EdgeInsets.symmetric(vertical: 10),
                //                     child: Column(
                //                       children: [
                //                         Text('${product['totalprice']}', style: style.textTheme.labelMedium),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //             ],
                //           );
                //         })),
                //   ),
                // ),
                //
                Container(
                  height: 1,
                  color: Colors.black,
                  width: 550,
                ),
                SizedBox(
                  height: 60,
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
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: 30,
            child: OutlinedButton.icon(
              onPressed: () async {
                // String? path = Directory.systemTemp.absolute.path;
                // if (path != null) {
                //   ByteData imagebyte = await WidgetToImage.repaintBoundaryToImage(
                //     _imageKey,
                //   );
                //   Uint8List imageint = imagebyte.buffer.asUint8List();
                //   Printer? printer = await Printing.pickPrinter(context: context);
                //   if (printer != null) {
                //     try {
                //       await Printing.layoutPdf(onLayout: (_) => imageint);
                //     } catch (e) {}
                //   }
                // }
              },
              icon: const Icon(MaterialIcons.print, size: 20),
              label: const Text('Print'),
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
                  ByteData imagebyte = await WidgetToImage.repaintBoundaryToImage(_imageKey, pixelRatio: 5);
                  Uint8List imageint = imagebyte.buffer.asUint8List();
                  File image = File("${path}/${widget.qou.name} ${widget.qou.finalTotal}.png");
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
      ],
    );
  }
}

class ListRowHeding extends StatelessWidget {
  final List<Widget> children;
  final Color? color;
  final bool needBoder;
  const ListRowHeding({
    Key? key,
    required this.needBoder,
    this.color,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(color: color, border: needBoder == true ? Border(bottom: BorderSide(color: Colors.black12)) : null),
      padding: const EdgeInsets.all(8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children),
    );
  }
}
