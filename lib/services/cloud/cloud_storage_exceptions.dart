class CloudStorageException implements Exception {
  const CloudStorageException();
}




// C in CRUD
class CouldNotCreateNoteException extends CloudStorageException {}

// R in CRUD
class CouldNotGetAllNotesException extends CloudStorageException {}


// U in CRUD
class CouldNotUpdateExpenseException extends CloudStorageException {}
class CouldNotUpdateAccountsException extends CloudStorageException {}
class CouldNotUpdateBudgetException extends CloudStorageException {}


// D in CRUD
// class CouldNotDeleteNoteException extends CloudStorageException {}
class CouldNotDeleteExpenseException extends CloudStorageException {}
class CouldNotDeleteBudgetException extends CloudStorageException {}