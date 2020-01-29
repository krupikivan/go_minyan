import 'package:go_minyan/translation.dart';

class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static final RegExp _numberRegExp = RegExp(r'^[0-9]+$');

  static final RegExp _nameRegExp = RegExp(r'^[A-Za-z ]+$');

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

  ///Name Validator
  String validateName(String value) {
    if (value.isEmpty)
      return Translations().nameValid;
    final RegExp nameExp = validateNameForm;
    if (!nameExp.hasMatch(value))
      return Translations().errorFormName;
    return null;
  }

  ///Phone number validator
  String validatePhoneNumber(String value) {
    final RegExp phoneExp = validatePhoneForm;
    if (!phoneExp.hasMatch(value))
      return Translations().phoneValid;
    return null;
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isValidInstName(String name) {
    return _nameRegExp.hasMatch(name);
  }

  static isValidPhone(String phone) {
    return _numberRegExp.hasMatch(phone);
  }

  ///MINIAN FORM VALIDATORS
  static final RegExp validateNameForm = RegExp(r'^[A-Za-z ]+$');
  static final RegExp validatePhoneForm = RegExp(r'^[0-9]+$');
  static final RegExp validateEmailForm = RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
  static final RegExp validatePassForm = RegExp( r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');



}