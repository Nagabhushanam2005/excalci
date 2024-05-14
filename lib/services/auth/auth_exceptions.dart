//login

class UserNotFoundException implements Exception{
}
class WrongPasswordException implements Exception{
}

//register
class WeakPasswordException implements Exception{
}


class EmailInUseException implements Exception{
}
class InvalidEmailException implements Exception{
}

//generic error

class GenericAuthException implements Exception{
}

class UserNotLoggedException implements Exception{
}
