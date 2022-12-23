import 'package:flutter/material.dart';
import 'package:jk_photography_manager/model/m_bill.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/model/m_product.dart';
import 'package:jk_photography_manager/provider/customer_provider.dart';
import 'package:jk_photography_manager/repo/business_repo.dart';
import 'package:jk_photography_manager/repo/customer_repo.dart';

import '../provider/business_provider.dart';

class QuickBill extends ChangeNotifier {
  MCustomer? _selectedCustomer;
  String? _selectedCustomerName;
  String? _selectedCustomerNumber;
  MProduct? _selctedProduct;
  int _qty = 0;
  int _total = 0;
  int _discount = 0;
  int _paid = 0;
  String _paymentmode = 'Cash';
  int _finalP = 0;
  int get finalP => _finalP;
  int get total => _total;

  String? get selectedCustomerName => _selectedCustomerName;
  String? get selectedCustomerNumber => _selectedCustomerNumber;
  set selectedCustomerName(String? v) {
    _selectedCustomerName = v;
    notifyListeners();
  }

  set selectedCustomerNumber(String? v) {
    _selectedCustomerNumber = v;
    notifyListeners();
  }

  int get discount => _discount;
  set discount(int value) {
    _discount = value;
    _finalP = _total - value;
    notifyListeners();
  }

  int get paid => _paid;
  set paid(value) {
    _paid = value ?? 0;
    notifyListeners();
  }

  get paymentmode => _paymentmode;
  set paymentmode(value) {
    _paymentmode = value;
    notifyListeners();
  }

  MCustomer? get selectedCustomer => _selectedCustomer;
  set selectedCustomer(MCustomer? value) {
    _selectedCustomer = value;
    notifyListeners();
  }

  MProduct? get selctedProduct => _selctedProduct;
  set selctedProduct(MProduct? value) {
    _selctedProduct = value;
    notifyListeners();
  }

  get qty => _qty;
  set qty(value) {
    _qty = value;
    _total = _selctedProduct!.price! * value as int;
    _finalP = _total;
    notifyListeners();
  }

  Future<MBill?> addbill() async {
    if (_selectedCustomer != null && _selctedProduct != null && finalP > 0 && paid >= 0) {
      MBill? bill = CustomerProvider().addBill(
          _selectedCustomer!,
          [
            {
              'product': _selctedProduct!.productname!,
              'price': _selctedProduct!.price!,
              'qty': qty,
              'totalprice': total,
            }
          ],
          total,
          discount,
          finalP,
          paid,
          paymentmode);
      CustomerProvider().resetCutomerList();
      notifyListeners();
      return bill;
    } else if (_selectedCustomer == null && _selectedCustomerName!.isNotEmpty && _selctedProduct != null && finalP > 0 && paid >= 0) {
      MBill? bil = await CustomerProvider().addCustomerandBill(
          customerName: _selectedCustomerName!,
          customerNumber: _selectedCustomerNumber!.isEmpty ? '0000000000' : _selectedCustomerNumber!,
          selectedProducts: [
            {
              'product': _selctedProduct!.productname!,
              'price': _selctedProduct!.price!,
              'qty': qty,
              'totalprice': total,
            }
          ],
          total: total,
          discount: discount,
          finalprice: finalP,
          payment: paid,
          paymentmode: paymentmode);
      CustomerProvider().resetCutomerList();
      notifyListeners();
      return bil;
    } else if (_selectedCustomer == null && _selectedCustomerName!.isEmpty && _selctedProduct != null && finalP > 0 && paid >= 0) {
      List events = CustomerRepo().getAllEvents();
      List bills = CustomerRepo().getallBills();
      int billnumber = events.length + bills.length;
      MBill value = MBill(
          created: DateTime.now(),
          billindex: billnumber,
          type: 'regular',
          description: '',
          cart: [
            {
              'product': _selctedProduct!.productname!,
              'price': _selctedProduct!.price!,
              'qty': qty,
              'totalprice': total,
            }
          ],
          total: total,
          discount: discount,
          finalTotal: finalP,
          paymentOrAdvance: paid,
          unPaid: finalP - paid,
          paymentHistoryOfBill: [
            {'date': DateTime.now(), 'payment': paid, 'mode': paymentmode}
          ],
          status: 2,
          customername: '');

      BusinessProvider().addRow(category: 'Income', type: value, typename: 'Entry', context: _selctedProduct!.productname!, transaction: value.paymentOrAdvance!, paymentmode: paymentmode);
      

      notifyListeners();
      return value;
    } else {
      notifyListeners();
      return null;
    }
  }

  clear() {
    _selectedCustomer = null;
    _selctedProduct = null;
    _qty = 1;
    _total = 0;
    _discount = 0;
    _paymentmode = 'Cash';
    _finalP = 0;
    notifyListeners();
  }
}
