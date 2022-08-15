import 'package:hive_flutter/hive_flutter.dart';
import 'package:jk_photography_manager/model/m_product.dart';

class ProductRepo {
  final Box _pro = Hive.box<MProduct>('ProductBox');

  addproduct({required String productName, required List<String> description, required int price}) {
    if (description.isEmpty) {
      _pro.add(MProduct(productname: productName, price: price));
    } else if (description.isNotEmpty) {
      _pro.add(MProduct(productname: productName, description: description.toList(), price: price));
    }
    _pro.values.forEach((element) {
        print(element.description);
    });
  }

  List<MProduct> getAllProduct() {
    return _pro.values.cast<MProduct>().toList().reversed.toList();
  }
}
