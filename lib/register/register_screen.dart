import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/user_repository.dart';
import 'package:go_minyan/register/register.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/utils/utils.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final UserRepository userRepository;


  ///POPUP menu
  static String menu;
  static String exit;

  const RegisterScreen({Key key, this.userRepository}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<Items> choices;

  @override
  Widget build(BuildContext context) {
//    _fillPopupData();
    bool darkmode = Provider.of<AppModel>(context).darkmode;
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).registerTitle
        ),
        backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
      ),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          builder: (context) => RegisterBloc(userRepository: widget.userRepository),
          child: Container(
              child: Stack(
                children: <Widget>[
                  RegisterForm(darkmode: darkmode),
                ],
              )
          ),
        ),
      ),
    );
  }
}