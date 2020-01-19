import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/user_repository.dart';
import 'package:go_minyan/register/register.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/utils/utils.dart';
import 'package:go_minyan/widget/widget.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final UserRepository _userRepository;

  RegisterScreen({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  ///POPUP menu
  static String menu;
  static String exit;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<Items> choices;

  @override
  Widget build(BuildContext context) {
    _fillPopupData();
    bool darkmode = Provider.of<AppModel>(context).darkmode;
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).registerTitle
        ),
        actions: <Widget>[
          PopupMenu(choices: choices, type: 'root'),
//          IconButton(
//            icon: Icon(Icons.exit_to_app),
//            onPressed: () {
//              BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedOut());
//            },
//          )
        ],
        backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
      ),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          builder: (context) => RegisterBloc(userRepository: widget._userRepository),
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

  ///Popup menu
  _fillPopupData(){
    RegisterScreen.menu = Translations.of(context).menuTitle;
    RegisterScreen.exit = Translations.of(context).logOut;
    choices = <Items>[
      Items(Text(RegisterScreen.menu, style: TextStyle(fontFamily: Theme.Fonts.primaryFont)), Icon(Icons.menu)),
      Items(Text(RegisterScreen.exit, style: TextStyle(fontFamily: Theme.Fonts.primaryFont)), Icon(Icons.exit_to_app)),
    ];
  }
}