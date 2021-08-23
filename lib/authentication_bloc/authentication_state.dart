import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthenticationState {
  final String displayName;
  final String userUID;

  Authenticated(this.displayName, this.userUID) : super([displayName]);

  @override
  String toString() => 'Authenticated { displayName: $displayName }';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}

class Guest extends AuthenticationState {
  @override
  String toString() => 'Guest';
}

class AuthBack extends AuthenticationState {
  @override
  String toString() => 'AuthBack';
}

class ChangePassScreen extends AuthenticationState {
  @override
  String toString() => 'ChangePassScreen';
}