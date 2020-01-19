class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static final _numberRegExp = RegExp(r'^[0-9]+$');

  static isValidNumber(String number) {
    return _numberRegExp.hasMatch(number);
  }

  ///Que se ingrese solo numeros
  static bool validateNumber(String value) {
    if (!isValidNumber(value))
      return false;
    else
      return true;
  }

  ///REGISTER FORM
  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  ///MINIAN FORM VALIDATORS
  static final RegExp validateNameForm = RegExp(r'^[A-Za-z ]+$');
  static final RegExp validatePhoneForm = RegExp(r'^[0-9]+$');
  static final RegExp validateEmailForm = RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
  static final RegExp validatePassForm = RegExp( r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');



}