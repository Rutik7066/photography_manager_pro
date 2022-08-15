import 'package:flutter/material.dart';
import 'package:jk_photography_manager/model/daily/m_expense.dart';

class AlertPayment extends StatelessWidget {
  int billindex;
  String customerName;
  int amt;
  String paymentmode;

  AlertPayment({required this.paymentmode, required this.amt, required this.billindex, required this.customerName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    return AlertDialog(
      title: const Text('Payment Detail'),
      content: SizedBox(
        height: 100,
        child: Text(
          'Customer Name : $customerName\nBill No. : $billindex\nAmount : $amt\nPayment Mode: $paymentmode',
          style: style.textTheme.bodyLarge,
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Close',
            style: style.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class AlertUnivarsalPayment extends StatelessWidget {
  String customerName;
  int amt;
  String paymentmode;

  AlertUnivarsalPayment({required this.paymentmode, required this.amt, required this.customerName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    return AlertDialog(
      title: const Text('Payment Detail'),
      content: SizedBox(
        height: 100,
        child: Text(
          'Customer Name : $customerName\nAmount : $amt\nPayment Mode: $paymentmode',
          style: style.textTheme.bodyLarge,
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Close',
            style: style.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class AlertExpense extends StatelessWidget {
  MExpenses exp;

  AlertExpense({required this.exp, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Expense Detail'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Category : ${exp.category}\nAmount : ${exp.amount}',style: Theme.of(context).textTheme.bodyLarge,),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        )
      ],
    );
  }
}
