import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/user_repository.dart';
import 'package:go_minyan/login/login.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool _dark = Provider.of<AppModel>(context).darkmode;
    return Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return;
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
            gradient: _dark ? Theme.Colors.darkGradient : Theme.Colors.primaryGradient,
          ),
          child: BlocProvider<LoginBloc>(
            builder: (context) => LoginBloc(userRepository: _userRepository),
            child: LoginForm(userRepository: _userRepository),
          ),
        ),
      ),
    );
  }
}