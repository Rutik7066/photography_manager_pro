// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/common_widgets/my_icon_button.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/my_textfield.dart';
import '../../../layout/navigation.dart';

class CustomerAdd extends StatefulWidget {
  const CustomerAdd({Key? key}) : super(key: key);

  @override
  State<CustomerAdd> createState() => _CustomerAddState();
}

class _CustomerAddState extends State<CustomerAdd> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _numberController = TextEditingController();

  TextEditingController _whatsappnameController = TextEditingController();

  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var navigation = Provider.of<Navigation>(context);
    var customerprovider = Provider.of<CustomerProvider>(context);
    var style = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                MyIconButton(
                  iconData: AntDesign.arrowleft,
                  onPressed: () => navigation.select(4),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 400,
                  height: 450,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Add New Customer',
                              style: style.textTheme.headline5,
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text('Customer Name & Customer Number (Whatsapp number) is important'),
                      ),
                      MyTextField(
                        prefix: Icon(MaterialIcons.person),
                        controller: _nameController,
                        hintText: 'Cutomer Name',
                      ),
                      MyTextField(
                        prefix: Icon(MaterialIcons.phone),
                        controller: _numberController,
                        hintText: 'Cutomer Number',
                      ),
                      MyTextField(
                        prefix: Icon(MaterialCommunityIcons.whatsapp),
                        controller: _whatsappnameController,
                        hintText: 'Whatsapp Name',
                      ),
                      Flexible(
                        child: TextField(
                          style: style.textTheme.bodyMedium,
                          controller: _addressController,
                          maxLines: 4,
                          minLines: 1,
                          decoration: InputDecoration(
                              hintText: 'Address',
                              isDense: true,
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              hintStyle: style.textTheme.bodyMedium,
                                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),

                              prefixIcon: Icon(MaterialIcons.location_on),
                              alignLabelWithHint: false),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: OutlinedButton.icon(
                          icon: Icon(MaterialIcons.person_add_alt_1),
                          onPressed: () {
                            if (_nameController.text.isNotEmpty) {
                              customerprovider.addCustomer(
                                name: _nameController.text,
                                number: _numberController.text,
                                whatsappName: _whatsappnameController.text,
                                address: _addressController.text,
                              );
                            }
                            navigation.select(4);
                          },
                          label: Text(
                            'Add Customer',
                            style: style.textTheme.bodyMedium,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.clear();
    _numberController.clear();
    _whatsappnameController.clear();
    _addressController.clear();
    super.dispose();
  }
}
