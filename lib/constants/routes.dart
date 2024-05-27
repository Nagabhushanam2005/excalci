const loginRoute="/login/";
const registerRoute="/register/";
const verifyEmailRoute="/verify_email/";
const excalciRoute="/excalci/";
const excalciHomeRoute="/excalci/home";
const excalciAccountsRoute="/excalci/accounts";
const excalciAddAccountRoute="/excalci/addAccount";
const excalciAnalysisRoute="/excalci/analysis";
const excalciUserRoute="/excalci/user";
const excalciAddExpenseRoute="/excalci/addExpense";
const excalciSeeAllRoute="/excalci/allExpenses";
const excalciAddBudgetRoute='/excalci/addBudget';

class DisplayEI{
  bool income=false;
  bool expense=false;
  DisplayEI({required this.income,required this.expense});

}

class DisplayAcc{
  bool bank=false;
  bool cash=false;
  DisplayAcc({required this.bank,required this.cash});

}
