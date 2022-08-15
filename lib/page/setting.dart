import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/auth/auth.dart';
import 'package:jk_photography_manager/auth/m_user.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/data_backup.dart';
import 'package:jk_photography_manager/model/m_product.dart';
import 'package:jk_photography_manager/provider/product_provider.dart';
import 'package:jk_photography_manager/repo/whatsapptemplate.dart';
import 'package:jk_photography_manager/widgets/setting/add_package.dart';
import 'package:jk_photography_manager/widgets/setting/edit_package.dart';
import 'package:jk_photography_manager/widgets/setting/edit_product.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../widgets/setting/add_product.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var productPro = Provider.of<ProductProvider>(context);
    var auth = Provider.of<Auth>(context);
    MUser user = auth.giveMetheUser();
    var style = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 100,
                        child: AspectRatio(
                          aspectRatio: 2 / 2,
                          child: user.logo != null
                              ? Image.memory(
                                  user.logo!,
                                  height: 100,
                                  width: 100,
                                )
                              : const SizedBox(
                                  height: 100,
                                  width: 100,
                                ),
                        ),
                      ),
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              width: 400,
                              child: AutoSizeText(
                                user.userName.toString(),
                                style: style.textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              width: 400,
                              child: AutoSizeText(
                                user.userBussinessName.toString(),
                                style: style.textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              width: 400,
                              child: AutoSizeText(
                                'Mo. ${user.userNumber}',
                                style: style.textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              width: 400,
                              child: Wrap(
                                children: [
                                  Text(
                                    user.userBussinessAddress.toString(),
                                    maxLines: 3,
                                    style: style.textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Column(
                    children: [
                      PopupMenuButton(
                        iconSize: 20,
                        splashRadius: 20,
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            child: Text(
                              'Backup Data',
                              style: style.textTheme.bodyMedium,
                            ),
                            onTap: () async {
                              String? path = await FilePicker.platform.getDirectoryPath();
                              if (path != null) {
                                int r = await Data().backup(path);
                                if (r == 0) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text('Backup successful !', style: style.textTheme.bodyLarge),
                                      actions: [
                                        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                                      ],
                                    ),
                                  );
                                } else if (r == 1) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text('Backup Failed!.Try again.', style: style.textTheme.bodyLarge),
                                      actions: [
                                        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                                      ],
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          PopupMenuItem(
                            child: Text(
                              'Restore Data',
                              style: style.textTheme.bodyMedium,
                            ),
                            onTap: () async {
                              String? path = await FilePicker.platform.getDirectoryPath();
                              if (path != null) {
                                int r = await Data().restore(path);
                                if (r == 0) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text('Restore successful!. Restart to see changes', style: style.textTheme.bodyLarge),
                                      actions: [
                                        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                                      ],
                                    ),
                                  );
                                } else if (r == 1) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text('Restore Failed!. Restart and try again.', style: style.textTheme.bodyLarge),
                                      actions: [
                                        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                                      ],
                                    ),
                                  );
                                }
                              }
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: SizedBox(
                      //     height: 30,
                      //     child: OutlinedButton.icon(
                      //       onPressed: () async {
                      //         await showDialog(
                      //           context: context,
                      //           builder: (context) {
                      //             _msgController.text = WhatsAppTemplate().retriveMsg('welcomenote') ?? '';
                      //             return AlertDialog(
                      //               title: const Text('Whatsapp Greeting Message'),
                      //               content: MyTextField(
                      //                 hintText: 'Type Message here...',
                      //                 maxLines: 10,
                      //                 minLines: 10,
                      //                 controller: _msgController,
                      //               ),
                      //               actions: [
                      //                 Padding(
                      //                   padding: const EdgeInsets.all(8.0),
                      //                   child: SizedBox(
                      //                       height: 30,
                      //                       child: OutlinedButton(
                      //                           onPressed: () {
                      //                             WhatsAppTemplate().addMsg(_msgController.text, 'welcomenote');
                      //                             Navigator.pop(context);
                      //                           },
                      //                           child: const Text('Change'))),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 30,
                      //                   child: ElevatedButton(
                      //                     onPressed: () {
                      //                       Navigator.pop(context);
                      //                     },
                      //                     child: const Text('Cancel'),
                      //                   ),
                      //                 )
                      //               ],
                      //             );
                      //           },
                      //         );
                      //       },
                      //       icon: const Icon(
                      //         Ionicons.add,
                      //         size: 20,
                      //       ),
                      //       label: const Text('Change Greeting Message'),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 30,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AddProduct();
                              },
                            );
                          },
                          icon: const Icon(
                            Ionicons.images_outline,
                            size: 20,
                          ),
                          label: const Text('Add Product'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 30,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AddPackage();
                                },
                              );
                            },
                            icon: const Icon(
                              Ionicons.images_outline,
                              size: 20,
                            ),
                            label: const Text('Add Package'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DataTable2(
                      columns: [
                        DataColumn2(label: Text('Index', style: style.textTheme.bodyLarge)),
                        DataColumn2(label: Text('Type', style: style.textTheme.bodyLarge)),
                        DataColumn2(label: Text('Name', style: style.textTheme.bodyLarge)),
                        DataColumn2(label: Text('Price', style: style.textTheme.bodyLarge)),
                      ],
                      rows: List.generate(
                        productPro.allProduct.length,
                        (index) {
                          MProduct product = productPro.allProduct[index];
                          String type = product.description != null ? 'Package' : 'Product';
                          return DataRow2.byIndex(
                            color: MaterialStateProperty.all(style.canvasColor),
                            onDoubleTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  if (product.description != null) {
                                    return EditPackage(package: product);
                                  } else {
                                    return EditProduct(product: product);
                                  }
                                },
                              );
                            },
                            index: index,
                            cells: [
                              DataCell(Text('${index + 1}')),
                              DataCell(Text(type)),
                              DataCell(Text(product.productname.toString())),
                              DataCell(Text(product.price.toString())),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
