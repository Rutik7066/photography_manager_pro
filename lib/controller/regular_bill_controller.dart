import 'package:flutter/material.dart';

import 'package:jk_photography_manager/model/m_product.dart';

class RegularBillController extends ChangeNotifier {
  List<Map<String, dynamic>> _selectedProducts = [];
  int _totalPriceOfCart = 0;

  List<Map<String, dynamic>> get selectedProducts => _selectedProducts;
  int get totalPriceOfCart => _totalPriceOfCart;

  MProduct? _selectedProduct;
  MProduct? get selectedProduct => _selectedProduct;

  set selectedProduct(MProduct? product) {
    _selectedProduct = product;
  }

  addToCart({required String productname, required int productPrice, required int qty, required int totalprice}) {
    _selectedProducts.add({'product': productname, 'price': productPrice, 'qty': qty, 'totalprice': totalprice});
    calculatetotal();
    notifyListeners();
  }

  void removeFromCart(index) {
    _selectedProducts.removeAt(index);
    calculatetotal();
    notifyListeners();
  }

  calculatetotal() {
    int i = 0;
    for (var element in _selectedProducts) {
      int price = element['totalprice'];
      i = i + price;
    }
    _totalPriceOfCart = i;
  }

  clear() {
    _selectedProducts = [];
    _selectedProduct = null;
    _totalPriceOfCart = 0;
    notifyListeners();
  }
}
