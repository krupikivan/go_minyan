import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:go_minyan/resources/repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:go_minyan/user_repository.dart';
import 'package:go_minyan/register/register.dart';
import 'package:go_minyan/validators.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  Repository _repo = Repository();

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transform(
      Stream<RegisterEvent> events,
      Stream<RegisterState> Function(RegisterEvent event) next,
      ) {
    final observableStream = events as Observable<RegisterEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged && event is! PhoneChange && event is! NameChange);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged || event is PhoneChange || event is NameChange);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<RegisterState> mapEventToState(
      RegisterEvent event,
      ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is PhoneChange) {
      yield* _mapPhoneChangedToState(event.phone);
    } else if (event is NameChange) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password, event.title, event.contact);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapPhoneChangedToState(String phone) async* {
    yield currentState.update(
      isPhoneValid: Validators.isValidNumber(phone),
    );
  }

  Stream<RegisterState> _mapNameChangedToState(String name) async* {
    yield currentState.update(
      isNameValid: Validators.isValidInstName(name),
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
      String email,
      String password,
      String title,
      String contact,
      ) async* {
    yield RegisterState.loading();
    try {
      bool exist;
      await _repo.isAuthenticated(email).then((data) {
        //Si es == 0  significa que no existe registros en la tabla por ende es un usuario root
        if(data.documents.length != 0){
          exist = true;
        }else{exist = false;}
      });

      if(!exist){
        await _userRepository.signUp(
          email: email,
          password: password,
          title: title,
          contact: contact,
        );
        yield RegisterState.success();
      }else{
        yield RegisterState.duplicate();
      }
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}