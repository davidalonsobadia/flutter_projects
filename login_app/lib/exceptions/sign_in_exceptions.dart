import 'package:login_app/exceptions/login_exception.dart';

class GoogleSignInException implements LoginException {
  @override
  String message;

  GoogleSignInException(this.message);
}

class UserRegistrationException implements LoginException {
  @override
  String message;

  UserRegistrationException(this.message);
}
