import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/repo/whatsapptemplate.dart';
import 'package:jk_photography_manager/whatsapp_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:jk_photography_manager/auth/auth.dart';
import 'package:jk_photography_manager/auth/m_user.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/common_widgets/new_customer.dart';
import 'package:jk_photography_manager/common_widgets/widget_to_image/bill_to_image.dart';
import 'package:jk_photography_manager/controller/regular_bill_controller.dart';
import 'package:jk_photography_manager/model/m_bill.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/model/m_product.dart';
import 'package:jk_photography_manager/provider/business_provider.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';
import 'package:jk_photography_manager/provider/product_provider.dart';
import 'package:widget_to_image/widget_to_image.dart';

import '../../whatsapp_services/whatsapp_function.dart';

class NewBill extends StatefulWidget {
  const NewBill({Key? key}) : super(key: key);

  @override
  State<NewBill> createState() => _NewBillState();
}

class _NewBillState extends State<NewBill> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _disController = TextEditingController();
  final TextEditingController _payController = TextEditingController();

  MCustomer? _selectedCustomer;

  String _dropdowninitvalue = 'Cash';

  @override
  Widget build(BuildContext context) {
    var productPro = Provider.of<ProductProvider>(context);
    var regularbillcontroller = Provider.of<RegularBillController>(context);
    var customerprovider = Provider.of<CustomerProvider>(context);
    var style = Theme.of(context);
    List<Map<String, dynamic>> selectedproducts = regularbillcontroller.selectedProducts;
    var auth = Provider.of<Auth>(context);
    MUser user = auth.giveMetheUser();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 400,
                child: TypeAheadField<MCustomer>(
                  hideOnEmpty: true,
                  textFieldConfiguration: TextFieldConfiguration(
                    style: style.textTheme.bodyMedium,
                    controller: _customerController,
                    decoration: InputDecoration(
                      hintText: 'Customer name',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      filled: true,
                      hintStyle: style.textTheme.bodyMedium,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                      alignLabelWithHint: false,
                    ),
                  ),
                  onSuggestionSelected: (item) {
                    setState(() {
                      _customerController.text = item.name!;
                      _selectedCustomer = item;
                    });
                  },
                  itemBuilder: (BuildContext context, itemData) {
                    return ListTile(
                      title: Text(itemData.name!),
                      trailing: Text(itemData.number!),
                    );
                  },
                  suggestionsCallback: (pattern) {
                    return customerprovider.getCustomer(pattern);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: OutlinedButton.icon(
                onPressed: () async {
                  await showDialog(context: context, builder: (context) => NewCustomer());
                },
                icon: const Icon(MaterialIcons.person_add_alt_1, size: 20),
                label: Text(
                  'Customer',
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: 400,
                  child: TypeAheadField<MProduct>(
                    hideOnEmpty: true,
                    textFieldConfiguration: TextFieldConfiguration(
                      style: style.textTheme.bodyMedium,
                      controller: _productController,
                      decoration: InputDecoration(
                        hintText: 'Product name',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        filled: true,
                        hintStyle: style.textTheme.bodyMedium,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                        alignLabelWithHint: false,
                      ),
                    ),
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Text(itemData.productname!),
                        trailing: Text(itemData.price.toString()),
                      );
                    },
                    suggestionsCallback: (String pattern) {
                      return productPro.getProductForRegularBill(pattern);
                    },
                    onSuggestionSelected: (Object? suggestion) {
                      suggestion as MProduct;
                      regularbillcontroller.selectedProduct = suggestion;

                      _productController.text = regularbillcontroller.selectedProduct!.productname!;
                    },
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(10),
              child: MyTextField(
                width: 200,
                hintText: 'Qty',
                controller: _qtyController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: OutlinedButton.icon(
                onPressed: () {
                  if (regularbillcontroller.selectedProduct != null) {
                    MProduct product = regularbillcontroller.selectedProduct!;
                    int qty = int.tryParse(_qtyController.text) ?? 1;
                    regularbillcontroller.addToCart(
                      productname: product.productname!,
                      productPrice: product.price!,
                      qty: qty,
                      totalprice: product.price! * qty,
                    );
                  }
                },
                icon: const Icon(MaterialIcons.add_shopping_cart, size: 20),
                label: Text(
                  'Add Product',
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: DataTable2(
            dataRowHeight: 40,
            headingRowHeight: 40,
            columns: [
              DataColumn2(
                  label: Text(
                    'Index',
                    style: style.textTheme.bodyLarge,
                  ),
                  fixedWidth: 70),
              DataColumn2(
                  label: Text(
                    'Product',
                    style: style.textTheme.bodyLarge,
                  ),
                  size: ColumnSize.L),
              DataColumn2(
                label: Text(
                  'Price',
                  style: style.textTheme.bodyLarge,
                ),
              ),
              DataColumn2(
                label: Text(
                  'Qty',
                  style: style.textTheme.bodyLarge,
                ),
              ),
              DataColumn2(
                label: Text(
                  'Total',
                  style: style.textTheme.bodyLarge,
                ),
              ),
              DataColumn2(
                label: Text(
                  '',
                  style: style.textTheme.bodyLarge,
                ),
              )
            ],
            rows: List.generate(
              selectedproducts.length,
              (index) {
                Map<String, dynamic> product = selectedproducts[index];
                return DataRow2.byIndex(index: index, cells: [
                  DataCell(SizedBox(
                      width: 100,
                      child: AutoSizeText(
                        '${index + 1}',
                        style: style.textTheme.bodyText2,
                      ))),
                  DataCell(AutoSizeText(
                    '${product['product']}',
                    style: style.textTheme.bodyText2,
                  )),
                  DataCell(AutoSizeText(
                    '${product['price']}',
                    style: style.textTheme.bodyText2,
                  )),
                  DataCell(AutoSizeText(
                    '${product['qty']}',
                    style: style.textTheme.bodyText2,
                  )),
                  DataCell(AutoSizeText(
                    '${product['totalprice']}',
                    style: style.textTheme.bodyText2,
                  )),
                  DataCell(
                    IconButton(
                      splashRadius: 20,
                      icon: const Icon(AntDesign.minuscircleo, size: 20),
                      onPressed: () {
                        regularbillcontroller.removeFromCart(index);
                      },
                    ),
                  ),
                ]);
              },
            ),
          ),
        ),
        const Divider(),
        if (regularbillcontroller.totalPriceOfCart > 0)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Total Price',
                    style: style.textTheme.bodyLarge,
                  ),
                ),
                Text(
                  regularbillcontroller.totalPriceOfCart.toString(),
                  style: style.textTheme.bodyLarge,
                )
              ],
            ),
          ),
        SizedBox(
          width: 600,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                    width: 150,
                    height: 30,
                    child: MyTextField(
                      hintText: 'Discount',
                      controller: _disController,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                    width: 150,
                    height: 30,
                    child: MyTextField(
                      hintText: 'Payment',
                      controller: _payController,
                    )),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                      dropdownPadding: EdgeInsets.all(2),
                      itemHeight: 28,
                      dropdownOverButton: true,
                      buttonElevation: 5,
                      buttonPadding: EdgeInsets.all(3),
                      buttonHeight: 30,
                      buttonWidth: 120,
                      buttonDecoration: BoxDecoration(border: Border.all(color: style.dividerColor), borderRadius: BorderRadius.circular(4)),
                      value: _dropdowninitvalue,
                      items: [
                        DropdownMenuItem<String>(
                          value: 'Cash',
                          child: Text(
                            'Cash',
                            style: style.textTheme.bodyMedium,
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Online',
                          child: Text('Online', style: style.textTheme.bodyMedium),
                        ),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _dropdowninitvalue = value!;
                        });
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  height: 30,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      MBill? bil;
                      if (_selectedCustomer != null && regularbillcontroller.totalPriceOfCart > 0) {
                        int intdisc = int.tryParse(_disController.text) ?? 0;
                        int total = regularbillcontroller.totalPriceOfCart;
                        int finalprice = total - intdisc;
                        int payment = int.tryParse(_payController.text) ?? 0;
                        bil = customerprovider.addBill(
                          _selectedCustomer!,
                          regularbillcontroller.selectedProducts,
                          regularbillcontroller.totalPriceOfCart,
                          intdisc,
                          finalprice,
                          payment,
                          _dropdowninitvalue,
                        );
                        String number = _selectedCustomer!.number!;
                        customerprovider.getAllBills();
                        regularbillcontroller.clear();
                        _productController.clear();
                        _customerController.clear();
                        _qtyController.clear();
                        _disController.clear();
                        _payController.clear();
                      } else {
                        final bar = SnackBar(
                          behavior: SnackBarBehavior.floating,
                          width: MediaQuery.of(context).size.height - 40,
                          backgroundColor: style.errorColor,
                          duration: const Duration(seconds: 5),
                          content: Text(
                            'Something went wrong. Kindly fill all information correctly',
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
                      if (bil != null) {
                        await showDialog(context: context, builder: (context) => BillToImage(bill: bil!));
                      }
                    },
                    icon: const Icon(Ionicons.receipt_outline, size: 15),
                    label: Text(
                      'Genarate Bill',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  height: 30,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (_selectedCustomer != null && regularbillcontroller.totalPriceOfCart > 0) {
                        int intdisc = int.tryParse(_disController.text) ?? 0;
                        int total = regularbillcontroller.totalPriceOfCart;
                        int finalprice = total - intdisc;
                        int payment = int.tryParse(_payController.text) ?? 0;
                        customerprovider.addBill(
                          _selectedCustomer!,
                          regularbillcontroller.selectedProducts,
                          regularbillcontroller.totalPriceOfCart,
                          intdisc,
                          finalprice,
                          payment,
                          _dropdowninitvalue,
                        );
                  
                        customerprovider.getAllBills();
                        regularbillcontroller.clear();
                        _productController.clear();
                        _customerController.clear();
                        _qtyController.clear();
                        _disController.clear();
                        _payController.clear();
                      } else {
                        final bar = SnackBar(
                          behavior: SnackBarBehavior.floating,
                          width: MediaQuery.of(context).size.height - 40,
                          backgroundColor: style.errorColor,
                          duration: const Duration(seconds: 5),
                          content: Text(
                            'Something went wrong. Kindly fill all information correctly',
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
                    },
                    icon: const Icon(
                      MaterialIcons.save_alt,
                      size: 20,
                    ),
                    label: Text(
                      'Save',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
