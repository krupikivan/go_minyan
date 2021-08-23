import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_minyan/administration/admin_times_screen.dart';
import 'package:go_minyan/administration/google_map_inline.dart';
import 'package:go_minyan/administration_bloc/bloc.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:go_minyan/widget/widget.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  final String username;
  final String userUID;

  const AdminScreen({Key key, this.username, this.userUID}) : super(key: key);

  @override
  _AdminScreenState createState() => new _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ///POPUP menu
  static String menu, exit, pass;

  List<Items> choices;

  ///Internet connection
  Connectivity connectivity;
  var _connectionStatus;
  StreamSubscription<ConnectivityResult> suscription;

  ///Variable que controla si se presiono el buscador de ubicacion o no
  TextEditingController _titleController,
      _addressController,
      _contactController;

  bool _initialized = false;
  bool _restoreData = false;
  UserData _userDataEditable;

  bool darkmode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    suscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _addressController = TextEditingController();
    _contactController = TextEditingController();
    connectivity = new Connectivity();
    suscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    ///Cuando se trabaja con provider, se envian dentro de los builders,
    ///nunca dentro de init state
    //Get nusach list from firebase
    blocNusach.getNusachList(Provider.of<AppModel>(context));
    //Fill userData bloc
    blocUserData.getUserDataFromFirebase(
        widget.userUID, Provider.of<AppModel>(context));
    //Para editar y guardarlo en el stream
    _userDataEditable = Provider.of<AppModel>(context).userData;
    _fillPopupData();
    darkmode = Provider.of<AppModel>(context).darkmode;
    return LayoutBuilder(builder: (context, constrain) {
      var max = constrain.maxWidth;
      return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(Translations.of(context).adminPageTitle),
          backgroundColor: darkmode
              ? Theme.Colors.primaryDarkColor
              : Theme.Colors.primaryColor,
          actions: <Widget>[
            PopupMenu(choices: choices, type: 'admin'),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(max < 400 ? 5 : 16),
          alignment: Alignment(0.0, 0.0),
          margin: EdgeInsets.only(top: max < 400 ? 1 : 25),
          child: StreamBuilder<UserData>(
              stream: blocUserData.getUserData,
//          stream: blocUserData.userData(widget.userUID),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Theme.Colors.primaryColor)));
                else {
                  if (!_initialized) {
                    _titleController.text = snapshot.data.title;
                    _addressController.text = snapshot.data.address;
                    _contactController.text = snapshot.data.contact;
                    _initialized = true;
                  }
                  if (_restoreData) {
                    _titleController.text = snapshot.data.title;
                    _addressController.text = snapshot.data.address;
                    _contactController.text = snapshot.data.contact;
                    UserData _restoreUser = _userDataEditable;
                    _restoreUser.title = snapshot.data.title;
                    _restoreUser.address = snapshot.data.address;
                    _restoreUser.contact = snapshot.data.contact;
                    blocUserData.changeUserData(_restoreUser);
                    _restoreData = false;
                  }
                  return _buildForm(snapshot.data, max);
                }
              }),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: newAccount,
          label: TextModel(
            text: Translations.of(context).btnEditorTimes,
            color: Theme.Colors.secondaryColor,
            size: max < 400 ? 12 : 15,
          ),
          icon: Icon(
            Icons.add,
            color: Theme.Colors.secondaryColor,
            size: max < 400 ? 10 : 15,
          ),
          backgroundColor: darkmode
              ? Theme.Colors.primaryDarkColor
              : Theme.Colors.primaryColor,
        ),
      );
    });
  }

  void newAccount() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return AdminTimesScreen(darkmode: darkmode);
      }),
    );
  }

  Widget _buildForm(UserData data, max) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          _userDataField(max),
          _titleField(data),
          SizedBox(
            height: max < 400 ? 1 : 10,
          ),
          _addressField(data),
          SizedBox(
            height: max < 400 ? 1 : 10,
          ),
          _contactField(data),
          SizedBox(
            height: max < 400 ? 1 : 10,
          ),
          _buttons(max),
          SizedBox(
            height: max < 400 ? 1 : 10,
          ),
          _googleMapInline(max),
        ],
      ),
    );
  }

  Widget _userDataField(max) {
    return ListTile(
      title: TextModel(text: widget.username, size: max < 400 ? 15 : 20),
      leading: Icon(Icons.account_circle, size: max < 400 ? 25 : 36),
    );
  }

  Widget _titleField(UserData data) {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      cursorColor: Theme.Colors.primaryColor,
      onChanged: (value) {
        _userDataEditable.title = value;
      },
      controller: _titleController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.Colors.primaryColor)),
        labelText: Translations.of(context).lblName,
        labelStyle: TextStyle(color: Theme.Colors.primaryColor),
        suffixIcon: IconButton(
          onPressed: () {
            _titleController.clear();
          },
          icon: Icon(Icons.clear,
              color: darkmode
                  ? Theme.Colors.secondaryColor
                  : Theme.Colors.primaryColor),
        ),
      ),
    );
  }

  Widget _addressField(UserData data) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.text,
            cursorColor: Theme.Colors.primaryColor,
            onChanged: (value) {
              _userDataEditable.address = value;
            },
            controller: _addressController,
            decoration: InputDecoration(
              labelText: Translations.of(context).lblAddress,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.Colors.primaryColor)),
              labelStyle: TextStyle(color: Theme.Colors.primaryColor),
