import 'package:flutter/material.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel with ChangeNotifier {
  SharedPreferences instance;

  static final AppModel _instancia = new AppModel._internal();

  factory AppModel() {
    return _instancia;
  }

  AppModel._internal();

  ///Inicializar los valores del SHARED PREFS
  void initializeValues() async {
    instance = await SharedPreferences.getInstance();
    _language = instance.getString('language') ?? 'es';
    _reminder = instance.getString('reminder') ?? '10';
    _darkmode = instance.getBool('darkmode') ?? false;
    _appLocale = Locale(_language);
    notifyListeners();
  }

  ///Language settings----------------------------------------------------
  Locale _appLocale;
  Locale get appLocal => _appLocale ?? Locale("es");
  void changeDirection(String value) {
    _appLocale = Locale(value);
    notifyListeners();
  }

  //TODO habilitar idiomas
  List<Map<String, String>> _langList = [
    {"name": "Español", "value": "es"},
    {"name": "English", "value": "en"},
//    {"name": "עיברית", "value": "he"},
  ];
  String _language;

  List<Map<String, String>> get langList => _langList;
  String get language => _language;

  bool get isReverse {
    if (_language == 'he') return true;
    return false;
  }

  void setLanguage(String value) async {
    _language = value;
    changeDirection(value);
    instance.setString('language', _language);
    notifyListeners();
  }

//  /// Wraps [ScopedModel.of] for this [Model].
//  static AppModel of(BuildContext context) =>
//      Provider.of<AppModel>(context);

  ///---------------------------theme----------------------------------
  bool _darkmode;
  bool get darkmode => _darkmode;

  void setTheme(bool value) {
    _darkmode = value;
    instance.setBool('darkmode', _darkmode);
    notifyListeners();
  }

  ///---------------------------theme----------------------------------

  ///---------------------------notification-settings---------------------------------
  Locale _reminderLocale;
  Locale get reminderLocale => _reminderLocale ?? Locale("15");

  void changeNotification(String value) {
    _reminderLocale = Locale(value);
    notifyListeners();
  }

  String _reminder;
  String get reminder => _reminder;
  List<Map<String, String>> _minList = [
    {"name": "10", "value": "10"},
    {"name": "15", "value": "15"},
    {"name": "20", "value": "20"},
    {"name": "30", "value": "30"},
    {"name": "45", "value": "45"},
    {"name": "60", "value": "60"},
  ];
  List<Map<String, String>> get minList => _minList;

  getReminderList(String text) {
    List<Map<String, String>> minList = [
      {"name": "10 " + text, "value": "10"},
      {"name": "15 " + text, "value": "15"},
      {"name": "20 " + text, "value": "20"},
      {"name": "30 " + text, "value": "30"},
      {"name": "45 " + text, "value": "45"},
      {"name": "60 " + text, "value": "60"},
    ];
    return minList;
  }

  void setReminder(String value) async {
    _reminder = value;
    changeNotification(value);
    notifyListeners();
    instance.setString('reminder', _reminder);
  }

  ///---------------------------marker-detail---------------------------------
  bool isSwitch;
  Future<Null> getSwitch(String documentId) async {
    ///Shared preferences INSTANCE
    isSwitch = instance.getBool(documentId) ?? false;
  }

  ///Set bool data from switch with documentId as KEY
  onSwitchChanged(bool value, String documentId) async {
    List<String> list = instance.getStringList(PrefsString.notification);
    if (list == null) {
      list = new List();
    }
    if (!value) {
      isSwitch = false;
      instance.setBool(documentId, false);
      list.remove(documentId);
      instance.setStringList(PrefsString.notification, list);
    } else {
      isSwitch = true;
      instance.setBool(documentId, true);
      list.add(documentId);
      instance.setStringList(PrefsString.notification, list);
    }
  }

  ///---------------------------marker-detail---------------------------------

  ///---------------------------nusach-list-Firebase-----------------------------------

  List<String> _nusachList = List();
  List<String> get nusachList => _nusachList;

  getNusachList() {
    _nusachList = instance.getStringList('nusachList');
  }

  setNusachList(List<String> list) {
    if (_nusachList == null) {
      _nusachList = list;
      instance.setStringList('nusachList', list);
    }
  }

  ///---------------------------nusach-list-Firebase------------------------------------

  ///---------------------------FIREBASE ADMIN DATA----------------------------

  UserData _userData = UserData();
  UserData get userData => _userData;

  Future<Null> getUserData() async {
    _userData.title = instance.getString('title');
    _userData.address = instance.getString('address');
    _userData.contact = instance.getString('contact');
    _userData.latitude = instance.getDouble('latitude');
    _userData.longitude = instance.getDouble('longitude');
    _userData.nusach = instance.getStringList('nusach');
    _userData.documentId = instance.getString('documentId');
  }

  saveUserData(UserData newUserData) {
    _userData.title = newUserData.title;
    _userData.address = newUserData.address;
    _userData.contact = newUserData.contact;
    _userData.latitude = newUserData.latitude;
    _userData.longitude = newUserData.longitude;
    _userData.nusach = newUserData.nusach;
    _userData.documentId = newUserData.documentId;
    instance.setString('title', newUserData.title);
    instance.setString('address', newUserData.address);
    instance.setString('contact', newUserData.contact);
    instance.setDouble('latitude', newUserData.latitude);
    instance.setDouble('longitude', newUserData.longitude);
    instance.setStringList('nusach', newUserData.nusach);
    instance.setString('documentId', newUserData.documentId);
  }

  removeAllUserData() {
    instance.remove('title');
    instance.remove('address');
    instance.remove('contact');
    instance.remove('latitude');
    instance.remove('longitude');
    instance.remove('nusach');
    instance.remove('documentId');
    instance.remove('nusachList');
    instance.remove('scheduleList');
  }

  ///---------------------------FIREBASE ADMIN DATA---------------------------------

  ///---------------------------FIREBASE SCHEDULE DATA---------------------------------

  List<Schedule> _scheduleList = List();
  List<Schedule> get scheduleList => _scheduleList;

  saveScheduleData(String json, scheduleList) {
    _scheduleList = scheduleList;
    instance.setString('scheduleList', json);
  }

  Future<Null> getScheduleData() async {
    _scheduleList = listadoScheduleFromJson(instance.getString('scheduleList'));
  }

  ///---------------------------FIREBASE SCHEDULE DATA---------------------------------

  ///---------------------------marker-tempData---------------------------------
  //Esto lo usamos solo para tener cargados los markes del google map mientras la app esta activa
  //para no hacer tantas llamadas a firebase
  List<MarkerData> _markersList = List();
  List<MarkerData> get markersList => _markersList;

  saveMarkersData(String json, markerDataList) {
    _markersList = markerDataList;
    instance.setString('markersList', json);
  }

  //Este metodo nunca se ejecuta pero nos podria servir en un futuro
  Future<Null> getMarkersData() async {
//    if(_markersList.isNotEmpty){
    _markersList =
        listadoMarkerFromJson(instance.getString('markersList')) ?? [];
//    }
  }

  //Este metodo nunca se ejecuta pero nos podria servir en un futuro
  removeMarkerTempData() {
    if (_markersList.isNotEmpty) {
      instance.remove('markersList');
    }
  }

  ///---------------------------marker-tempData---------------------------------

  ///---------------------------update-data---------------------------------
  removeForUpdate() {
    _markersList.clear();
    instance.remove('markersList');
  }

  ///---------------------------update-data---------------------------------
}
