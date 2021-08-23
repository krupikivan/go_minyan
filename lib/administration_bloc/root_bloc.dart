import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:go_minyan/resources/repository.dart';

class RootBloc {
  List<MarkerData> _markerList = List();

  final _repo = Repository();
  final _markers = BehaviorSubject<List<MarkerData>>();

  Observable<List<MarkerData>> get listenMarker => _markers.stream;
  Function(List<MarkerData>) get addMarker => _markers.sink.add;

  //Get all nusach from firestore
  getMarkersAuth() {
    _markerList.clear();
    addMarker(_markerList);
    _repo.getMarkersAuth().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        MarkerData data = MarkerData();
        data.documentID = doc.documentID;
        data.title = doc[FS.title];
        data.isAuthenticated = doc[FS.isAuthenticated];
        data.email = doc[FS.email];
        _markerList.add(data);
      }
      addMarker(_markerList);
    });
  }

  authenticateUser(MarkerData marker) {
    bool value;
    if (marker.isAuthenticated == true) {
      value = false;
    } else {
      value = true;
    }
    _repo.authenticateUser(marker.documentID, value);
  }

  delete(MarkerData marker) {
    if (!marker.isAuthenticated) {
      _repo.deleteUser(marker.documentID).then((value) => getMarkersAuth());
    }
  }

  void dispose() async {
    await _markers.drain();
    _markers.close();
  }
}

final blocRoot = RootBloc();
