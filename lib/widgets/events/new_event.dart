import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:jk_photography_manager/auth/auth.dart';
import 'package:jk_photography_manager/auth/m_user.dart';
import 'package:jk_photography_manager/repo/whatsapptemplate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:win32/win32.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/common_widgets/new_customer.dart';
import 'package:jk_photography_manager/common_widgets/widget_to_image/bill_to_image.dart';
import 'package:jk_photography_manager/controller/new_event_controller.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/layout/navigation.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/model/m_event.dart';
import 'package:jk_photography_manager/model/m_product.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';
import 'package:jk_photography_manager/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:widget_to_image/widget_to_image.dart';
import 'package:win32/win32.dart';

import '../../whatsapp_services/whatsapp_function.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  TextEditingController _productController = TextEditingController();
  TextEditingController _customerController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  TextEditingController _disController = TextEditingController();
  TextEditingController _payController = TextEditingController();
  TextEditingController _eventnameController = TextEditingController();
  TextEditingController _eventdesController = TextEditingController();

  MCustomer? _selectedCustomer;

  String _dropdowninitvalue = 'Cash';

  String? _selectedDate;

  String? _selectedTime;

  DateTime? _date;
  TimeOfDay? _time;
  DayPeriod? _pr;

  late double w;

  List<String> eventRef = ['Birthday', 'Wedding'];

  GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var productPro = Provider.of<ProductProvider>(context);
    var neweventcontroller = Provider.of<NewEventController>(context);
    var customerprovider = Provider.of<CustomerProvider>(context);
    var style = Theme.of(context);
    var auth = Provider.of<Auth>(context);
    MUser user = auth.giveMetheUser();
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 430,
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
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 430,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 30,
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    await showDialog(context: context, builder: (conext) => NewCustomer());
                                  },
                                  icon: const Icon(MaterialIcons.person_add_alt_1, size: 20),
                                  label: Text(
                                    'Customer',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 430,
                        child: TypeAheadField<String>(
                          hideOnEmpty: true,
                          textFieldConfiguration: TextFieldConfiguration(
                            style: style.textTheme.bodyMedium,
                            controller: _eventnameController,
                            decoration: InputDecoration(
                              hintText: 'Event name',
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
                              _eventnameController.text = item;
                            });
                          },
                          itemBuilder: (BuildContext context, itemData) {
                            return ListTile(
                              title: Text(itemData),
                            );
                          },
                          suggestionsCallback: (pattern) {
                            return eventRef.where((element) => element.toString().toLowerCase().startsWith(pattern.toString().toLowerCase())).toList();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 450,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              height: 30,
                              margin: const EdgeInsets.all(10),
                              child: OutlinedButton.icon(
                                icon: const Icon(
                                  MaterialIcons.calendar_today,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  DateTime? date = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2100), initialDate: DateTime.now());
                                  if (date != null) {
                                    String datef = '${date.day}/${date.month}/${date.year}';
                                    print(date);
                                    _date = date;
                                    setState(() {
                                      _selectedDate = datef;
                                    });
                                  }
                                },
                                label: Text(
                                  _selectedDate ?? 'Date',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 30,
                              margin: const EdgeInsets.all(10),
                              child: OutlinedButton.icon(
                                icon: const Icon(
                                  Ionicons.time_outline,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                  if (time != null) {
                                    String timef = '${time.hourOfPeriod}:${time.minute} ${time.period == DayPeriod.am ? 'AM' : 'PM'}';
                                    setState(() {
                                      _pr = time.period;
                                      _time = time;
                                      _selectedTime = timef;
                                    });
                                  }
                                },
                                label: Text(
                                  _selectedTime ?? 'Time',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 430,
                          child: MyTextField(
                            maxLines: 13,
                            hintText: 'Description',
                            controller: _eventdesController,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TypeAheadField<MProduct>(
                                hideOnEmpty: true,
                                textFieldConfiguration: TextFieldConfiguration(
                                  style: style.textTheme.bodyMedium,
                                  controller: _productController,
                                  decoration: InputDecoration(
                                    hintText: 'Product/Package',
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
                                  return productPro.getProductForEvent(pattern);
                                },
                                onSuggestionSelected: (Object? suggestion) {
                                  suggestion as MProduct;
                                  neweventcontroller.selectedProduct = suggestion;
                                  _productController.text = neweventcontroller.selectedProduct!.productname!;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: MyTextField(
                                hintText: 'Qty',
                                controller: _qtyController,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              height: 30,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  if (neweventcontroller.selectedProduct != null) {
                                    MProduct product = neweventcontroller.selectedProduct!;
                                    int qty = int.tryParse(_qtyController.text) ?? 1;
                                    int totalPrice = qty * product.price!;
                                    neweventcontroller.addToCart(
                                      productname: product.productname!,
                                      description: product.description ?? [],
                                      productPrice: product.price!,
                                      qty: qty,
                                      totalprice: totalPrice,
                                    );
                                    neweventcontroller.selectedProduct = null;
                                    _productController.clear();
                                    _qtyController.clear();
                                  }
                                },
                                icon: const Icon(MaterialIcons.add_shopping_cart, size: 20),
                                label: Text(
                                  'Add',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 450,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: LayoutBuilder(builder: (context, c) {
                            w = c.maxWidth / 4 - 15;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: SizedBox(
                                      width: w,
                                      child: Text(
                                        'Product',
                                        style: style.textTheme.bodyLarge,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: SizedBox(
                                    width: w,
                                    child: Text('Price', style: style.textTheme.bodyLarge),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: SizedBox(
                                    width: w,
                                    child: Text('Qty', style: style.textTheme.bodyLarge),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: SizedBox(
                                    width: w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('Total', style: style.textTheme.bodyLarge),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 450,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.builder(
                              primary: true,
                              itemCount: neweventcontroller.selectedProducts.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> product = neweventcontroller.selectedProducts[index];
                                List<String> des = product['Description'];
                                return Dismissible(
                                  key: Key(UniqueKey().toString()),
                                  onDismissed: (d) {
                                    neweventcontroller.removeFromCart(index);
                                  },
                                  background: Container(
                                    color: Colors.indigo,
                                  ),
                                  child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 5),
                                              child: SizedBox(
                                                width: w,
                                                child: AutoSizeText(
                                                  product['product'],
                                                  style: style.textTheme.bodyLarge,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: SizedBox(
                                              width: w,
                                              child: AutoSizeText(product['price'].toString(), style: style.textTheme.bodyLarge),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: SizedBox(
                                              width: w,
                                              child: AutoSizeText(product['qty'].toString(), style: style.textTheme.bodyLarge),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5),
                                            child: SizedBox(
                                              width: w,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(product['totalprice'].toString(), style: style.textTheme.bodyLarge),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: des.isNotEmpty
                                          ? ListView(
                                              shrinkWrap: true,
                                              children: List.generate(des.length, (index) => Text(des[index]), growable: false),
                                            )
                                          : null),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Column(
          children: [
            const Divider(),
            if (neweventcontroller.totalPriceOfCart > 0)
              Padding(
                padding: const EdgeInsets.all(5.0),
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
                      neweventcontroller.totalPriceOfCart.toString(),
                      style: style.textTheme.bodyLarge,
                    )
                  ],
                ),
              ),
            Row(
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
                  padding: const EdgeInsets.all(5),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                        dropdownPadding: const EdgeInsets.all(2),
                        itemHeight: 35,
                        dropdownOverButton: true,
                        buttonElevation: 5,
                        buttonHeight: 30,
                        isDense: true,
                        buttonPadding: const EdgeInsets.all(5),
                        buttonWidth: 120,
                        buttonDecoration: BoxDecoration(color: style.cardColor, border: Border.all(color: style.dividerColor), borderRadius: BorderRadius.circular(4)),
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
                        MEvent? even;
                        if (_selectedCustomer != null && neweventcontroller.totalPriceOfCart > 0 && _pr != null && _date != null) {
                          int intdisc = int.tryParse(_disController.text) ?? 0;
                          int total = neweventcontroller.totalPriceOfCart;
                          int finalprice = total - intdisc;
                          int payment = int.tryParse(_payController.text) ?? 0;
                          even = customerprovider.addEvent(
                            customer: _selectedCustomer!,
                            eventname: _eventnameController.text,
                            date: _date!,
                            description: _eventdesController.text,
                            selectedProducts: neweventcontroller.selectedProducts,
                            total: total,
                            discount: intdisc,
                            finalprice: finalprice,
                            payment: payment,
                            paymentmode: _dropdowninitvalue,
                            pr: _pr!,
                            time: _time!,
                          );
                          String number = _selectedCustomer!.number!;
                          String customer = _selectedCustomer!.name!;
                          customerprovider.resetEvents();
                          _eventdesController.clear();
                          _disController.clear();
                          _productController.clear();
                          _customerController.clear();
                          _qtyController.clear();
                          _eventnameController.clear();
                          _payController.clear();
                          neweventcontroller.reset();
                          _selectedDate = '';
                          _selectedTime = '';
                          _selectedCustomer = null;      String message = "Dear $customer,\nThank You so much for visiting ${user.userBussinessName}.\nWe are happy to have you.";
                          WhatsappFunction().createMessage(number: number, message: message);
                      
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
                        if (even != null) {
                          await showDialog(context: context, builder: (context) => BillToImage(bill: even!.bill!));
                        }
                      },
                      icon: const Icon(MaterialIcons.print, size: 20),
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
                        if (_selectedCustomer != null && neweventcontroller.totalPriceOfCart > 0 && _pr != null && _date != null) {
                          int intdisc = int.tryParse(_disController.text) ?? 0;
                          int total = neweventcontroller.totalPriceOfCart;
                          int finalprice = total - intdisc;
                          int payment = int.tryParse(_payController.text) ?? 0;
                          customerprovider.addEvent(
                            customer: _selectedCustomer!,
                            eventname: _eventnameController.text,
                            date: _date!,
                            description: _eventdesController.text,
                            selectedProducts: neweventcontroller.selectedProducts,
                            total: total,
                            discount: intdisc,
                            finalprice: finalprice,
                            payment: payment,
                            paymentmode: _dropdowninitvalue,
                            pr: _pr!,
                            time: _time!,
                          );            String number = _selectedCustomer!.number!;
                          String customer = _selectedCustomer!.name!;
                          customerprovider.resetEvents();
                          _eventdesController.clear();
                          _disController.clear();
                          _productController.clear();
                          _customerController.clear();
                          _qtyController.clear();
                          _eventnameController.clear();
                          _payController.clear();
                          neweventcontroller.reset();
                          _selectedDate = '';
                          _selectedTime = '';
                          _selectedCustomer = null;
                              String message = "Dear $customer,\nThank You so much for visiting ${user.userBussinessName}.\nWe are happy to have you.";
                          WhatsappFunction().createMessage(number: number, message: message);
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
                // Padding(
                //   padding: const EdgeInsets.all(5),
                //   child: SizedBox(
                //     height: 30,
                //     child: OutlinedButton.icon(
                //         onPressed: () async {
                //           if (_selectedCustomer != null && neweventcontroller.totalPriceOfCart > 0 && _pr != null && _date != null) {
                //             int intdisc = int.tryParse(_disController.text) ?? 0;
                //             int total = neweventcontroller.totalPriceOfCart;
                //             int finalprice = total - intdisc;
                //             int payment = int.tryParse(_payController.text) ?? 0;
                //             customerprovider.addEvent(
                //               customer: _selectedCustomer!,
                //               eventname: _eventnameController.text,
                //               date: _date!,
                //               description: _eventdesController.text,
                //               selectedProducts: neweventcontroller.selectedProducts,
                //               total: total,
                //               discount: intdisc,
                //               finalprice: finalprice,
                //               payment: payment,
                //               paymentmode: _dropdowninitvalue,
                //               pr: _pr!,
                //               time: _time!,
                //             );
                //             var msg =
                //                 'Dear ${_selectedCustomer!.name},\nThank You so much for visiting ${user.userBussinessName}.\nWe are happy to have you.';
                //             var number = _selectedCustomer!.number;
                //             customerprovider.resetEvents();
                //             _eventdesController.clear();
                //             _disController.clear();
                //             _productController.clear();
                //             _customerController.clear();
                //             _qtyController.clear();
                //             _eventnameController.clear();
                //             _payController.clear();
                //             neweventcontroller.reset();
                //             _selectedDate = '';
                //             _selectedTime = '';
                //             _selectedCustomer = null;
                //           } else {
                //             final bar = SnackBar(
                //               behavior: SnackBarBehavior.floating,
                //               width: MediaQuery.of(context).size.height - 40,
                //               backgroundColor: style.errorColor,
                //               duration: const Duration(seconds: 5),
                //               content: Text(
                //                 'Something went wrong. Kindly fill all information correctly',
                //                 style: TextStyle(
                //                   color: Colors.white,
                //                   fontSize: style.textTheme.bodyLarge!.fontSize ?? 14,
                //                   fontWeight: style.textTheme.bodyLarge!.fontWeight,
                //                 ),
                //               ),
                //               action: SnackBarAction(label: 'Ok', textColor: Colors.white, onPressed: () {}),
                //             );
                //             ScaffoldMessenger.of(context).showSnackBar(bar);
                //           }
                //         },
                //         icon: const Icon(
                //           FontAwesome.send,
                //           size: 13,
                //         ),
                //         label: const Text('Notify')),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
