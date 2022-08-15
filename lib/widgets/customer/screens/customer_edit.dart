// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/common_widgets/my_icon_button.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';
import 'package:jk_photography_manager/widgets/customer/screens/customer_info.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/my_textfield.dart';
import '../../../layout/navigation.dart';
import '../../../model/m_customer.dart';

class CustomerEdit extends StatefulWidget {
  MCustomer customer;
  CustomerEdit({required this.customer, Key? key}) : super(key: key);

  @override
  State<CustomerEdit> createState() => _CustomerEditState();
}

class _CustomerEditState extends State<CustomerEdit> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _numberController = TextEditingController();

  TextEditingController _whatsappnameController = TextEditingController();

  TextEditingController _addressController = TextEditingController();

  intiValue() {}

  @override
  void initState() {
    MCustomer customer = widget.customer;
    _nameController.text = customer.name!;
    _whatsappnameController.text = customer.nickname!;
    _numberController.text = customer.number!;
    _addressController.text = customer.address!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    intiValue();
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
                  onPressed: () => navigation.routeAdd(CustomerInfo(widget.customer)),
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
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Customer Details',
                              style: style.textTheme.headline5,
                            ),
                          ],
                        ),
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
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              helperStyle: style.textTheme.bodyMedium,
                              filled: true,
                              hintStyle: style.textTheme.bodyMedium,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                              prefixIcon: Icon(MaterialIcons.location_on),
                              alignLabelWithHint: false),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: OutlinedButton.icon(
                          icon: Icon(MaterialIcons.edit),
                          onPressed: () {
                            widget.customer.name = _nameController.text;
                            widget.customer.number = _numberController.text;
                            widget.customer.nickname = _whatsappnameController.text;
                            widget.customer.address = _addressController.text;
                            widget.customer.save();
                            navigation.routeAdd(CustomerInfo(widget.customer));
                          },
                          label: Text(
                            'Save changes',
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
