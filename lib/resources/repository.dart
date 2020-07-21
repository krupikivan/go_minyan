import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_minyan/resources/firestore_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();

  Future<void> saveData(String documentId, String title, String address,
          String contact, double lat, double lon, List nusach) =>
      _firestoreProvider.saveData(
          documentId, title, address, contact, lat, lon, nusach);

  Future<void> authenticateUser(String documentId, value) =>
      _firestoreProvider.authenticateUser(documentId, value);

  Future<void> deleteUser(String documentId) =>
      _firestoreProvider.deleteUser(documentId);

  Future<void> saveNewTime(String documentID, String day, String pray,
          DateTime time, String dayDocumentId) =>
      _firestoreProvider.saveNewTime(
          documentID, day, pray, time, dayDocumentId);

  ///Device information - menu-screen
  Future<void> saveToken(String token) => _firestoreProvider.saveToken(token);

  Future<DocumentSnapshot> isAuthenticated(String email) =>
      _firestoreProvider.isAuthenticated(email);

  Future<QuerySnapshot> userExist(String email) =>
      _firestoreProvider.userExist(email);

  Future<void> deleteTime(String documentId, String day, String pray,
          Timestamp time, String dayDocumentId) =>
      _firestoreProvider.deleteTime(documentId, day, pray, time, dayDocumentId);

  Stream<DocumentSnapshot> getUserAdmin() => _firestoreProvider.getUserAdmin();

  Stream<DocumentSnapshot> userData(String userUID) =>
      _firestoreProvider.userData(userUID);

  //Nusach cargados en Firestore
  Stream<QuerySnapshot> getNusachList() => _firestoreProvider.getNusachList();

  //Get data specific times
//  Stream<QuerySnapshot> getDayTimes(String documentId, String day) =>
//      _firestoreProvider.getDayTimes(documentId, day);

  //Get all schedule time
  Stream<QuerySnapshot> getAllSchedule(String documentId) =>
      _firestoreProvider.getAllSchedule(documentId);

  //Get all Documents to show on Google Map
  Future<QuerySnapshot> getAllMarkers() => _firestoreProvider.getAllMarkers();

  //Get all Documents to show on Google Map
  Future<QuerySnapshot> getMarkersAuth() => _firestoreProvider.getMarkersAuth();

  //Get all Documents to show on Google Map
  Future<QuerySnapshot> getMarkerDetails(String markID) =>
      _firestoreProvider.getMarkerDetails(markID);

  //Get data to verify push notification
  Stream<QuerySnapshot> getPushNotification(String documentId, String day) =>
      _firestoreProvider.getPushNotification(documentId, day);

  Stream<DocumentSnapshot> getPlaceName(String documentId) =>
      _firestoreProvider.getPlaceName(documentId);

  Future<void> complete() => _firestoreProvider.complete();

  Future<DocumentSnapshot> assignIsUser(String uid) =>
      _firestoreProvider.assignIsUser(uid);
}

final repos = Repository();
