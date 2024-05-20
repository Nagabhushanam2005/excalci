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

const categoryExpenseFieldName_c1 = 'c1';
const categoryExpenseFieldName_c2 = 'c2';
const categoryExpenseFieldName_c3 = 'c3';
const categoryExpenseFieldName_c4 = 'c4';
const categoryExpenseFieldName_c5 = 'c5';
const categoryExpenseFieldName_c6 = 'c6';
const categoryExpenseFieldName_c7 = 'c7';
const categoryExpenseFieldName_c8 = 'c8';
const categoryExpenseFieldName_c9 = 'c9';
const categoryExpenseFieldName_c10 = 'c10';
const categoryExpenseFieldName_c11 = 'c11';
const categoryExpenseFieldName_c12 = 'c12';


const categoryIncomeFieldName_c1 = 'c1';
const categoryIncomeFieldName_c2 = 'c2';
const categoryIncomeFieldName_c3 = 'c3';
const categoryIncomeFieldName_c4 = 'c4';

const categoryExpenseDefault= {
  categoryExpenseFieldName_c1: 'Food & Dining',
  categoryExpenseFieldName_c2: 'Shopping',
  categoryExpenseFieldName_c3: 'Travelling',
  categoryExpenseFieldName_c4: 'Entertainment',
  categoryExpenseFieldName_c5: 'Medical',
  categoryExpenseFieldName_c6: 'Personal',
  categoryExpenseFieldName_c7: 'Education',
  categoryExpenseFieldName_c8: 'Bills / Utilites',
  categoryExpenseFieldName_c9: 'Investments',
  categoryExpenseFieldName_c10: 'Rent',
  categoryExpenseFieldName_c11: 'Taxes',
  categoryExpenseFieldName_c12: 'Others',
};

const categoryIncomeDefault= {
  categoryIncomeFieldName_c1: 'Salary',
  categoryIncomeFieldName_c2: 'Sold Items',
  categoryIncomeFieldName_c3: 'Part Time',
  categoryIncomeFieldName_c4: 'Coupons / Cashback',
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
