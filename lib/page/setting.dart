import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/auth/auth.dart';
import 'package:jk_photography_manager/auth/m_user.dart';
import 'package:jk_photography_manager/data_backup.dart';
import 'package:jk_photography_manager/model/m_product.dart';
import 'package:jk_photography_manager/provider/product_provider.dart';
import 'package:jk_photography_manager/repo/whatsapptemplate.dart';
import 'package:jk_photography_manager/widgets/setting/add_package.dart';
import 'package:jk_photography_manager/widgets/setting/edit_package.dart';
import 'package:jk_photography_manager/widgets/setting/edit_product.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../common_widgets/my_textfield.dart';
import '../widgets/setting/add_product.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final TextEditingController _templateController = TextEditingController();
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
                      ),
                      SizedBox(
                        height: 30,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            String accesToken = '5a08c224cbcda1310d60de6243c429e4';
                            String instanceId = '';
                            String url = 'https://asnbulksender.in/api/createinstance.php?access_token=$accesToken';

                            post(Uri.parse(url)).then((value) {
                              instanceId = jsonDecode(value.body)['instance_id'];
                              get(Uri.parse('https://asnbulksender.in/api/getqrcode.php?instance_id=$instanceId&access_token=$accesToken')).then((value) async {
                                if (value.statusCode == 200) {
                                  String data = jsonDecode(value.body)['base64'];
                                  print(data.split(',').last);
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: SizedBox(
                                            height: 500,
                                            width: 500,
                                            child: Image.memory(
                                              base64Decode(data.split(',').last),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }).onError((error, stackTrace) {
                                print(error);
                              });
                            }).onError((error, stackTrace) {
                              print(error);
                            });
                          },
                          icon: const Icon(
                            Ionicons.md_logo_whatsapp,
                            size: 20,
                          ),
                          label: const Text('Whatsapp Login'),
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
                                    _templateController.text = WhatsAppTemplate().retriveMsg('template') ?? '';
                                    print(WhatsAppTemplate().retriveMsg('template'));
                                    return AlertDialog(
                                      content: SizedBox(
                                        width: 500,
                                        height: 300,
                                        child: Column(
                                          children: [
                                            Padding(padding: const EdgeInsets.all(8.0), child: Text('Whatsapp Template', style: style.textTheme.labelLarge)),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: MyTextField(
                                                  controller: _templateController,
                                                  maxLines: 15,
                                                  minLines: 15,
                                                  hintText: '',
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton.icon(
                                              onPressed: () async {
                                                print(_templateController.text);
                                                WhatsAppTemplate().addMsg(_templateController.text, 'template').whenComplete(() => Navigator.of(context).pop());
                                              },
                                              icon: Icon(Ionicons.add_outline, size: 15),
                                              label: Text('Save')),
                                        )
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(
                              Ionicons.md_logo_whatsapp,
                              size: 20,
                            ),
                            label: const Text('Whatsapp Template'),
                          ),
                        ),
                      ),
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

var fData = 'iVBORw0KGgoAAAANSUhEUgAAAVkAAAFZCAAAAAAXmQMHAAAGcElEQVR42u3aW3LkNhAEwLn/pe0LaKAqNElQG4kvr0caEglFNPrx+c+6Z30QkCVrkSVL1iJLlqxFlixZiyxZshZZsmQtsm+T/fy+vn/h75/+9CPBB9XDq19bv8umBlmyZMmSPSVb2X19mXQja5ifnvv1n19/rfrg63NTK7JkyZIle1R2vcN065XTTx98DcVpGA/Osdpv4E6WLFmyZP+O7CRTXKNW5N/3GiaskxsLWbJkyZL9V2SDCmy160o7gF4fJlmyZMmS/bOyKUK6ucApOLj0RNO/hnW/8ETlmyxZsmTJDmQnGeC/918PTx+RJUuWLNk92XSl3b809qbZY3CbCC4DwbVghEOWLFmyZJ+XvXroZLN621dqxzXgzcEbsmTJkiX7Etkg8G9mhX24Xz8tqNkG2unvfv2bIkuWLFmyb5INZlCq0ZUg1QwuDcFlILi7VFl1+vVkyZIlS/btstXwzHqKMh20TCdjqgGd9HzIkiVLluxflK0aidXTrx68qfLXNHNPu6dkyZIlS/ZNsgHW5uxLmkemd5ILrxRVMj6qfJMlS5Ys2TtkU9Sq6ln1GtcDK8HFJK0ap/Mw/aGTJUuWLNmjsilg8MOTec/+zKpYnv5ItS2yZMmSJXtKtoqpabn2E67UuEq3q0R+MtdDlixZsmRPya45qiZkNZeyiVW1Cjc/vafyTZYsWbJkb5NNxybT4F292/pp6VhO6lkNxST5MFmyZMmSfV62aqdV0TVw6kdCg2dUuWr6aqPKN1myZMmSfV62eo/g5tDH4zTIJ/uvb0Bxp5QsWbJkyT4v24fJ1Kn65r7r2N9dqr+kqtdIlixZsmRPyVZRs8oj7xvIrGqslWJaxyVLlixZskdlJ+F0s0GYdgn7I9ysBqcvuVE3IEuWLFmyD8hWcTGd40wvF30Omp7FpEkaFH3JkiVLluwp2YlTmtimMyjpP9M6c9Uv/CzXboeRLFmyZMneJhs0/qqWYl82XQ9z9hG8uqekfzCjKU+yZMmSJXuHbF+QXUfcNDIHz+j7j7uhPcxpyZIlS5bsm2Q/e2tSgU1vDv2U5zo9Di4hwc+RJUuWLNnXya5jYPXg/pCClDR43cmJ9s8lS5YsWbLnZfuabVWG7fuKaSm16iFOxm3IkiVLluyLZTcD62bPrx/LSV88jerVc3/JpcmSJUuW7POyVTaaPimNwmk+nNZJq9tE9fDd3i1ZsmTJkr1NNkgwx8MpfUU3jeqT8Z20NEuWLFmyZN8pW4XYdOt95be/mASAAW9fbCZLlixZsu+UTcdjqjvEJmXwBWkptepEbtSKyZIlS5bs87L9EMs1Ey9VibTPuYMibfproxkZsmTJkiV7r2wayycTKpsl3OAWs8ZKa8/VgZAlS5Ys2fOy66Su79YFVdlJ9K8y3jRv7rdPlixZsmTPy67Tu/6DdCOTpDj9luDgJhVnsmTJkiV7Xraah+kjbvDcKnhXT0uvD1WyS5YsWbJkXyKbRuu0/rn5/9KOYJXnVkd9z62LLFmyZMneIZuWYYPUNciCJ7eEtJU56RfuboEsWbJkyR6STd88aLb1kT6dkUkp02tLWvkd3Q3IkiVLluxtstWQZrCHTfJJv7Afy6mqt7t3A7JkyZIle69sWpXtNxKk0dW8Z7X18chMei0gS5YsWbJHZfuqZ9pDnAy2BAE9PYG+wHtlh5EsWbJkyd4hm0bNTY6rI3jwVkFheXPIhixZsmTJvkm2gk4nT6pkMq3jXjPikr5fMPpDlixZsmTPy/ZF1UkzMIVJt3lN/7EvNpMlS5Ys2fOyafxcB9Z0FKa3q461+tPZnKAhS5YsWbLnZavSbBBnqxJuVRhNLzDj97unw0iWLFmyZO+VDdpz6Yar+mxVQJ1MalaPDK5BZMmSJUv2lGy6gjdKm4HVDEr6u109tbklkCVLlizZd8pW0TC4DPTV0fVNpPrS6hzXleTuW8iSJUuW7CHZ6kaQpqlBWplm0Gnvsj/HyT2FLFmyZMm+RLYaXelnNif12bSmHPyZVHubZ7dkyZIlS/ZFsuvHpR9sivWHmdZng1sCWbJkyZL9s7JV0lltveKoBnmqY939erJkyZIle1K2+nRcuF3PlMZpZZ3iBontw5VvsmTJkiU7kA2qo2lUT4P8Nfuv7il93XU+I0OWLFmyZG+TtS5YZMmStciSJWuRJUvWIkuWrEWWLFmLLFmyFtmT63/3F2u8uKyvWAAAAABJRU5ErkJggg==';
