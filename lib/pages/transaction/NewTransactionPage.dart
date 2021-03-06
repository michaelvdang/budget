import 'package:budget/models/Account.dart';
import 'package:budget/models/Category.dart';
import 'package:budget/services/AccountDatabaseServices.dart';
import 'package:budget/services/CategoryServices.dart';
import 'package:budget/services/TransactionDatabaseServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

enum TransactionType { expense, income }

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TransactionDatabaseServices _transaction = TransactionDatabaseServices();
  String note;
  double amount;

  final _formKey = GlobalKey<FormState>();

  validate(String value) {
    if (value.isEmpty) {
      return 'Please enter some thing';
    }
    return null;
  }

  DateTime _selectedDate;
  TextEditingController _dateEditingController;
  TextEditingController _timeEditingController;
  TransactionType _type = TransactionType.expense;

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.lightBlue[900],
                onPrimary: Colors.lightBlue[400],
                surface: Colors.red,
                onSurface: Colors.lightBlue[900],
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _dateEditingController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _dateEditingController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  void _selectTime(BuildContext context) async {
    final TimeOfDay newTime = await showTimePicker(
        context: context,
        initialTime: _time,
        initialEntryMode: TimePickerEntryMode.input,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.lightBlue[900],
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.lightBlue[900],
              ),
              dialogBackgroundColor: Colors.blue[500],
            ),
            child: child,
          );
        });
    if (newTime != null) {
      _time = newTime;
      _timeEditingController
        ..text = formatTimeOfDay(_time)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _timeEditingController.text.length,
            affinity: TextAffinity.upstream));

      // setState(() {
      //   _time = newTime;
      // });
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  setupDatetime() {
    _dateEditingController = TextEditingController();
    _selectedDate = DateTime.now();
    _dateEditingController
      ..text = DateFormat.yMMMd().format(_selectedDate)
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: _dateEditingController.text.length,
          affinity: TextAffinity.upstream));
    _timeEditingController = TextEditingController();
    _time = TimeOfDay.now();

    _timeEditingController
      ..text = formatTimeOfDay(_time)
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: _timeEditingController.text.length,
          affinity: TextAffinity.upstream));
  }

  // Retrieving account information
  final AccountDatabaseSerivces _accountService = AccountDatabaseSerivces();
  List<Account> _accountList = [];
  Account currentAccount;

  Future<List<Account>> getAccounts() async {
    User user = auth.currentUser;
    dynamic result = await _accountService.getAccounts(user.uid);
    setState(() {
      _accountList = result;
    });
    return result;
  }

  Container accountDropdown() {
    // DropdownButton<int> dropdown() {
    DropdownButton<Account> button = DropdownButton<Account>(
      isExpanded: true,
      value: currentAccount,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(
        color: Colors.black,
      ),
      underline: SizedBox(), //(
      onChanged: (Account newValue) {
        setState(() {
          currentAccount = newValue;
        });
      },
      items:
          _accountList.toList().map<DropdownMenuItem<Account>>((Account value) {
        return DropdownMenuItem<Account>(
          value: value,
          child: Row(
            children: [
              SizedBox(
                width: 19.0,
              ),
              Icon(
                Icons.circle,
                size: 15.0,
                color: Color(value.color),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(value.name),
            ],
          ),
        );
      }).toList(),
    );
    Container c = Container(
        child: button,
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[500],
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ));
    return c;
  }

  // Category service
  final CategoryServices _categoryService = CategoryServices();
  List<Category> _categoryList = [];
  Category currentCategory;

  Future<List<Category>> getCategories() async {
    User user = auth.currentUser;
    dynamic result = await _categoryService.getCategories(user.uid);
    setState(() {
      _categoryList = result;
    });
    print(_categoryList[0].id);
    return result;
  }

  Container categoryDropdown() {
    // DropdownButton<int> dropdown() {
    DropdownButton<Category> button = DropdownButton<Category>(
      isExpanded: true,
      value: currentCategory,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(
        color: Colors.black,
      ),
      underline: SizedBox(), //(
      onChanged: (Category newValue) {
        setState(() {
          currentCategory = newValue;
        });
      },
      items: _categoryList
          .toList()
          .map<DropdownMenuItem<Category>>((Category value) {
        return DropdownMenuItem<Category>(
          value: value,
          child: Row(
            children: [
              SizedBox(
                width: 19.0,
              ),
              Icon(
                Icons.circle,
                size: 15.0,
                color: Color(value.colors),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(value.name),
            ],
          ),
        );
      }).toList(),
    );
    Container c = Container(
        child: button,
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[500],
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ));
    return c;
  }

  @override
  void initState() {
    super.initState();
    setupDatetime();
    SchedulerBinding.instance.addPostFrameCallback((_) => getAccounts());
    SchedulerBinding.instance.addPostFrameCallback((_) => getCategories());
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
        title: Row(
          children: [
            Expanded(
              flex: 16,
              child: Text(
                'Add New Transaction',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Radio<TransactionType>(
                                value: TransactionType.expense,
                                groupValue: _type,
                                onChanged: (TransactionType value) {
                                  setState(() {
                                    _type = value;
                                  });
                                },
                              ),
                              Text("Expense")
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Radio<TransactionType>(
                                value: TransactionType.income,
                                groupValue: _type,
                                onChanged: (TransactionType value) {
                                  setState(() {
                                    _type = value;
                                  });
                                },
                              ),
                              Text("Income")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: categoryDropdown(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: accountDropdown(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16.0,
                    ),
                    child: SizedBox(
                      height: 80.0,
                      child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.shopping_bag_outlined),
                            border: OutlineInputBorder(),
                            labelText: 'Note',
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) => validate(value),
                          onChanged: (value) {
                            setState(() {
                              note = value;
                            });
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16.0,
                    ),
                    child: SizedBox(
                      height: 80.0,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.attach_money,
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Amount',
                        ),
                        validator: (value) {
                          try {
                            double val = double.parse(value);
                            assert(val is double);
                            amount = val;
                          } on FormatException catch (e) {
                            print(e);
                            return "Must enter a number";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _dateEditingController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Date',
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            readOnly: true,
                            onTap: () {
                              _selectDate(context);
                            },
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: _timeEditingController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Time',
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            readOnly: true,
                            onTap: () {
                              _selectTime(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Processing Data')));
                              print(_selectedDate.toString());
                              await _transaction.setTransaction(
                                  user.uid,
                                  currentAccount.id,
                                  currentCategory.id,
                                  _type,
                                  note,
                                  amount,
                                  _selectedDate,
                                  _time);
                              await _accountService.editAccount(
                                  currentAccount.id, amount, _type);
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
