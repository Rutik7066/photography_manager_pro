import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jk_photography_manager/layout/navigation.dart';
import 'package:provider/provider.dart';

import '../provider/customer_provider.dart';
import 'my_textfield.dart';

class NewCustomer extends StatefulWidget {
  const NewCustomer({Key? key}) : super(key: key);

  @override
  State<NewCustomer> createState() => _NewCustomerState();
}

class _NewCustomerState extends State<NewCustomer> {
    TextEditingController _nameController = TextEditingController();

  TextEditingController _numberController = TextEditingController();

  TextEditingController _whatsappnameController = TextEditingController();

  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var navigation = Provider.of<Navigation>(context);
    var customerprovider = Provider.of<CustomerProvider>(context);
    var style = Theme.of(context);
    return AlertDialog(
      content: 
          Container(
                  width: 400,
                  height: 450,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        prefix: const Icon(MaterialIcons.person),
                        controller: _nameController,
                        hintText: 'Cutomer Name',
                      ),
                      MyTextField(
                        prefix: const Icon(MaterialIcons.phone),
                        controller: _numberController,
                        hintText: 'Cutomer Number',
                      ),
                      MyTextField(
                        prefix: const Icon(MaterialCommunityIcons.whatsapp),
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

                              prefixIcon: const Icon(MaterialIcons.location_on),
                              alignLabelWithHint: false),
                        ),
                      ),
                     
                    ],
                  ),
                ),
                actions: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: SizedBox(
                          height: 30,
                          child: OutlinedButton.icon(
                            icon: const Icon(MaterialIcons.person_add_alt_1),
                            onPressed: () {
                              if (_nameController.text.isNotEmpty) {
                                customerprovider.addCustomer(
                                  name: _nameController.text,
                                  number: _numberController.text,
                                  whatsappName: _whatsappnameController.text,
                                  address: _addressController.text,
                                );
                              }
                              Navigator.pop(context);
                            },
                            label: Text(
                              'Customer',
                            ),
                          ),
                        ),
                   ),
                               Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                            ),
                          ),
                        ),
                   ),
                   
                      
                ],
    );
  }
}
