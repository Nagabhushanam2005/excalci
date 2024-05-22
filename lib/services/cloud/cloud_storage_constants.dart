import 'package:flutter/material.dart';

const expensesDoc="""
Mode  (map)

      Bank acc  false (boolean)

      Cash acc  true  (boolean)

Time  May 20, 2024 at 11:02:47 AM UTC+5:30  (timestamp)

amount  132  (number)

category  "Expense" (string)

currency  "Rs." (string)

desc  "BBQ" (string)

photo "idk" (string)

txn_id  123 (number)

uid "myid"  (string)

use_category  "Food & Dining"  (string)
""";
const categoriesDoc="""
Expenses  (map)

      c1  "Food & Dining"  (string)

      c10 "Rent"  (string)

      c11 "Taxes" (string)

      c12 "Others"  (string)

      c2  "Shopping"  (string)

      c3  "Travelling"  (string)

      c4  "Entertainment" (string)

      c5  "Medical" (string)

      c6  "Personal"  (string)

      c7  "Education" (string)

      c8  "Bills / Utilites"  (string)

      c9  "Investments" (string)


Income  (map)

      c1  "Salary"  (string)

      c2  "Sold Items"  (string)

      c3  "Part Time" (string)

      c4  "Coupons / Cashback"  (string)
""";

const accountsDoc="""
Bank  (map)

      Used amount 0 (number)

      balance 1000  (number)

      txns  5 (number)


Cash  (map)

      Used percent  30  (number)

      txns  13  (number)

      used_amt  500
""";

const ownerUserIdFieldName = 'uid';
const descFieldName = 'desc';
const amountFieldName = 'amount';
const categoryFieldName = 'category';
const timeFieldName = 'Time';
const txnIdFieldName= 'txn_id';
const currencyFieldName = 'currency';
// const photoFieldName = 'photo';
const useCategoryFieldName = 'use_category';
const textFieldName = 'text';
const accountFieldName = 'Mode';

const expensesCollectionName = 'Expenses';
const categoriesCollectionName = 'Categories';
const accountsCollectionName = 'Accounts';

const categoryExpenseFieldName = 'Expenses';
const categoryIncomeFieldName = 'Income';

//category: icondata
const categoryExpenseDefault= {
  'Food & Dining': Icons.ramen_dining_outlined,
  'Shopping': Icons.shopping_cart,
  'Travelling': Icons.directions_bus,
  'Entertainment': Icons.movie_creation_sharp,
  'Medical': Icons.medical_services,
  'Personal': Icons.self_improvement_sharp,
  'Education': Icons.school,
  'Bills / Utilites': Icons.topic_outlined,
  'Investments': Icons.attach_money,
  'Rent': Icons.house,
  'Taxes': Icons.currency_rupee_sharp,
  'Others': Icons.more_horiz,
};

const categoryIncomeDefault= {
  'Salary': Icons.currency_rupee_sharp,
  'Sold Items': Icons.sell,
  'Part Time': Icons.work_history,
  'Coupons / Cashback': Icons.card_giftcard,
};

const accountsDefault= {
  accountFieldName_Bank: Icons.account_balance,
  accountFieldName_Cash: Icons.currency_rupee_sharp,
};

const accountFieldName_Bank = 'Bank';
const accountFieldName_Cash = 'Cash';

const accountFieldName_Bank_balance = 'balance';
const accountFieldName_Bank_txns = 'txns';
const accountFieldName_Bank_usedAmount = 'Used amount';

const accountFieldName_Cash_usedPercent = 'Used percent';
const accountFieldName_Cash_txns = 'txns';
const accountFieldName_Cash_usedAmount = 'used_amt';

const BankDefault= {
    accountFieldName_Bank_usedAmount: 0,
    accountFieldName_Bank_balance: 0,
    accountFieldName_Bank_txns: 0,
  };
const  CashDefault= {
    accountFieldName_Cash_usedPercent: 0,
    accountFieldName_Cash_txns: 0,
    accountFieldName_Cash_usedAmount: 0,
  };
