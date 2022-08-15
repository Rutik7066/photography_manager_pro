import 'package:flutter/material.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/model/m_product.dart';
import 'package:provider/provider.dart';

import '../../provider/product_provider.dart';

class EditProduct extends StatefulWidget {
  MProduct product;
  EditProduct({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    _productController.text = widget.product.productname!;
    _priceController.text = widget.product.price.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var productPro = Provider.of<ProductProvider>(context);
    var style = Theme.of(context);
    return AlertDialog(
      title: const Text('Edit Product'),
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 30,
            child: OutlinedButton(
              onPressed: () {
                widget.product.delete();
                productPro.resetAllProduct();
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ),
        ),
        SizedBox(
          height: 30,
          child: OutlinedButton(
            onPressed: () {
              int? price = int.tryParse(_priceController.text);
              if (_productController.text.isNotEmpty && price != null) {
                widget.product.productname = _productController.text;
                widget.product.price = price;
                widget.product.save();
                productPro.resetAllProduct();
                _productController.clear();
                _priceController.clear();

                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
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
