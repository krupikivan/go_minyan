import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/resources/images.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/user_repository.dart';
import 'package:go_minyan/authentication_bloc/bloc.dart';
import 'package:go_minyan/login/login.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:go_minyan/validators.dart';
import 'package:go_minyan/widget/widget.dart';
import 'package:provider/provider.dart';

enum LoginFormType { login, reset }

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;
  final LoginFormType loginFormType;

  LoginForm(
      {Key key, @required UserRepository userRepository, this.loginFormType})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  LoginFormType loginFormType;
  _LoginFormState({this.loginFormType});

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  ///Internet connection
  Connectivity connectivity;
  var _connectionStatus;
  StreamSubscription<ConnectivityResult> suscription;

  String _email;
  String _password;

  bool _darkmode;

  bool _obscureTextLogin = true;

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  final formKey = GlobalKey<FormState>();
  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "reset") {
      setState(() {
        loginFormType = LoginFormType.reset;
      });
    } else {
      setState(() {
        loginFormType = LoginFormType.login;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    loginFormType = LoginFormType.login;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _email = "";
    _password = "";

    ///Internet connection
    connectivity = new Connectivity();
    suscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      print(_connectionStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    _darkmode = Provider.of<AppModel>(context).darkmode;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Translations.of(context).loginFailure,
                      style: TextStyle(color: Theme.Colors.secondaryColor),
                    ),
                    Icon(
                      Icons.error,
                      color: Theme.Colors.secondaryColor,
                    )
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: _darkmode
                    ? Theme.Colors.primaryDarkColor
                    : Theme.Colors.primaryColor,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextModel(
                        text: Translations.of(context).loginLoading,
                        color: Theme.Colors.secondaryColor),
                    CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.Colors.secondaryColor),
                    ),
                  ],
                ),
              ),
            );
        }
        if (state.isAuthenticated) {
          _loginBloc.dispatch(
            LoginWithCredentialsPressed(
              //pasar lo que esta en el stateful
              email: _email,
              password: _password,
              isAuth: true,
            ),
          );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return LayoutBuilder(builder: (context, constrain) {
            var max = constrain.maxWidth;
            return Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15,
                  right: MediaQuery.of(context).size.width * 0.15,
                  top: max < 400 ? 5 : 50,
                  bottom: max < 400 ? 5 : 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
//                  physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  _buildImage(),
                  _buildAdminBar(max),
                  _buildForm(max),
                  _buildLoginButton(max),
                  _buildLastButtons(),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildImage() {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Image(
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.25,
            image: new AssetImage(Images.logoImg)),
      ),
    );
  }

  Widget _buildAdminBar(max) {
    return Flexible(
      flex: 2,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: max < 400
            ? MediaQuery.of(context).size.height * 0.04
            : MediaQuery.of(context).size.height * 0.04,
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          color: Theme.Colors.secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.center,
            child: TextModel(
              text: loginFormType == LoginFormType.login
                  ? Translations.of(context).loginTitle
                  : Translations.of(context).lblForgot,
              size: 14,
              color: _darkmode
                  ? Theme.Colors.blackColor
                  : Theme.Colors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(max) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: loginFormType == LoginFormType.reset
          ? 80
          : max < 400
              ? MediaQuery.of(context).size.height * 0.25
              : MediaQuery.of(context).size.height * 0.2,
      child: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10.0, left: 25.0, right: 25.0),
              child: TextFormField(
                onChanged: (email) => _email = email,
                cursorColor: Theme.Colors.primaryColor,
                focusNode: myFocusNodeEmailLogin,
                autocorrect: false,
                validator: (email) {
                  return !Validators.isValidEmail(email)
                      ? Translations.of(context).invalidMail
                      : null;
                },
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    fontFamily: Theme.Fonts.primaryFont,
                    fontSize: 15.0,
                    color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    FontAwesomeIcons.envelope,
                    color: Colors.black,
                    size: 15.0,
                  ),
                  hintText: Translations.of(context).emailHint,
                  hintStyle: TextStyle(
                      fontFamily: Theme.Fonts.primaryFont,
                      fontSize: 15.0,
                      color: Colors.black54),
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            loginFormType == LoginFormType.reset
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                    child: TextFormField(
                      onChanged: (password) => _password = password,
                      cursorColor: Theme.Colors.primaryColor,
                      focusNode: myFocusNodePasswordLogin,
                      obscureText: _obscureTextLogin,
                      autocorrect: false,
                      validator: (password) {
                        return !Validators.isValidPassword(password)
                            ? Translations.of(context).invalidPass
                            : null;
                      },
                      style: TextStyle(
                          fontFamily: Theme.Fonts.primaryFont,
                          fontSize: 15.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesomeIcons.lock,
                          size: 15.0,
                          color: Colors.black,
                        ),
                        hintText: Translations.of(context).passHint,
                        hintStyle: TextStyle(
                            fontFamily: Theme.Fonts.primaryFont,
                            fontSize: 15.0,
                            color: Colors.black54),
                        suffixIcon: GestureDetector(
                          onTap: _toggleLogin,
                          child: Icon(
                            _obscureTextLogin
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: 15.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Theme.Colors.secondaryColor,
      ),
    );
  }

  Widget _buildLoginButton(max) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height * 0.05,
      margin: EdgeInsets.only(
          top: loginFormType == LoginFormType.reset
              ? 60
              : MediaQuery.of(context).size.height * 0.03,
          bottom: 5),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: _darkmode
                ? Theme.Colors.secondaryColor
                : Theme.Colors.primaryColor,
            offset: Offset(1.0, 6.0),
            blurRadius: 20.0,
          ),
        ],
        color: _darkmode
            ? Theme.Colors.secondaryDarkColor
            : Theme.Colors.primaryColor,
      ),
      child: LoginButton(
        size: MediaQuery.of(context).size,
        text: loginFormType == LoginFormType.login
            ? Translations.of(context).btnLogin
            : Translations.of(context).btnRestore,
        onPressed: loginFormType == LoginFormType.login
            ? () { 
              print("Hasta aca llego!");
              _onFormSubmitted();}
            : _btnResetPress,
      ),
    );
  }

  Widget _buildLastButtons() {
    return Flexible(
      flex: 2,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  if (loginFormType == LoginFormType.reset) {
                    switchFormState('login');
                    BlocProvider.of<AuthenticationBloc>(context)
                        .dispatch(AppStarted());
                  }
                  //loginFormType == LoginFormType.login ? BlocProvider.of<AuthenticationBloc>(context).dispatch(GuestStarted()) : BlocProvider.of<AuthenticationBloc>(context).dispatch(AppStarted());
                },
                child: loginFormType == LoginFormType.login
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .dispatch(GoToRegister());
                                },
                                child: TextModel(
                                  text: Translations.of(context).registerTitle,
                                  size: 17,
                                  color: _darkmode
                                      ? Theme.Colors.whiteColor
                                      : Theme.Colors.primaryColor,
                                  decoration: TextDecoration.underline,
                                )),
                            FlatButton(
                                onPressed: () {
                                  setState(() {
                                    switchFormState('reset');
                                  });
                                  //BlocProvider.of<AuthenticationBloc>(context).dispatch(ForgotPassword());
                                },
                                child: TextModel(
                                  text: Translations.of(context).btnForgot,
                                  size: 17,
                                  color: _darkmode
                                      ? Theme.Colors.whiteColor
                                      : Theme.Colors.primaryColor,
                                  decoration: TextDecoration.underline,
                                )),
                          ],
                        ),
                      )
                    : TextModel(
                        text: Translations.of(context).btnBack,
                        size: 17,
                        color: _darkmode
                            ? Theme.Colors.whiteColor
                            : Theme.Colors.primaryColor,
                        decoration: TextDecoration.underline,
                      )),
          ],
        ),
      ),
    );
  }

  void _btnResetPress() async {
    try {
      await _userRepository
          .sendPasswordResetEmail(_email)
          .then((onValue) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              backgroundColor: _darkmode
                  ? Theme.Colors.primaryDarkColor
                  : Theme.Colors.primaryColor,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Translations.of(context).lblEmailRestoreSent,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
      });
    } on PlatformException catch (e) {
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: _darkmode
                ? Theme.Colors.primaryDarkColor
                : Theme.Colors.primaryColor,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.code == 'ERROR_USER_NOT_FOUND'
                    ? Translations.of(context).connectionError
                    : Translations.of(context).errorDialog),
              ],
            ),
          ),
        );
    } finally {
      print("finally");
    }
  }

  @override
  void dispose() {
    suscription.cancel();
    super.dispose();
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _onFormSubmitted() {
    if (_connectionStatus == 'ConnectivityResult.none') {
      ShowToast().show(Translations().connectionError, 10);
    } else {
      _loginBloc.dispatch(GetIsAuthenticated(email: _email));
    }
  }
}
