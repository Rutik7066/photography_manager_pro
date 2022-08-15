import 'package:flutter/material.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/provider/product_provider.dart';
import 'package:provider/provider.dart';

class AddPackage extends StatefulWidget {
  AddPackage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddPackage> createState() => _AddPackageState();
}

class _AddPackageState extends State<AddPackage> {
  final TextEditingController _productController = TextEditingController();

  final TextEditingController _desController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  List<String> description = [];
 

  @override
  Widget build(BuildContext context) {
    var productPro = Provider.of<ProductProvider>(context);
    var style = Theme.of(context);
    return AlertDialog(
      title: const Text('Add Package'),
      content: SizedBox(
        height: 500,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 30,
                child: MyTextField(
                  hintText: 'Product Name',
                  controller: _productController,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 30,
                child: MyTextField(
                  hintText: 'Product Price',
                  controller: _priceController,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 30,
                child: MyTextField(
                  hintText: 'Description',
                  controller: _desController,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_desController.text != '') {
                    setState(() {
                      description.add(_desController.text);
                    });
                    _desController.clear();
                  }
                },
                child: const Text('Add'),
              ),
            ),
            Container(height: 1, color: Colors.black),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  itemCount: description.length,
                  itemBuilder: (context, index) {
                    String d = description[index];
                    return Dismissible(
                      key: Key(UniqueKey().toString()),
                      onDismissed: (d) {
                        setState(() {
                          description.removeAt(index);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Text(d),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ),
              ),
            ),
            Container(height: 1, color: Colors.black),
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
                int? price = int.tryParse(_priceController.text);
                if (_productController.text.isNotEmpty && price != null && description.isNotEmpty) {
                  productPro.addProduct(
                    description: description,
                    productName: _productController.text,
                    price: price,
                  );

                  Navigator.pop(context);
                }
              },
              child: const Text('Add Package'),
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
              child: const Text('Cancel'),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {

    _priceController.clear();
    _productController.clear();
    _desController.clear();
    super.dispose();
  }
}
