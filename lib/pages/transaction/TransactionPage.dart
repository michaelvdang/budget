import 'package:budget/models/Account.dart';
import 'package:budget/models/Category.dart';
import 'package:budget/models/Transaction.dart';
import 'package:budget/pages/transaction/list_item.dart';
import 'package:budget/services/AccountDatabaseServices.dart';
import 'package:budget/services/CategoryServices.dart';
import 'package:budget/services/TransactionDatabaseServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'NewTransactionPage.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
// Build list of items based on their types: date items and purchase items
// based on chronological order
// 2 types of ListItem: DateItem(String date) for the date category
//                      PurchaseItem(String name, Double amount, Color color)
// also get the sum of all spending this month
  // Authentication service
  final FirebaseAuth auth = FirebaseAuth.instance;
  // Transaction information
  final TransactionDatabaseServices _transactionService =
      TransactionDatabaseServices();
  // Account service
  final AccountDatabaseSerivces _accountService = AccountDatabaseSerivces();
  // Category service
  final CategoryServices _categoryService = CategoryServices();

  List<UserTransaction> transactionList = [];
  Map<String, Account> accounts = {};
  Map<String, Category> categories = {};

  double _totalSpending = 0;
  List<ListItem> items = [];

  List<ListItem> populateItems() {
    return transactionList.map((transaction) {
      return DetailedItem(
        // need to save purchase name to DB to get it out
        categoryName: categories[transaction.categoryid].name,
        amount: transaction.amount,
        catColor: Color(categories[transaction.categoryid].colors),
        accountColor: Color(accounts[transaction.accountid].color),
        type: transaction.type,
        date: transaction.date,
        id: transaction.id,
      );
    }).toList();
  }

  // Get transaction data and put them in the list
  void getData() async {
    User user = auth.currentUser;
    double totalSpending = 0;
    // Get accounts
    dynamic resultAccount = await _accountService.getAccounts(user.uid);
    if (resultAccount != null) {
      setState(() {
        for (int i = 0; i < resultAccount.length; i++) {
          accounts[resultAccount[i].id] = resultAccount[i];
        }
      });
    }

    // Get categories
    dynamic resultCategory = await _categoryService.getCategories(user.uid);
      if (resultCategory != null) {
        setState(() {
          for (int i = 0; i < resultCategory.length; i++) {
            categories[resultCategory[i].id] = resultCategory[i];
          }
        });
      }

    // Get transactions
    dynamic resultTransaction =
        await _transactionService.getTransactions(user.uid);
    if (resultTransaction != null) {
      setState(() {
        transactionList = resultTransaction;
      });
    }

    for (int i = 0; i < transactionList.length; i++) {
      totalSpending +=
          (transactionList[i].type == 0 ? transactionList[i].amount : 0);
    }
    _totalSpending = totalSpending;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void sortTransactionList() {
    transactionList.sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Widget build(BuildContext context) {
    getData();
    sortTransactionList();
    items = populateItems();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
        title: Row(
          children: [
            Expanded(
              flex: 8,
              child: Text(
                'Period Spending Total',
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                _totalSpending.toStringAsFixed(2),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue[900],
        child: Container(
          child: Icon(
            Icons.add,
            size: 40.0,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyCustomForm()),
          );
        },
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return items[index].buildItem(context);
          },
        ),
      ),
    );
  }
}
