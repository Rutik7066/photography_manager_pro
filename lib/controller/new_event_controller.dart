import 'package:flutter/material.dart';
import 'package:jk_photography_manager/model/m_product.dart';

class NewEventController extends ChangeNotifier {
  List<Map<String, dynamic>> _selectedProducts = [];

  int _totalPriceOfCart = 0;
//----------------------------------------------------------------------------

  List<Map<String, dynamic>> get selectedProducts => _selectedProducts;

  int get totalPriceOfCart => _totalPriceOfCart;

//----------------------------------------------------------------------------

  set selectedProducts(List<Map<String, dynamic>> list) {
    _selectedProducts = list;
    notifyListeners();
  }

  set totalPriceOfCart(int i) {
    _totalPriceOfCart = i;
    notifyListeners();
  }
//----------------------------------------------------------------------------

  MProduct? _selectedProduct;
  MProduct? get selectedProduct => _selectedProduct;

  set selectedProduct(MProduct? product) {
    _selectedProduct = product;
  }

//----------------------------------------------------------------------------

  final List<MProduct> _packages = [
    MProduct(productname: 'Golden', description: ['1.Item', '2.Item'], price: 38000),
    MProduct(productname: 'Golden2', description: ['1.Item', '2.Item'], price: 40000),
    MProduct(productname: 'Golden3', description: ['1.Item', '2.Item'], price: 50000),
    MProduct(productname: 'PassPort 6', price: 40),
    MProduct(productname: 'PassPort 8', price: 50000),
    MProduct(productname: 'PassPort 8 PassPort 8', price: 50000),
  ];

  List<MProduct> get packages => _packages;

//----------------------------------------------------------------------------

  addToCart({required String productname, required List<String> description, required int productPrice, required int qty, required int totalprice}) {
    _selectedProducts.add({'product': productname, 'Description': description, 'price': productPrice, 'qty': qty, 'totalprice': totalprice});
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

  reset() {
    _totalPriceOfCart = 0;
    _selectedProduct = null;
    _selectedProducts.clear();
    notifyListeners();
  }
}
