import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:jk_photography_manager/model/daily/m_expense.dart';
import 'package:jk_photography_manager/provider/finance_provider.dart';
import 'package:provider/provider.dart';

import '../provider/business_provider.dart';

class Finance extends StatefulWidget {
  const Finance({Key? key}) : super(key: key);

  @override
  State<Finance> createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  String _selectedCategory = '';
  String _dropdowninitvalue = 'Cash';

  final TextEditingController _categoryController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();

  final TextEditingController _newCategoryController = TextEditingController();

  int _chipNum = 0;

  final ScrollController _chipScrollContriller = ScrollController();

  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    var expensePro = Provider.of<FinanceProvider>(context);
    var today = Provider.of<BusinessProvider>(context);

    var style = Theme.of(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [Text('Expenses', style: style.textTheme.headline5)],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  width: 250,
                  height: 30,
                  child: TypeAheadField(
                    hideOnEmpty: true,
                    textFieldConfiguration: TextFieldConfiguration(
                      style: style.textTheme.bodyMedium,
                      controller: _categoryController,
                      decoration: InputDecoration(
                        hintText: 'Category',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        filled: true,
                        hintStyle: style.textTheme.bodyMedium,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                        alignLabelWithHint: false,
                      ),
                    ),
                    suggestionsCallback: (p) {
                      return expensePro.getCategoryByName(p);
                    },
                    itemBuilder: (context, item) {
                      return ListTile(
                        title: Text(item.toString()),
                      );
                    },
                    onSuggestionSelected: (p) {
                      setState(
                        () {
                          _selectedCategory = p.toString();
                          _categoryController.text = _selectedCategory;
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    height: 30,
                    child: MyTextField(
                      hintText: 'Amount',
                      controller: _amountController,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      dropdownPadding: const EdgeInsets.all(0),
                      itemHeight: 40,
                      dropdownOverButton: true,
                      buttonElevation: 5,
                      buttonPadding: const EdgeInsets.all(5),
                      buttonHeight: 30,
                      buttonWidth: 150,
                      buttonDecoration: BoxDecoration(color: style.cardColor, border: Border.all(color: style.dividerColor), borderRadius: BorderRadius.circular(4)),
                      value: _dropdowninitvalue,
                      items: [
                        DropdownMenuItem<String>(
                          value: 'Cash',
                          child: Text(
                            'Cash',
                            style: style.textTheme.bodyMedium,
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Online',
                          child: Text('Online', style: style.textTheme.bodyMedium),
                        ),
                      ],
                      onChanged: (String? value) {
                        setState(
                          () {
                            _dropdowninitvalue = value!;
                          },
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 30,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        if (_categoryController.text.isNotEmpty && _amountController.text.isNotEmpty) {
                          expensePro.addExpense(cat: _categoryController.text, amt: int.tryParse(_amountController.text) ?? 0);
                          today.addRow(
                            category: 'Expense',
                            type: MExpenses(date: DateTime.now(), category: _categoryController.text, amount: int.tryParse(_amountController.text) ?? 0),
                            typename: 'Expense',
                            context: _categoryController.text,
                            transaction: int.tryParse(_amountController.text) ?? 0,
                            paymentmode: _dropdowninitvalue,
                          );
                          _categoryController.clear();
                          _amountController.clear();
                          _dropdowninitvalue = 'Cash';
                        } else {
                          final bar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            width: MediaQuery.of(context).size.height - 40,
                            backgroundColor: style.errorColor,
                            duration: const Duration(seconds: 5),
                            content: Text(
                              'Something went wrong. Kindly fill all information correctly',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: style.textTheme.bodyLarge!.fontSize ?? 14,
                                fontWeight: style.textTheme.bodyLarge!.fontWeight,
                              ),
                            ),
                            action: SnackBarAction(label: 'Ok', textColor: Colors.white, onPressed: () {}),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(bar);
                        }
                      },
                      icon: const Icon(MaterialIcons.add, size: 20),
                      label: const Text(
                        'Add Expense',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 30,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Category'),
                              content: SizedBox(
                                  width: 200,
                                  height: 30,
                                  child: MyTextField(
                                    hintText: 'Add Category',
                                    controller: _newCategoryController,
                                  )),
                              actions: [
                                SizedBox(
                                  height: 30,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      if (_newCategoryController.text.isNotEmpty) {
                                        expensePro.addCategory(_newCategoryController.text);
                                        _newCategoryController.clear();
                                        Navigator.pop(context);
                                      }
                                    },
                                    icon: const Icon(MaterialIcons.add, size: 20),
                                    label: Text(
                                      'Add',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(MaterialIcons.add, size: 20),
                                    label: Text(
                                      'Close',
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(MaterialIcons.add, size: 20),
                      label: Text(
                        'Add Category',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 70,
                  child: ChoiceChip(
                    elevation: 0,
                    pressElevation: 0,
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.all(8),
                    selected: _chipNum == 0,
                    label: const Text('All'),
                    onSelected: (e) {
                      expensePro.filterTagName = '';
                      expensePro.filterDate = null;
                      expensePro.filterExpnese();
                      setState(() {
                        _chipNum = 0;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.stylus,
                        PointerDeviceKind.invertedStylus,
                        PointerDeviceKind.touch,
                        PointerDeviceKind.trackpad,
                        PointerDeviceKind.unknown,
                      },
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          expensePro.allCategory.length,
                          (index) {
                            String lable = expensePro.allCategory[index];
                            return Container(
                              margin: const EdgeInsets.all(5),
                              child: ChoiceChip(
                                elevation: 0,
                                pressElevation: 0,
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.all(8),
                                selected: _chipNum == index + 1,
                                label: Text(lable),
                                onSelected: (e) {
                                  setState(() {
                                    _chipNum = index + 1;
                                  });
                                  expensePro.filterTagName = lable;
                                  expensePro.filterDate = null;
                                  expensePro.filterExpnese();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: IconButton(
                          splashRadius: 20,
                          onPressed: () async {
                            DateTime? selected = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2050));
                            if (selected != null) {
                              expensePro.filterDate = selected;
                              expensePro.filterTagName = null;
                              expensePro.filterExpnese();
                              setState(() {
                                _chipNum = 10;
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_month_outlined, size: 20)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(expensePro.filterDate != null ? '${expensePro.filterDate!.day}/${expensePro.filterDate!.month}/${expensePro.filterDate!.year}' : ''),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable2(
                columns: [
                  DataColumn2(label: Text('Index', style: style.textTheme.bodyLarge)),
                  DataColumn2(label: Text('Date', style: style.textTheme.bodyLarge)),
                  DataColumn2(label: Text('Category', style: style.textTheme.bodyLarge)),
                  DataColumn2(label: Text('Amount', style: style.textTheme.bodyLarge)),
                ],
                rows: List.generate(expensePro.allExpenses.length, (index) {
                  MExpenses exp = expensePro.allExpenses.reversed.toList()[index];
                  String fdate = DateFormat.yMMMMd('en_US').format(exp.date!);

                  return DataRow2.byIndex(color: MaterialStateProperty.all(style.canvasColor), index: index, cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(Text(fdate)),
                    DataCell(Text('${exp.category}')),
                    DataCell(Text('${exp.amount}')),
                  ]);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
