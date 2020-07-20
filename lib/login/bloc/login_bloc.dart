import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_minyan/resources/repository.dart';
import 'package:go_minyan/utils/firestore_string.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:go_minyan/login/login.dart';
import 'package:go_minyan/user_repository.dart';
import 'package:go_minyan/validators.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;
  Repository _repo = new Repository();
  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transform(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final observableStream = events as Observable<LoginEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
        isAuth: event.isAuth,
      );
    } else if (event is GetIsAuthenticated) {
      yield* _mapGetIsAuthenticated(
        email: event.email,
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
    bool isAuth,
  }) async* {
    yield LoginState.loading();
    try {
      if (isAuth) {
        await _userRepository.signInWithCredentials(email, password);
        yield LoginState.success();
      } else {
        yield LoginState.failure();
      }
    } catch (_) {
      yield LoginState.failure();
    }
  }

  //Este metodo primero se fija si el usuario esta autenticadod por el administrador y luego
  //dispara el login.
  Stream<LoginState> _mapGetIsAuthenticated({
    String email,
  }) async* {
    try {
      bool auth;
      await _repo.isAuthenticated(email).then((data) {
        //Si es == 0  significa que no existe registros en la tabla por ende es un usuario root
        // if(data.documents.length == 0 || data.documents[0].data[FS.isAuthenticated] == true){
        if (!data.exists) {
          auth = true;
        } else {
          auth = false;
        }
      });
      if (auth) {
        yield LoginState.authenticated();
      } else {
        yield LoginState.failure();
      }
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
