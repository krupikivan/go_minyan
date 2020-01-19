import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:go_minyan/authentication_bloc/bloc.dart';
import 'package:go_minyan/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is GuestStarted) {
      yield* _mapGuestInitial();
    } else if (event is IsAuthBack) {
      yield* _mapAuthBackToState();
    } else if (event is IsChangePass) {
      yield* _mapChangePassword();
    } else if (event is ChangePass) {
      yield* _mapIsChangingPassword(event.newPass);
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final name = await _userRepository.getUser();
        final userUID = await _userRepository.getUserUID();
        yield Authenticated(name, userUID);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }
  ///Para que arranque en el menu y no en el login
  Stream<AuthenticationState> _mapGuestInitial() async* {
    yield Guest();
  }

  Stream<AuthenticationState> _mapAuthBackToState() async* {
    yield AuthBack();
  }

  //Para que vaya a la pantalla de cambiar contraseña
  Stream<AuthenticationState> _mapChangePassword() async* {
    yield ChangePassScreen();
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(await _userRepository.getUser(), await _userRepository.getUserUID());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }

  //Cambiando la contraseña
  Stream<AuthenticationState> _mapIsChangingPassword(newPass) async* {
    yield Unauthenticated();
    _userRepository.changePass(newPass);
  }
}