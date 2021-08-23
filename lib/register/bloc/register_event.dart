import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  RegisterEvent([List props = const []]) : super(props);
}

class EmailChanged extends RegisterEvent {
  final String email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends RegisterEvent {
  final String password;

  PasswordChanged({@required this.password}) : super([password]);

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class PhoneChange extends RegisterEvent {
  final String phone;

  PhoneChange({@required this.phone}) : super([phone]);

  @override
  String toString() => 'PasswordChanged { password: $phone }';
}

class NameChange extends RegisterEvent {
  final String name;

  NameChange({@required this.name}) : super([name]);

  @override
  String toString() => 'PasswordChanged { password: $name }';
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;
  final String title;
  final String contact;

  Submitted({@required this.email, @required this.password, @required this.title, @required this.contact})
      : super([email, password, title, contact]);

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password, title: $title, contact: $contact }';
  }
}