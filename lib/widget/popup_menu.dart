import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_minyan/authentication_bloc/bloc.dart';
import 'package:go_minyan/menu/setting_screen.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/utils/items.dart';
import 'package:provider/provider.dart';

class PopupMenu extends StatefulWidget {
  final List<Items> choices;
  final String type;
  PopupMenu({Key key, this.choices, this.type}) : super(key: key);

  @override
  _PopupMenuState createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Items>(
      onSelected: widget.type == 'menu'
          ? choiceActionMenu
          : widget.type == 'admin' ? choiceActionAdmin : choiceActionRoot,
      itemBuilder: (BuildContext context) {
        return widget.choices.map((Items choice) {
          return PopupMenuItem<Items>(
              value: choice,
              child: ListTile(
                leading: choice.icon,
                title: choice.title,
              ));
        }).toList();
      },
    );
  }

  ///Manejo las funciones de ambas clases: admin_screen y menu_screen
  void choiceActionMenu(Items choice) {
    if (choice.title.data == widget.choices[0].title.data) {
      BlocProvider.of<AuthenticationBloc>(context).dispatch(GoToAdminPanel());
    }
    if (choice.title.data == widget.choices[1].title.data) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SettingScreen()));
    }
    if (choice.title.data == widget.choices[2].title.data) {
      //On logged out remove nusach from shared prefs
      Provider.of<AppModel>(context).removeAllUserData();
      BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedOut());
    }
  }

  void choiceActionAdmin(Items choice) {
    if (choice.title.data == widget.choices[0].title.data) {
      BlocProvider.of<AuthenticationBloc>(context).dispatch(IsAuthBack());
    }
    if (choice.title.data == widget.choices[1].title.data) {
      //Cambiar contraseña
      BlocProvider.of<AuthenticationBloc>(context).dispatch(IsChangePass());
    }
    if (choice.title.data == widget.choices[2].title.data) {
      //On logged out remove nusach from shared prefs
      Provider.of<AppModel>(context).removeAllUserData();
      BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedOut());
    }
  }

  void choiceActionRoot(Items choice) {
    if (choice.title.data == widget.choices[0].title.data) {
      BlocProvider.of<AuthenticationBloc>(context).dispatch(IsAuthBack());
    }
    if (choice.title.data == widget.choices[1].title.data) {
      BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedOut());
    }
  }
}
