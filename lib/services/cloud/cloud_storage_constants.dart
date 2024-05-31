// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

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



const accountFieldName_Bank = 'Bank';
const accountFieldName_Cash = 'Cash';

const accountFieldName_Bank_balance = 'balance';
const accountFieldName_Bank_txns = 'txns';
const accountFieldName_Bank_usedAmount = 'Used amount';

const accountFieldName_Cash_balance = 'balance';
const accountFieldName_Cash_txns = 'txns';
const accountFieldName_Cash_usedAmount = 'used_amt';

const BankDefault= {
    accountFieldName_Bank_usedAmount: 0,
    accountFieldName_Bank_balance: 0,
    accountFieldName_Bank_txns: 0, 
  };
const  CashDefault= {
    accountFieldName_Cash_balance: 0,
    accountFieldName_Cash_txns: 0,
    accountFieldName_Cash_usedAmount: 0,
  };



//budget
const budgetFieldName = 'Budget';
const budgetMonthFieldName = 'month';
