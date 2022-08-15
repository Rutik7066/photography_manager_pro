import 'package:flutter/material.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/model/m_event.dart';
import 'package:jk_photography_manager/repo/customer_repo.dart';

import '../model/m_bill.dart';

class CustomerProvider extends ChangeNotifier {
  List<MCustomer> _listofCustomers = CustomerRepo().getallCustomers();

  final _customerRepo = CustomerRepo();

  get listofCustomers => _listofCustomers;

  // To Update Ui after operations.
  resetCutomerList() {
    _listofCustomers = _customerRepo.getallCustomers();
  }

  // To search the customer by name.
  searchCustomer(String name) {
    if (name.isNotEmpty) {
      _listofCustomers = _customerRepo.getCustomer(name);
      notifyListeners();
    } else if (name.isEmpty) {
      resetCutomerList();
      notifyListeners();
    }
  }

  // For autocomplete
  List<MCustomer> getCustomer(String name) {
    return _listofCustomers.where((element) => element.name!.toLowerCase().startsWith(name.toLowerCase())).toList();
  }

  // To add customer.
  void addCustomer({String? name, String? number, String? whatsappName, String? address}) {
    _customerRepo.addCustomer(name: name, number: number, whatsappName: whatsappName, address: address);
    resetCutomerList();
    notifyListeners();
  }

  // To  get single customer.
  MCustomer getSingleCustomer(var key) {
    return _customerRepo.getSingleCustomer(key);
  }

  // To add bill to customer
  MBill? addBill(MCustomer customer, List<Map<String, dynamic>> selectedProducts, int total, int discount, int finalprice, int payment, String paymentmode) {
    MBill? bill = _customerRepo.addBill(customer, selectedProducts, total, discount, finalprice, payment, paymentmode);
    resetBills();
    notifyListeners();
    return bill;
  }

  ////////////////////////////////////////////////////////////////////////////
  Future addCustomerandBill(
      {required String customerName,
      required String customerNumber,
      required List<Map<String, dynamic>> selectedProducts,
      required int total,
      required int discount,
      required int finalprice,
      required int payment,
      required String paymentmode}) async {
    MBill? bill = await _customerRepo.addCustomerandBill(
        customerName: customerName,
        customerNumber: customerNumber,
        selectedProducts: selectedProducts,
        total: total,
        discount: discount,
        finalprice: finalprice,
        payment: payment,
        paymentmode: paymentmode);
    resetBills();
    resetCutomerList();
    notifyListeners();
    return bill;
  }

  resetBills() {
    _allBills = _customerRepo.getallBills().reversed.toList();
    notifyListeners();
  }

  // To add event to customer
  MEvent? addEvent(
      {required MCustomer customer,
      required String eventname,
      required DateTime date,
      required TimeOfDay time,
      required DayPeriod pr,
      required String description,
      required List<Map<String, dynamic>> selectedProducts,
      required int total,
      required int discount,
      required int finalprice,
      required int payment,
      required String paymentmode}) {
    MEvent? ev = _customerRepo.addEvent(
        customer: customer,
        eventname: eventname,
        date: date,
        time: time,
        pr: pr,
        description: description,
        selectedProducts: selectedProducts,
        total: total,
        discount: discount,
        finalprice: finalprice,
        payment: payment,
        paymentmode: paymentmode);
    _customerRepo.verifiyCustomerValue(customer);
    resetEvents();
    notifyListeners();
    return ev;
  }

  List<MEvent> _allevents = CustomerRepo().getAllEvents();
  List<MEvent> get allevents => _allevents;

  searchEvents(DateTime date) {
    _allevents = _customerRepo.searchEvent(date);
    notifyListeners();
  }

  upCommingEvents() {
    _allevents = _customerRepo.upcommingEvents();
    notifyListeners();
  }

  oldEvents() {
    _allevents = _customerRepo.oldEvents();
    notifyListeners();
  }

  resetEvents() {
    _allevents = _customerRepo.getAllEvents();
  }

  updateEventStatus({required MEvent event, required int statuscode}) {
    _customerRepo.updateEventStatus(event: event, statuscode: statuscode);
    notifyListeners();
  }

  List<MBill> _allBills = CustomerRepo().getallBills().reversed.toList();

  List<MBill> get allbill => _allBills;

  getAllBills() {
    _allBills = _customerRepo.getallBills();
    notifyListeners();
  }

  getPendingBills() {
    _allBills = _customerRepo.getpendingbill();
    notifyListeners();
  }

  getCompletedBills() {
    _allBills = _customerRepo.getcompltedbill();
    notifyListeners();
  }

  getDeliveredBills() {
    _allBills = _customerRepo.getdeliveredbill();
    notifyListeners();
  }

  updateBillStatus({required MBill bill, required int statuscode}) {
    _customerRepo.updateBillStatus(bill: bill, statuscode: statuscode);
    notifyListeners();
  }

  searchBill(int index) {
    _allBills = _customerRepo.getBillByIndex(index);
    notifyListeners();
  }

  int? _customerPendingWork;
  int? _customerCompletedWork;
  int? _customerDeliveredWork;

  int? get customerPendingWork => _customerPendingWork;
  int? get customerCompletedWork => _customerCompletedWork;
  int? get customerDeliveredWork => _customerDeliveredWork;

  getValue(MCustomer customer) {
    _customerCompletedWork = _customerRepo.customerCompletedWork(customer);
    _customerDeliveredWork = _customerRepo.customerDeliveredWork(customer);
    _customerPendingWork = _customerRepo.customerPendingWork(customer);
  }

  custmerValueInit(MCustomer customer) {
    _customerCompletedWork = _customerRepo.customerCompletedWork(customer);
    _customerDeliveredWork = _customerRepo.customerDeliveredWork(customer);
    _customerPendingWork = _customerRepo.customerPendingWork(customer);
    notifyListeners();
  }

  MCustomer getCustomerByBill(MBill bill) {
    return _customerRepo.getCustomerByBill(bill);
  }

  MCustomer getCustomerByEvent(MEvent event) {
    return _customerRepo.getCustomerByEvent(event);
  }

  addBillPayment({required MCustomer customer, required MBill bill, required int payment, required String paymentmode}) {
    _customerRepo.addPaymentBill(customer: customer, bill: bill, payment: payment, paymentmode: paymentmode);
    notifyListeners();
  }

  addPaymentToCustomer({required MCustomer customer, required int payment, required String paymentmode}) {
    _customerRepo.addPaymentToCustomer(customer: customer, payment: payment, paymentmode: paymentmode);
    notifyListeners();
  }

  verifiyCustomerValue(MCustomer customer) {
    _customerRepo.verifiyCustomerValue(customer);
  }
}
