class OnboardingArgument {
  String? language;
  String? title;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  List? terms;
  bool? isError;

  OnboardingArgument({
    this.language,
    this.title,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.terms,
    this.isError,
  });
}

class Language {
  static const german = "de_DE";
  static const english = "en_GB";
  static const String key = "language";
}
