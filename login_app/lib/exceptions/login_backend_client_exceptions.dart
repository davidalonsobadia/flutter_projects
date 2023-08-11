import 'package:login_app/exceptions/login_exception.dart';

class UnKnowApiException implements LoginException {
  int httpCode;

  @override
  String message;

  UnKnowApiException(this.httpCode, this.message);
}

class ItemNotFoundException implements LoginException {
  @override
  String message;

  ItemNotFoundException(this.message);
}

class NetworkException implements LoginException {
  @override
  String message;

  NetworkException(this.message);
}
