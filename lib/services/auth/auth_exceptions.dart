// login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register exception
class WeakPassworddAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions: in the sense that the remaining exceptions not known
// but caught by the exception

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
