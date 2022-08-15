import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jk_photography_manager/model/m_customer.dart';
import 'package:jk_photography_manager/model/m_event.dart';
import 'package:jk_photography_manager/model/m_product.dart';
import 'package:jk_photography_manager/page/customer.dart';
import 'package:jk_photography_manager/repo/business_repo.dart';

import '../model/m_bill.dart';

class CustomerRepo {
  static final Box _customerBox = Hive.box<MCustomer>('CustomerBox');

  // To initialize customer in the variable.
  List<MCustomer> getallCustomers() {
    return _customerBox.values.cast<MCustomer>().toList();
  }

  // To search customer by name.
  List<MCustomer> getCustomer(String name) {
    return _customerBox.values
        .toList()
        .where((element) {
          element as MCustomer;
          return element.name!.toLowerCase().startsWith(name.toLowerCase());
        })
        .cast<MCustomer>()
        .toList();
  }

  // To add customer.
  void addCustomer({String? name, String? number, String? whatsappName, String? address}) {
    MCustomer newCustomer =
        MCustomer(name: name, number: number, nickname: whatsappName ?? name, address: address, events: [], bills: [], totalRecoveryAmount: 0, totalPendingWork: 0, paymentHistory: []);
    _customerBox.add(newCustomer);
  }

  // To get  single customer by Key/Id.
  MCustomer getSingleCustomer(var key) {
    return _customerBox.get(key);
  }

  //TO add bill to the customer.
  MBill? addBill(
    MCustomer customer,
    List<Map<String, dynamic>> selectedProducts,
    int total,
    int discount,
    int finalprice,
    int payment,
    String paymentmode,
  ) {
    List events = getAllEvents();
    List bills = getallBills();
    int billnumber = events.length + bills.length;

    MBill value = MBill(
        created: DateTime.now(),
        billindex: billnumber,
        type: 'Regular',
        description: '',
        cart: selectedProducts,
        total: total,
        discount: discount,
        finalTotal: finalprice,
        paymentOrAdvance: payment,
        unPaid: finalprice - payment,
        paymentHistoryOfBill: [
          {'date': DateTime.now(), 'payment': payment, 'mode': paymentmode}
        ],
        status: selectedProducts.length == 1 ? 2 : 0,
        customername: customer.name);

    customer.bills?.insert(customer.bills!.length, value);
    customer.totalRecoveryAmount = customer.totalRecoveryAmount! + finalprice - payment;
    customer.paymentHistory = [
      {'date': DateTime.now(), 'mode': paymentmode}
    ];
    customer.save();

    verifiyCustomerValue(customer);

    BusinessRepo()
        .addRow(category: 'Income', type: value, typename: value.cart!.length == 1 ? 'Quick Bill' : 'Bill', context: customer.name!, transaction: value.paymentOrAdvance!, paymentmode: paymentmode);

    return value;
  }

  Future addCustomerandBill(
      {required String customerName,
      required String customerNumber,
      required List<Map<String, dynamic>> selectedProducts,
      required int total,
      required int discount,
      required int finalprice,
      required int payment,
      required String paymentmode}) async {
    List events = getAllEvents();
    List bills = getallBills();
    int billnumber = events.length + bills.length;
    MCustomer cust =
        MCustomer(
          name: customerName, number: customerNumber, nickname: customerName, address: 'Not Provided', events: [], bills: [], totalRecoveryAmount: 0, totalPendingWork: 0, paymentHistory: []);
    int key = await _customerBox.add(cust);
    MCustomer customer = getSingleCustomer(key);
    MBill value = MBill(
        created: DateTime.now(),
        billindex: billnumber,
        type: 'Regular',
        description: '',
        cart: selectedProducts,
        total: total,
        discount: discount,
        finalTotal: finalprice,
        paymentOrAdvance: payment,
        unPaid: finalprice - payment,
        paymentHistoryOfBill: [
          {'date': DateTime.now(), 'payment': payment, 'mode': paymentmode}
        ],
        status: selectedProducts.length == 1 ? 2 : 0,
        customername: customer.name);

    customer.bills?.insert(customer.bills!.length, value);
    customer.totalRecoveryAmount = customer.totalRecoveryAmount! + finalprice - payment;
    customer.paymentHistory = [
      {'date': DateTime.now(), 'mode': paymentmode}
    ];
    customer.save();

    verifiyCustomerValue(customer);

    BusinessRepo()
        .addRow(category: 'Income', type: value, typename: value.cart!.length == 1 ? 'Quick Bill' : 'Bill', context: customer.name!, transaction: value.paymentOrAdvance!, paymentmode: paymentmode);

    return value;
  }

