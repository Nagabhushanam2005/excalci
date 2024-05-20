class CloudStorageException implements Exception {
  const CloudStorageException();
}




// C in CRUD
class CouldNotCreateNoteException extends CloudStorageException {}

// R in CRUD
class CouldNotGetAllNotesException extends CloudStorageException {}

// U in CRUD
class CouldNotUpdateExpenseException extends CloudStorageException {}
class CouldNotUpdateCategoryException extends CloudStorageException {}
class CouldNotUpdateAccountsException extends CloudStorageException {}


// D in CRUD
// class CouldNotDeleteNoteException extends CloudStorageException {}
class CouldNotDeleteExpenseException extends CloudStorageException {}
class CouldNotDeleteCategoryException extends CloudStorageException {}