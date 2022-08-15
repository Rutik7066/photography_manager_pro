import 'package:flutter/material.dart';
import 'package:jk_photography_manager/model/m_product.dart';
import 'package:jk_photography_manager/repo/product_repo.dart';

class ProductProvider extends ChangeNotifier {
  final _productRepo = ProductRepo();

  List<MProduct> allProduct = ProductRepo().getAllProduct();

  addProduct({required String productName, required List<String> description, required int price}) {
    _productRepo.addproduct(productName: productName, price: price, description: description);
    resetAllProduct();
    notifyListeners();
  }

  resetAllProduct() {
    allProduct = _productRepo.getAllProduct();
    notifyListeners();
  }

  List<MProduct> getProductForRegularBill(String pattern) {
    return _productRepo.getAllProduct().where((pro) => pro.description == null && pro.productname!.toLowerCase().startsWith(pattern)).toList();
  }

  List<MProduct> getProductForEvent(String pattern) {
    return _productRepo.getAllProduct().where((pro) => pro.productname!.toLowerCase().startsWith(pattern)).cast<MProduct>().toList();
  }
}
