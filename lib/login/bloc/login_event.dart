import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

// class EmailChanged extends LoginEvent {
//   final String email;

//   EmailChanged({@required this.email}) : super([email]);

//   @override
//   String toString() => 'EmailChanged { email :$email }';
// }

// class PasswordChanged extends LoginEvent {
//   final String password;

//   PasswordChanged({@required this.password}) : super([password]);

//   @override
//   String toString() => 'PasswordChanged { password: $password }';
// }

class Submitted extends LoginEvent {
  final String email;
  final String password;

  Submitted({@required this.email, @required this.password})
      : super([email, password]);

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;
  final bool isAuth;

  //Get context from login form
  LoginWithCredentialsPressed({@required this.email, @required this.password, @required this.isAuth, })
      : super([email, password, isAuth]);

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: $password }';
  }
}

class GetIsAuthenticated extends LoginEvent {
  final String email;

  //Get context from login form
  GetIsAuthenticated({@required this.email, })
      : super([email]);

  @override
  String toString() {
    return 'GetIsAuthenticated { email: $email }';
  }
}