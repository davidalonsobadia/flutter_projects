import 'package:login_app/services/exceptions/login_exception.dart';

class GoogleSignInException implements LoginException {
  @override
  String message;

  GoogleSignInException(this.message);
}

class EmailPasswordSignInException implements LoginException {
  @override
  String message;

  EmailPasswordSignInException(this.message);
}

class UserRegistrationException implements LoginException {
  @override
  String message;

  UserRegistrationException(this.message);
}