  //To add event to the customer.
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
    List events = getAllEvents();
    List bills = getallBills();
    int billnumber = events.length + bills.length;

    MBill value = MBill(
        customername: customer.name,
        created: DateTime.now(),
        billindex: billnumber,
        type: 'Event',
        description: '',
        cart: selectedProducts.toList(),
        total: total,
        discount: discount,
        finalTotal: finalprice,
        paymentOrAdvance: payment,
        unPaid: finalprice - payment,
        paymentHistoryOfBill: [
          {'date': DateTime.now(), 'mode': paymentmode}
        ],
        status: 0);
    String t = '${time.hourOfPeriod}:${time.minute} ${pr == DayPeriod.am ? 'AM' : 'PM'}';

    MEvent event = MEvent(time: t, name: eventname, date: date, description: description, bill: value, customername: customer.name);
    customer.events!.add(event);
    customer.totalRecoveryAmount = customer.totalRecoveryAmount! + finalprice - payment;
    customer.paymentHistory = [
      {'date': DateTime.now(), 'payment': payment, 'mode': paymentmode}
    ];
    customer.save();
    for (var element in customer.events!) {
      print(element.bill!.cart);
    }
    selectedProducts.clear();
    verifiyCustomerValue(customer);
    BusinessRepo().addRow(category: 'Income', type: event, typename: 'Event', context: customer.name!, transaction: value.paymentOrAdvance!, paymentmode: paymentmode);
    return event;
  }

  List<MEvent> getAllEvents() {
    List<MCustomer> customers = getallCustomers();
    List<MEvent> events = [];
    for (var element in customers) {
      Iterable<MEvent> allev = element.events as Iterable<MEvent>;
      events.addAll(allev);
    }
    return events;
  }

  List<MEvent> searchEvent(DateTime date) {
    List<MEvent> events = getAllEvents();
    return events.where((element) => element.date!.isAtSameMomentAs(date)).cast<MEvent>().toList();
  }

  List<MEvent> upcommingEvents() {
    List<MEvent> events = getAllEvents();
    return events.where((element) => element.date!.isAfter(DateTime.now())).cast<MEvent>().toList();
  }

  List<MEvent> oldEvents() {
    List<MEvent> events = getAllEvents();
    return events.where((element) => element.date!.isBefore(DateTime.now())).cast<MEvent>().toList();
  }

  updateEventStatus({required MEvent event, required int statuscode}) {
    List<MCustomer> allCustomer = getallCustomers();
    for (var c in allCustomer) {
      List<MEvent> events = c.events!.where((ev) => ev == event && ev.bill == event.bill).toList();
      if (events.length == 1) {
        events.first.bill!.status = statuscode;
        c.save();
      }
    }
  }

  List<MBill> getallBills() {
    List<MBill> allbill = [];
    List<MCustomer> allCustomer = getallCustomers();
    for (var element in allCustomer) {
      Iterable<MBill> bills = element.bills as Iterable<MBill>;
      allbill.addAll(bills);
    }
    return allbill;
  }

  List<MBill> getpendingbill() {
    List<MBill> bills = getallBills();
    return bills.where((element) => element.status == 0).toList();
  }

  List<MBill> getcompltedbill() {
    List<MBill> bills = getallBills();
    return bills.where((element) => element.status == 1).toList();
  }

  List<MBill> getdeliveredbill() {
    List<MBill> bills = getallBills();
    return bills.where((element) => element.status == 2).toList();
  }

  updateBillStatus({required MBill bill, required int statuscode}) {
    List<MCustomer> allCustomer = getallCustomers();
    for (var c in allCustomer) {
      List<MBill> bills = c.bills!.where((ev) => ev == bill).toList();
      if (bills.length == 1) {
        bills.first.status = statuscode;
        c.save();
      }
    }
  }

  getBillByIndex(int index) {
    List<MBill> allbills = getallBills();
    return allbills.where((e) => e.billindex.toString().startsWith(index.toString())).toList();
  }

  int customerPendingWork(MCustomer customer) {
    int bill = customer.bills!.where((bill) => bill.status == 0).toList().length;
    int event = customer.events!.where((ev) => ev.bill!.status == 0).toList().length;
    return bill + event;
  }

  int customerCompletedWork(MCustomer customer) {
    int bill = customer.bills!.where((bill) => bill.status == 1).toList().length;
    int event = customer.events!.where((ev) => ev.bill!.status == 1).toList().length;
    return bill + event;
  }

  int customerDeliveredWork(MCustomer customer) {
    int bill = customer.bills!.where((bill) => bill.status == 2).toList().length;
    int event = customer.events!.where((ev) => ev.bill!.status == 2).toList().length;
    return bill + event;
  }

  MCustomer getCustomerByBill(MBill bill) {
    List<MCustomer> customers = getallCustomers();
    return customers.where((c) => c.bills!.any((b) => b == bill)).toList().first;
  }

  MCustomer getCustomerByEvent(MEvent event) {
    List<MCustomer> customers = getallCustomers();
    return customers.where((c) => c.events!.any((e) => e == event && e.bill == event.bill)).toList().first;
  }

  void addPaymentBill({required MCustomer customer, required MBill bill, required int payment, required String paymentmode}) {
    bill.paymentOrAdvance = bill.paymentOrAdvance! + payment;
    bill.paymentHistoryOfBill!.add({'date': DateTime.now(), 'payment': payment, 'mode': paymentmode});
    bill.unPaid = bill.unPaid! - payment;
    customer.totalRecoveryAmount = customer.totalRecoveryAmount! - payment;
    customer.save();
    verifiyCustomerValue(customer);
  }

  addPaymentToCustomer({required MCustomer customer, required int payment, required String paymentmode}) {
    List<MBill> bills = customer.bills!.where((bill) => bill.unPaid! > 0).toList();
    for (var event in customer.events!) {
      if (event.bill!.unPaid! > 0) {
        bills.add(event.bill!);
      }
    }
    int p = payment;
    int i = 0;
    while (p > 0 && p <= customer.totalRecoveryAmount!) {
      MBill b = bills[i];
      if (p >= b.unPaid!) {
        p = p - b.unPaid!;
        b.unPaid = 0;
        b.paymentOrAdvance = b.paymentOrAdvance! + b.unPaid!;
      } else if (payment < b.unPaid!) {
        p = 0;
        b.unPaid = b.unPaid! - payment;
        b.paymentOrAdvance = b.paymentOrAdvance! + payment;
      }
      i++;
    }
    customer.totalRecoveryAmount = customer.totalRecoveryAmount! - payment;
    customer.paymentHistory!.add({'date': DateTime.now(), 'payment': payment, 'mode': paymentmode});
    customer.save();
    verifiyCustomerValue(customer);
  }

  verifiyCustomerValue(MCustomer customer) {
    int pending = 0;
    for (var bill in customer.bills!) {
      pending = pending + bill.unPaid!;
    }

    for (var event in customer.events!) {
      pending = pending + event.bill!.unPaid!;
    }
    customer.totalRecoveryAmount = pending;
    customer.save();
  }
}
