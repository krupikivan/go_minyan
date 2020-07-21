import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_minyan/administration_bloc/bloc.dart';
import 'package:go_minyan/authentication_bloc/bloc.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:go_minyan/widget/widget.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final String username;
  final String userUID;

  UserScreen({Key key, this.username, this.userUID}) : super(key: key);

  ///POPUP menu
  static String menu, exit, pass;

  List<Items> choices;

  bool darkmode;

  @override
  Widget build(BuildContext context) {
    darkmode = Provider.of<AppModel>(context).darkmode;
    final blocPr = BlocProvider.of<AuthenticationBloc>(context);
    _fillPopupData(context);
    return LayoutBuilder(builder: (context, constrain) {
      var max = constrain.maxWidth;
      return WillPopScope(
        onWillPop: () => null,
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => blocPr.dispatch(IsAuthBack())),
            title: Text(Translations.of(context).adminPageTitle),
            backgroundColor: darkmode
                ? Theme.Colors.primaryDarkColor
                : Theme.Colors.primaryColor,
            actions: <Widget>[
              PopupMenu(choices: choices, type: 'user'),
            ],
          ),
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(max < 400 ? 5 : 16),
              alignment: Alignment(0.0, 0.0),
              margin: EdgeInsets.only(top: max < 400 ? 1 : 25),
              child: Center(child: Text('Hola user'))),
        ),
      );
    });
  }

  ///Popup menu
  _fillPopupData(context) {
    menu = Translations.of(context).menuTitle;
    pass = Translations.of(context).changePassword;
    exit = Translations.of(context).logOut;
    choices = <Items>[
      Items(Text(menu, style: TextStyle(fontFamily: Theme.Fonts.primaryFont)),
          Icon(Icons.menu)),
      Items(Text(pass, style: TextStyle(fontFamily: Theme.Fonts.primaryFont)),
          Icon(Icons.security)),
      Items(Text(exit, style: TextStyle(fontFamily: Theme.Fonts.primaryFont)),
          Icon(Icons.exit_to_app)),
    ];
  }
}
