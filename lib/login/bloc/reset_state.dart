import 'package:meta/meta.dart';

@immutable
class ResetState {
  final bool isEmailValid;
  final bool isSuccess;
  final bool isFailure;


  ResetState({
    @required this.isEmailValid,
    @required this.isSuccess,
    @required this.isFailure,
  });
  
  
  factory ResetState.failure() {
    return ResetState(
      isEmailValid: true,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory ResetState.success() {
    return ResetState(
      isEmailValid: true,
      isSuccess: true,
      isFailure: false,
    );
  }


  @override
  String toString() {
    return '''LoginState {
      isEmailValid: $isEmailValid,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}