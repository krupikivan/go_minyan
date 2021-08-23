import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/resources/repository.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationLogic{

  SharedPreferences _prefs;
  Timestamp timeToPush;
  // ignore: cancel_subscriptions
  StreamSubscription<DocumentSnapshot> subscription;
  // ignore: cancel_subscriptions
  StreamSubscription<QuerySnapshot> subs;
  List<String> list = new List();
  PushData newPush;
  void setPrefs(value){
    _prefs = value;
  }


  //Parsea el horario para comparar la diferencia horaria en minutos
  getParsedTime(Timestamp time, int nowServer){
    DateTime timeNow = DateTime.now();
    final timeServer = DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    String stringTime;

    if(nowServer == 1) stringTime = DateFormat("HH:mm:ss").format(timeServer); //Parsea el time del servidor minian
    else stringTime = DateFormat("HH:mm:ss").format(timeNow);      //Parsea el time now

    //Estos 3 es solo por formato
    var tY = timeServer.year;
    var tM = DateFormat('MM').format(timeNow);
    var tD = DateFormat('dd').format(timeNow);

    return DateTime.parse('$tY-$tM-$tD $stringTime');
  }

  //Diferencia de 15 minutos o menos entre la hora actual y la que esta en Firestore
  bool getDifference(List timestamp, int value){
    //Recorremos la lista de Timestamp y vemos cual cumple la condicion
      for(var i=0; i<timestamp.length; i++){
        var time = timestamp[i];
        var serverParsed = getParsedTime(time, 1);
        var nowParsed = getParsedTime(time, 2);

      if(-nowParsed.difference(serverParsed).inMinutes+1 == value){
        newPush = PushData();
        newPush.timeToPush = time;//Aca asignamos el horario de push
        return true;
      }
    }
    return false;
  }

  ///El primer metodo que hace desde el menu_screen
  getPushNotification() async {
    try {
      list = await getDocAllowsNotifications();   //Busco el documentId dentro del listado guardado en shared preferences
      var remind = await getReminderValue();      //Traigo el valor guardado de recordatorio de notificacion
      int value = int.parse(remind);
      if (list.isEmpty) {
        newPush = null;//Si no hay tildada notificacion termina y no sigue
        return newPush;
    }
      else {
        for (String doc in list) {
          bool isSwitch = await getSwitchOnOff(doc);
          if (!isSwitch) {
            return null;
          }
          else {
            String title;
            subscription = repos.getPlaceName(doc).listen((newSnapshot) =>
            title = newSnapshot.data['title']);
            subs =
                repos.getPushNotification(
                    doc, convertData.getWeekDayToString(DateTime
                    .now().weekday)).listen((snapshot) {
                  if (snapshot.documents.isNotEmpty) {
                    ///snapshot.documents[0][FS.shajarit] es una lista de timestamp
                    if (getDifference(
                        snapshot.documents[0][FS.shajarit], value)) {
                      newPush.pray = FS.shajarit;
                      newPush.place = title;
                    }
                    else if (getDifference(
                        snapshot.documents[0][FS.minja], value)) {
                      newPush.pray = FS.minja;
                      newPush.place = title;
                    }
                    else if (getDifference(
                        snapshot.documents[0][FS.arvit], value)) {
                      newPush.pray = FS.arvit;
                      newPush.place = title;
                    }
                    else{
                      newPush = null;
                    }
                  }else{
                    newPush = null;
                    return newPush;
                  }
                  newPush == null ? print('Nada que pushear') : print(convertData.timestampToString(newPush.timeToPush.millisecondsSinceEpoch));
                  if(newPush != null) {
                  return newPush;
                  }else{
                    newPush = null;
                    return newPush;
                  }
                }
                );
            return newPush;
          }
        }
        return newPush;
      }
    } catch (e) {
      print(e);
    }
  }

  ///Recibo el documenId donde quiero recibir notificaciones
  Future<List<String>> getDocAllowsNotifications() async {
    return _prefs.getStringList(PrefsString.notification) ?? [];
  }
  ///Recupero el recordatorio de notificacion cargado en settings
  Future<String> getReminderValue() async {
    String value =  _prefs.getString('reminder') ?? "10";
    return value;
  }
  ///Recibo el valor del switch true or false
  Future<bool> getSwitchOnOff(String documentId) async {
    return _prefs.getBool(documentId) ?? false;
  }


}

final noti = NotificationLogic();