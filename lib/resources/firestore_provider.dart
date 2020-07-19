import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_minyan/utils/utils.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  ///Device information
  Future<void> saveToken(String token) async {
    var tokens = _firestore.collection(FS.user).document(token);
    await tokens.setData({
      'token': token,
      'created': FieldValue.serverTimestamp(), // optional
      'platform': Platform.operatingSystem,
      'localename': Platform.localeName, // optional
      'version': Platform.version,
      'osversion': Platform.operatingSystemVersion,
    });
  }

  Future<void> saveData(String documentId, String title, String address,
      String contact, double lat, double lon, List nusach) async {
    await _firestore.collection(FS.markers).document(documentId).updateData({
      FS.title: title,
      FS.address: address,
      FS.contact: contact,
      FS.location: GeoPoint(lat, lon),
      FS.nusach: nusach,
    });
  }

  Future<void> authenticateUser(String documentId, value) async {
    await _firestore
        .collection(FS.markers)
        .document(documentId)
        .updateData({FS.isAuthenticated: value});
  }

  Future<QuerySnapshot> isAuthenticated(String email) {
    return _firestore
        .collection(FS.markers)
        .where(FS.email, isEqualTo: email)
        .getDocuments();
  }

  Future<QuerySnapshot> userExist(String email) {
    return _firestore
        .collection(FS.markers)
        .where(FS.email, isEqualTo: email)
        .getDocuments();
  }

  ///Agrego items en el arreglo
  ///Lo importante en este codigo, que primero obtengo los document que cumplan la condicion que sea del dia especifico
  ///Sabido que devuelve un solo documento, tomo el ID y lo paso para agregar los datos ahi
  Future<void> saveNewTime(String documentID, String day, String pray,
      DateTime time, String dayDocumentId) async {
    await _firestore
        .collection(FS.markers)
        .document(documentID)
        .collection(FS.schedule)
        .where(FS.name, isEqualTo: day)
        .getDocuments()
        .then((doc) => _firestore
                .collection(FS.markers)
                .document(documentID)
                .collection(FS.schedule)
                .document(doc.documents[0].documentID)
                .updateData({
              pray: FieldValue.arrayUnion([time]),
            }));
  }

  ///Para crear las tablas
//  _getMap(String day, int value){
//    Map<String, dynamic> schedule = new Map<String, dynamic>();
//    schedule[FS.shajarit] = [];
//    schedule[FS.minja] = [];
//    schedule[FS.arvit] = [];
//    schedule[FS.name] = day;
//    schedule[FS.value] = value;
//    return schedule;
//  }

  ///Agrego un nuevo documento
//  Future<void> saveNewDocument(String userUID) async {
//
//    Map<String, dynamic> userDoc = new Map<String, dynamic>();
//    userDoc[FS.address] = '';
//    userDoc[FS.contact] = '';
//    userDoc[FS.location] = GeoPoint(0, 0);
//    userDoc[FS.title] = '';
////    userDoc[FS.userUID] = userUID;
//    userDoc[FS.nusach] = [];
//
//    ///Creo el documento con los datos
//    var first = _firestore.collection(FS.markers).document(userUID);
//    await first.setData(userDoc);
//    for(var i =0; i<7; i++){
//      String day = _getDay(i);
//      await first.collection(FS.schedule).document(day).setData(_getMap(day, i));
//    }
//  }

  Future<void> deleteTime(String documentId, String day, String pray,
      Timestamp time, String dayDocumentId) async {
    await _firestore
        .collection(FS.markers)
        .document(documentId)
        .collection(FS.schedule)
        .document(dayDocumentId)
        .updateData({
      pray: FieldValue.arrayRemove([time])
    });
  }

  Future<void> deleteUser(String documentId) async {
    await _firestore.collection(FS.markers).document(documentId).delete();
  }

  ///Get user data
  Stream<DocumentSnapshot> userData(String userUID) {
    return _firestore.collection(FS.markers).document(userUID).snapshots();
  }

//  Stream<QuerySnapshot> getDayTimes(String documentId, String day) {
//    return _firestore.collection(FS.markers)
//        .document(documentId)
//        .collection(FS.schedule).where('name', isEqualTo: day).snapshots();
//  }

  ///To show in admin time screen
  Stream<QuerySnapshot> getAllSchedule(String documentId) {
    return _firestore
        .collection(FS.markers)
        .document(documentId)
        .collection(FS.schedule)
        .snapshots();
  }

  Stream<QuerySnapshot> getNusachList() {
    return _firestore.collection(FS.nusach).snapshots();
  }

  ///Get user rights, if is admin or just a user
  Stream<DocumentSnapshot> getUserAdmin() {
    return _firestore.collection(FS.root).document(FS.rootUser).snapshots();
  }

  Future<QuerySnapshot> getAllMarkers() {
    return _firestore.collection(FS.markers).getDocuments();
  }

  //Traer los marker para el ROOT
  Future<QuerySnapshot> getMarkersAuth() {
    return _firestore.collection(FS.markers).getDocuments();
  }

  Future<QuerySnapshot> getMarkerDetails(String markID) {
    return _firestore
        .collection(FS.markers)
        .document(markID)
        .collection(FS.schedule)
        .getDocuments();
  }

  ///Get data to verify push notification
  Stream<QuerySnapshot> getPushNotification(String documentId, String day) {
    return _firestore
        .collection(FS.markers)
        .document(documentId)
        .collection(FS.schedule)
        .where(FS.name, isEqualTo: day)
        .where('value', isLessThan: 6)
        .snapshots();
  }

  Stream<DocumentSnapshot> getPlaceName(String documentId) {
    return _firestore.collection(FS.markers).document(documentId).snapshots();
  }
}
