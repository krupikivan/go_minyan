import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/resources/images.dart';
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/widget/popup_menu.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import 'bloc/push_noti_bloc.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => new _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final FirebaseMessaging _messaging = FirebaseMessaging();

  ///Los valores que me permitiran mostrar el push
  PushData newPush;

  ///Testing push notification every 30 sec
  Timer timer;

  ///FLUTTER LCOAL NOTIFICATION-----------------------------
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//  StreamSubscription<DocumentSnapshot> subscription;
//  StreamSubscription<QuerySnapshot> subs;

  ///Bottom navigation
  int _currentIndex;

  ///POPUP menu
  static String login;
  static String settings;
  static String exit;
  List<Items> choices;

  @override
  void initState() {
    super.initState();

    //COnfigura el mensaje de la push notification DE Firebase
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(Translations.of(context).ok),
                onPressed: Navigator.of(context).pop,
              )
            ],
          ),
        );
      },
      onResume: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {},
    );
    _messaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _currentIndex = 0;

    ///TODO habilitarlo
//    _saveDeviceToken();

    ///Este metodo me ejecuta el push notification cada 30 segundos
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) {
      ///Este metodo espera que getPushNotification de la clase noti termine y retorna o null o el pushData
      ///y luego cuando ya tiene ese valor entonces ahi llama setPushData y le manda o null o los datos
      ///para la notificacion funcionando en Foreground
      noti.getPushNotification().then((pushData) {
        _setPushData(pushData);
      });
    });

    ///FLUTTER LCOAL NOTIFICATION-----------------------------
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
//    subscription.cancel();
//    subs.cancel();
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        String title = Translations.of(context).remember;
        return new AlertDialog(
          title: Text("$title"),
          content:
              Text("${this.newPush.place} - ${this.newPush.pray} : $payload"),
        );
      },
    );
  }

  ///FLUTTER LCOAL NOTIFICATION-----------------------------
  Future _showNotificationWithDefaultSound(PushData pushData) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channel_id', 'channel_name', 'channel_description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      Translations.of(context).pushTitle,
      '${pushData.place} - ${pushData.pray} - ${pushData.timeString}',
      platformChannelSpecifics,
      payload: '${pushData.timeString}',
    );
  }

  ///Set push notification data to show
  _setPushData(PushData pushData) {
    if (pushData != null) {
      this.newPush = pushData;
      newPush.pray = convertData.getTranslationFromFS(pushData.pray, context);
      newPush.timeString = convertData
          .timestampToString(pushData.timeToPush.millisecondsSinceEpoch);
      _showNotificationWithDefaultSound(pushData);
    } else {}
  }

//   /Device information
//  _saveDeviceToken() async{
//    await _messaging.getToken().then((token){
//      repos.saveToken(token);
//    });
//  }

  @override
  Widget build(BuildContext context) {
//    pushData != null ? _setPushData(pushData) : null;
    ///Cargamos las shared preferences
    noti.setPrefs(Provider.of<AppModel>(context).instance);
    _fillPopupData();
    return StreamBuilder<PushData>(
        stream: blocPush.readPush,
        builder: (context, snapshot) {
          //Si hay un push lo ejecuta aca, controla que no haya salido el push
          if (snapshot.hasData && snapshot.data.wasPushed == false) {
//             _setPushData(snapshot.data);
            //Cambio el flag para que no vuelva a notificar
//             blocPush.changeFlag(true);
          }
          return Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.backImg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(100), // here th
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    centerTitle: true,
                    actions: <Widget>[
                      PopupMenu(choices: choices, type: 'menu'),
                    ],
                  ),
                ),
                body: Center(
                  child: Image.asset(
                    Images.logoImg,
                    color: Theme.Colors.secondaryColor,
                    height: 300,
                    width: 300,
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    onTap: onTabTapped,
                    currentIndex: _currentIndex,
                    backgroundColor: Colors.transparent,
                    selectedItemColor: Theme.Colors.secondaryColor,
                    unselectedItemColor: Theme.Colors.secondaryColor,
                    selectedLabelStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: Theme.Fonts.primaryFont,
                        color: Theme.Colors.primaryColor),
                    unselectedLabelStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: Theme.Fonts.primaryFont,
                        color: Theme.Colors.primaryColor),
                    items: [
                      BottomNavigationBarItem(
                        icon: new Icon(Icons.home),
                        title: Text(Translations.of(context).minianTitle),
                      ),
                      BottomNavigationBarItem(
                        icon: new Icon(Icons.add),
                        title: Text(Translations.of(context).newMinyan),
                      ),
                      BottomNavigationBarItem(
                        icon: new Icon(Icons.info),
                        title: Text(Translations.of(context).about),
                      ),
                    ]),
              ),
            ),
          );
        });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      Navigator.pushNamed(context, '/minian');
    }
    if (index == 1) {
      Navigator.pushNamed(context, '/info');
    }
  }

  ///PUPUP menu
  _fillPopupData() {
    login = Translations.of(context).loginItem;
    settings = Translations.of(context).settings;
    exit = Translations.of(context).logOut;
    choices = <Items>[
      Items(Text(login, style: TextStyle(fontFamily: Theme.Fonts.primaryFont)),
          Icon(Icons.account_circle)),
      Items(
          Text(settings, style: TextStyle(fontFamily: Theme.Fonts.primaryFont)),
          Icon(Icons.settings)),
      Items(Text(exit, style: TextStyle(fontFamily: Theme.Fonts.primaryFont)),
          Icon(Icons.exit_to_app)),
    ];
  }
}
