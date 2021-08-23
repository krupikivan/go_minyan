import 'package:flutter/material.dart';
import 'package:go_minyan/administration_bloc/bloc.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/resources/mailProvider.dart';
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/utils/items.dart';
import 'package:go_minyan/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:url_launcher/url_launcher.dart';

class RootScreen extends StatefulWidget {
  ///POPUP menu
  static String menu;
  static String exit;

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  List<Items> choices;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool darkmode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    blocRoot.getMarkersAuth();
    _fillPopupData();
    darkmode = Provider.of<AppModel>(context).darkmode;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Translations.of(context).registerTitle),
        actions: <Widget>[
          PopupMenu(choices: choices, type: 'root'),
        ],
        backgroundColor: darkmode
            ? Theme.Colors.primaryDarkColor
            : Theme.Colors.primaryColor,
      ),
      body: Center(
          child: StreamBuilder<List<MarkerData>>(
              stream: blocRoot.listenMarker,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return Container(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(snapshot.data[index].title),
                        subtitle: Text(snapshot.data[index].email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            snapshot.data[index].isAuthenticated == false
                                ? IconButton(
                                    icon: Icon(Icons.email,
                                        color: darkmode == true
                                            ? Theme.Colors.secondaryColor
                                            : Theme.Colors.primaryColor),
                                    onPressed: () =>
                                        _sendMail(snapshot.data[index]))
                                : Container(),
                            snapshot.data[index].isAuthenticated == false
                                ? IconButton(
                                    icon: Icon(Icons.delete,
                                        color: darkmode == true
                                            ? Theme.Colors.secondaryColor
                                            : Theme.Colors.primaryColor),
                                    onPressed: () =>
                                        blocRoot.delete(snapshot.data[index]))
                                : Container(),
                            IconButton(
                                icon: Icon(
                                  Icons.verified_user,
                                  color: snapshot.data[index].isAuthenticated ==
                                          true
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    blocRoot
                                        .authenticateUser(snapshot.data[index]);
                                  });
                                }),
                          ],
                        ),
                      );
                    },
                  ),
                );
              })),
    );
  }

  ///Popup menu
  _fillPopupData() {
    RootScreen.menu = Translations().menuTitle;
    RootScreen.exit = Translations().logOut;
    choices = <Items>[
      Items(
          Text(RootScreen.menu,
              style: TextStyle(fontFamily: Theme.Fonts.primaryFont)),
          Icon(Icons.menu)),
      Items(
          Text(RootScreen.exit,
              style: TextStyle(fontFamily: Theme.Fonts.primaryFont)),
          Icon(Icons.exit_to_app)),
    ];
  }

  void _sendMail(MarkerData data) {
    MailProvider mailProvider = new MailProvider();
    mailProvider.sendGMail(data).then((value) {
      showInSnackBar(Translations().successDialogTitle);
    }).catchError((err) {
      showInSnackBar(Translations().errorDialog);
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: TextModel(text: value, color: Theme.Colors.secondaryColor),
      backgroundColor:
          darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
    ));
  }
}