//                    suffixIcon: IconButton(
//                      onPressed: () {
//                        FocusScope.of(context).requestFocus(new FocusNode());
//                        _getLatLong();
//                      }, icon: Icon(Icons.my_location, color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor),
//                    ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _getLatLong();
          },
          icon: Icon(Icons.my_location,
              color: darkmode
                  ? Theme.Colors.accentColorLight
                  : Theme.Colors.accentColorDark),
        ),
      ],
    );
  }

  Widget _contactField(UserData data) {
    return TextField(
      cursorColor: Theme.Colors.primaryColor,
      onChanged: (value) {
        _userDataEditable.contact = value;
      },
      controller: _contactController,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.Colors.primaryColor)),
        labelStyle: TextStyle(color: Theme.Colors.primaryColor),
        labelText: Translations.of(context).lblContact,
        suffixIcon: IconButton(
          onPressed: () {
            _contactController.clear();
          },
          icon: Icon(Icons.clear,
              color: darkmode
                  ? Theme.Colors.secondaryColor
                  : Theme.Colors.primaryColor),
        ),
      ),
    );
  }

  Widget _googleMapInline(max) {
    return LimitedBox(
      maxWidth: 150,
      maxHeight: 250,
      child: StreamBuilder<UserData>(
          stream: blocUserData.getUserData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else
              return GoogleMapScreen(
                size: max,
                long: snapshot.data.longitude,
                lat: snapshot.data.latitude,
                address: _addressController.text,
                darkmode: darkmode,
              );
          }),
    );
  }

  ///Actualizo en el stream el resultado de mi posicion por geolocalizacion
  _getLatLong() {
    Geolocator().placemarkFromAddress(_addressController.text).then((result) {
      _userDataEditable.latitude = result[0].position.latitude;
      _userDataEditable.longitude = result[0].position.longitude;
      blocUserData.changeUserData(_userDataEditable);
    }).catchError((error) => ShowToast().show(Translations().errorAddress, 5));
  }

  Widget _buttons(max) {
    return StreamBuilder<bool>(
        stream: blocUserData.showProgress,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          if (snapshot.data)
            return Center(
                child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.Colors.primaryColor)));
          else
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 1,
//              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () => _connectionStatus ==
                            'ConnectivityResult.none'
                        ? ShowToast().show(Translations().connectionError, 5)
                        : _submitData(),
                    color: darkmode
                        ? Theme.Colors.primaryDarkColor
                        : Theme.Colors.primaryColor,
                    textColor: Theme.Colors.secondaryColor,
                    child: TextModel(
                      text: Translations.of(context).btnSave,
                      size: 15,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
//              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  ///Restore Button
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {
                      setState(() {
                        _restoreData = true;
                        showInSnackBar(Translations.of(context).restoreMsg);
                      });
                    },
                    color: darkmode
                        ? Theme.Colors.primaryDarkColor
                        : Theme.Colors.primaryColor,
                    textColor: Theme.Colors.secondaryColor,
                    child: Text(Translations.of(context).btnRestore),
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: NusachCheckWidget(
                      darkmode: darkmode,
                      size: max,
                    )),
              ],
            );
        });
  }

  void _submitData() {
    blocUserData.changeProgress(true);
//    blocUserData.getUserData.listen((data) {
//      print(data.longitude);
//    });
    blocUserData.submit(Provider.of<AppModel>(context)).then((value) {
      showInSnackBar(Translations.of(context).saveMsg);
      blocUserData.changeProgress(false);
    }).catchError(_catchError);
  }

  _catchError() {
    blocUserData.changeProgress(false);
    showInSnackBar(Translations.of(context).connectionError);
  }

  ///Popup menu
  _fillPopupData() {
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

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: TextModel(
        text: value,
        color: Theme.Colors.secondaryColor,
      ),
      backgroundColor:
          darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
    ));
  }
}
