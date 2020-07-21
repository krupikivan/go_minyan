import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/resources/repository.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationLogic {
  // SharedPreferences _prefs;
  final appModel = AppModel();
  Timestamp globalTime;
  // ignore: cancel_subscriptions

  MarkerData markerSubs;
  // ignore: cancel_subscriptions
  List<String> list = new List();
  PushData newPush;

  //Parsea el horario para comparar la diferencia horaria en minutos
  getParsedTime(Timestamp time, int nowServer) {
    DateTime timeNow = DateTime.now();
    final timeServer =
        DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    String stringTime;

    if (nowServer == 1)
      stringTime = DateFormat("HH:mm:ss")
          .format(timeServer); //Parsea el time del servidor minian
    else
      stringTime = DateFormat("HH:mm:ss").format(timeNow); //Parsea el time now

    //Estos 3 es solo por formato
    var tY = timeServer.year;
    var tM = DateFormat('MM').format(timeNow);
    var tD = DateFormat('dd').format(timeNow);

    return DateTime.parse('$tY-$tM-$tD $stringTime');
  }

  //Diferencia de 15 minutos o menos entre la hora actual y la que esta en Firestore
  bool getDifference(List timestamp, int value) {
    //Recorremos la lista de Timestamp y vemos cual cumple la condicion
    for (var i = 0; i < timestamp.length; i++) {
      var time = timestamp[i];
      var serverParsed = getParsedTime(time, 1);
      var nowParsed = getParsedTime(time, 2);
      if (-nowParsed.difference(serverParsed).inMinutes + 1 <= value) {
        globalTime = time; //Aca asignamos el horario de push
        return true;
      }
    }
    return false;
  }

  PushData getPushNoti(MarkerData data, int cant) {
    String today = convertData.getWeekDayToString(DateTime.now().weekday);
    PushData push = PushData();
    push.place = data.title;
    data.schedule[today].forEach((key, value) {
      if (getDifference(value, cant)) {
        push.pray = key;
        push.timeToPush = globalTime;
      }
    });
    globalTime = null;
    return push;
  }

  ///El primer metodo que hace desde el menu_screen
  getPushNotification() async {
    try {
      list =
          await getDocAllowsNotifications(); //Busco el documentId dentro del listado guardado en shared preferences
      var remind =
          await getReminderValue(); //Traigo el valor guardado de recordatorio de notificacion
      int value = int.parse(remind);
      if (list.isEmpty) {
        newPush = null; //Si no hay tildada notificacion termina y no sigue
        return newPush;
      } else {
        for (String doc in list) {
          bool isSwitch = await getSwitchOnOff(doc);
          if (!isSwitch) {
            return null;
          } else {
            markerSubs = appModel.markersList
                .firstWhere((element) => element.documentID == doc);
            newPush = getPushNoti(markerSubs, value);
            if (newPush.timeToPush != null) {
              return newPush;
            } else {
              newPush = null;
              return newPush;
            }
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
    return appModel.instance.getStringList(PrefsString.notification) ?? [];
  }

  ///Recupero el recordatorio de notificacion cargado en settings
  Future<String> getReminderValue() async {
    String value = appModel.instance.getString('reminder') ?? "10";
    return value;
  }

  ///Recibo el valor del switch true or false
  Future<bool> getSwitchOnOff(String documentId) async {
    return appModel.instance.getBool(documentId) ?? false;
  }
}

final noti = NotificationLogic();
