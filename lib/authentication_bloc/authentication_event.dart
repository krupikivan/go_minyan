import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

// class GuestStarted extends AuthenticationEvent {
//   @override
//   String toString() => 'GuestStarted';
// }

class LoggedIn extends AuthenticationEvent {
  @override
  String toString() => 'LoggedIn';
}

class GoToAdminPanel extends AuthenticationEvent {
  @override
  String toString() => 'GoToAdminPanel';
}

class GoToRegister extends AuthenticationEvent {
  @override
  String toString() => 'GoToRegister';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}

class IsAuthBack extends AuthenticationEvent {
  @override
  String toString() => 'IsAuthBack';
}

//Para ir a la pagina de cambiar la contraseña
class IsChangePass extends AuthenticationEvent {
  @override
  String toString() => 'IsChangePass';
}

//Para cambiar la contraseña
class ChangePass extends AuthenticationEvent {
  final String newPass;

  ChangePass(this.newPass);
  @override
  String toString() => 'ChangePass';
}
