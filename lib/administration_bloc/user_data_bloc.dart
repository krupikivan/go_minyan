import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_minyan/administration_bloc/times_bloc.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/resources/repository.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

import '../model/app_model.dart';
export 'package:go_minyan/utils/utils.dart';

class UserDataBloc {
  final _repository = Repository();
  AppModel appModel = AppModel();
  final _userData = BehaviorSubject<UserData>();

  //Este stream es para manejar si se guardo o no
  final _showProgress = BehaviorSubject<bool>.seeded(false);

  ///Progress
  Observable<bool> get showProgress => _showProgress.stream;
  Function(bool) get changeProgress => _showProgress.sink.add;

  ///UserData
  Observable<UserData> get getUserData => _userData.stream;
  Function(UserData) get changeUserData => _userData.sink.add;

  Future submit(AppModel appModel) async {
    await _repository.saveData(
        _userData.value.documentId,
        _userData.value.title,
        _userData.value.address,
        _userData.value.contact,
        _userData.value.latitude,
        _userData.value.longitude,
        _userData.value.nusach);
    appModel.saveUserData(_userData.value);
  }

  ///Get data from user logged in
//  Stream<DocumentSnapshot> userData(String userUID) {
//    return _repository.userData(userUID);
//  }

  //Get userdata from firestore if our bloc is empty
  getUserDataFromFirebase(String userUID) {
    if (appModel.userData.title != null) {
      //FIRST TIME logged in
      _repository.userData(userUID).listen((snapshot) {
        //Creamos el doc
        DocumentSnapshot doc = snapshot;
        //Save into shared prefs
        appModel.saveUserData(_getNewUserData(doc));
        //add to bloc stream
        changeUserData(appModel.userData);
        //add times data to blocTimes
        // _repository.getAllSchedule(doc.documentID).listen((docTime) {
        // blocTimes.addDoc(docTime);
        blocTimes.createSchedule(doc);
        // });
      });
    } else {
      //If login was saved
      changeUserData(appModel.userData);
      blocTimes.addScheduleList(appModel.scheduleList);
    }
  }

  UserData _getNewUserData(DocumentSnapshot doc) {
    UserData _newUserData = UserData();
    _newUserData.title = doc[FS.title];
    _newUserData.address = doc[FS.address];
    _newUserData.contact = doc[FS.contact];
    _newUserData.latitude = doc[FS.location].latitude;
    _newUserData.longitude = doc[FS.location].longitude;
    _newUserData.nusach = doc[FS.nusach].cast<String>();
    _newUserData.documentId = doc.documentID;
    return _newUserData;
  }

  ///Get user rights, if is admin or just a user
  Stream<DocumentSnapshot> getUserAdmin() {
    return _repository.getUserAdmin();
  }

  void dispose() async {
    await _userData.drain();
    _userData.close();
    _showProgress.close();
  }
}

final blocUserData = UserDataBloc();
