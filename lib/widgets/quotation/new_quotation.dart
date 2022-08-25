import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/model/m_quotation.dart';
import 'package:jk_photography_manager/page/whatsapp.dart';
import 'package:jk_photography_manager/repo/quotation_repo.dart';
import 'package:provider/provider.dart';

import '../../auth/auth.dart';
import '../../auth/m_user.dart';
import '../../common_widgets/widget_to_image/quotation_to_image.dart';
import '../../model/m_product.dart';
import '../../provider/product_provider.dart';
import '../../whatsapp_services/whatsapp_function.dart';

class NewQuotation extends StatefulWidget {
  const NewQuotation({Key? key}) : super(key: key);

  @override
  State<NewQuotation> createState() => _NewQuotationState();
}

class _NewQuotationState extends State<NewQuotation> {
  late double w;
  List cart = [];
  TextEditingController _productController = TextEditingController();
  TextEditingController _customerController = TextEditingController();
  TextEditingController _numberC = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  TextEditingController _disController = TextEditingController();
  MProduct? selectedProduct;
  int? total;

  @override
  Widget build(BuildContext context) {
    var productPro = Provider.of<ProductProvider>(context);
    var style = Theme.of(context);
    var auth = Provider.of<Auth>(context);
    MUser user = auth.giveMetheUser();
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    height: 30,
                    child: MyTextField(controller: _customerController, hintText: 'Customer Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 190,
                    height: 30,
                    child: MyTextField(controller: _numberC, hintText: 'Customer Whatsapp Number'),
                  ),
                ),
              ],
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  height: 30,
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
                      selectedProduct = suggestion;
                      _productController.text = selectedProduct!.productname!;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 90,
                  height: 30,
                  child: MyTextField(controller: _qtyController, hintText: 'Qty'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 90,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_productController.text.isNotEmpty && selectedProduct != null) {
                          int quantity = int.tryParse(_qtyController.text) ?? 1;
                          setState(() {
                            cart.add({
                              'product': selectedProduct!.productname,
                              'Description': selectedProduct!.description ?? [],
                              'price': selectedProduct!.price,
                              'qty': quantity,
                              'totalprice': quantity * selectedProduct!.price!,
                            });
                            total = getTotal();
                            _productController.clear();
                            _qtyController.clear();
                          });
                        }
                      },
                      child: const Text('Add')),
                ),
              ),
            ]),
            const SizedBox(height: 1, child: Divider()),
            SizedBox(
              width: MediaQuery.of(context).size.width,
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
            const SizedBox(height: 1, child: Divider()),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    primary: true,
                    itemCount: cart.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> product = cart[index];
                      List<String> des = product['Description'];
                      return Dismissible(
                        key: Key(UniqueKey().toString()),
                        onDismissed: (d) {
                          setState(() {
                            cart.removeAt(index);
                            total = getTotal();
                          });
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
                                    children: List.generate(
                                      des.length,
                                      (index) => Text(des[index]),
                                      growable: false,
                                    ),
                                  )
                                : null),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                total != null
                    ? Text(
                        'Total : $total',
                        style: style.textTheme.titleMedium,
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    height: 30,
                    child: MyTextField(
                      hintText: 'Discount',
                      controller: _disController,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_customerController.text.isNotEmpty && cart.isNotEmpty && _numberC.text.isNotEmpty) {
                          int discount = int.tryParse(_disController.text) ?? 0;
                          var quotationMap = await QuotationRepo().addQuotation(
                            name: _customerController.text,
                            number: _numberC.text,
                            cart: cart,
                            discount: discount,
                          );
                          MQuotation quotation = MQuotation.fromMap(quotationMap);
                          String message = "Dear ${_customerController.text},\nThank You so much for visiting ${user.userBussinessName}.\nWe are happy to have you.";
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return QuotationToImage(qou: quotation);
                              }).whenComplete(() async => await WhatsappFunction().createMessage(number: _numberC.text, message: message));
                        }
                      },
                      child: const Text('Save & Show'),
                    ),
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }

  int getTotal() {
    int total = 0;
    for (var e in cart) {
      total = total + e['totalprice'] as int;
    }
    return total;
  }
}
