
import 'package:flutter/material.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:provider/provider.dart';

import '../../provider/product_provider.dart';

class AddProduct extends StatelessWidget {
  AddProduct({
    Key? key,
  }) : super(key: key);

  final TextEditingController _productController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var productPro = Provider.of<ProductProvider>(context);
    var style = Theme.of(context);
    return AlertDialog(
      title: const Text('Add Product'),
      content: SizedBox(
        height: 100,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 30,
                child: MyTextField(hintText: 'Product Name', controller: _productController),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 30,
                child: MyTextField(hintText: 'Product Price', controller: _priceController),
              ),
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          height: 30,
          child: OutlinedButton(
            onPressed: () {
              int? price = int.tryParse(_priceController.text);
              if (_productController.text.isNotEmpty && price != null) {
                print('pro');
                productPro.addProduct(
                  productName: _productController.text,
                  price: price,
                  description: []
                );
                _productController.clear();
                _priceController.clear();

                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ),
        SizedBox(
          height: 30,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        )
      ],
    );
  }
}
