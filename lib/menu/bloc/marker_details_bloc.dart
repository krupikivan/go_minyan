import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/resources/repository.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class MarkerBloc {
  final _repository = Repository();

  //Our local Stream
//  final _documentData = BehaviorSubject<QuerySnapshot>();
//  final _documentSelected = BehaviorSubject<DocumentSnapshot>();

  //To listen documents collection
  final _documentSchedule = BehaviorSubject<QuerySnapshot>();
  Observable<QuerySnapshot> get documentSchedule => _documentSchedule.stream;

  final _markerList = BehaviorSubject<List<MarkerData>>();
  Observable<List<MarkerData>> get getMarkerList => _markerList.stream;
  Function(List<MarkerData>) get addMarkerList => _markerList.sink.add;

  final _markerSelected = BehaviorSubject<MarkerData>();
  Observable<MarkerData> get markerSelected => _markerSelected.stream;
  Function(MarkerData) get addmarkerSelected => _markerSelected.sink.add;

  //To listen documents data
//  Observable<QuerySnapshot> get documentData => _documentData.stream;
//  Observable<DocumentSnapshot> get documentSelected => _documentSelected.stream;
//  Function(DocumentSnapshot) get addDocumentSelected => _documentSelected.sink.add;




  //Get markers from firestore if our bloc is empty
  getMarkerDataFromFirebase(AppModel appModel) {
    if( appModel.markersList.isEmpty)
      //Get from firebase
      _repository.getAllMarkers().then((snapshot){
        List<MarkerData> listMarker = List();
        for(var i=0; i<snapshot.documents.length; i++){
            DocumentSnapshot doc = snapshot.documents[i];
            ///Esto soluciona cuando hay markers recien creados y no tiene ubicacion fija
            ///por lo que generaba un error al mostrar en el mapa
          if(doc.data[FS.location].latitude != 0 && doc.data[FS.location].longitude != 0){
            MarkerData marker = new MarkerData();
            marker.title = doc.data[FS.title];
            marker.address = doc.data[FS.address];
            marker.contact = doc.data[FS.contact];
            marker.latitude = doc.data[FS.location].latitude;
            marker.longitude = doc.data[FS.location].longitude;
            marker.userUID = doc.data[FS.userUID];
            marker.documentID = doc.documentID;
            marker.nusach = doc.data[FS.nusach];
            listMarker.add(marker);
          }else{}
        }
        //Create json string from marker list
        String jsonString = json.encode(listadoMarkerToJson(listMarker));
        //Save into shared prefs
        appModel.saveMarkersData(jsonString, listMarker);
        //add to bloc stream
        addMarkerList(appModel.markersList);
      }).catchError((onError) => addMarkerList([]));
    else {
      //Nunca entra porque no solamente ejecuta este metodo cuando se inicia la primera vez.
      //Mientras la aplicacion este en background este metdo no se actualiza solamente cuando se cierra por completo
      //y se vuelve abrir.
      //If was saved before
//      appModel.getMarkersData();
      addMarkerList(appModel.markersList);
    }
  }

  //Our method we called into init state
//  getAllMarkers() async{
//    QuerySnapshot querySnapshot = await _repository.getAllMarkers();
//    //After retrieve all documents, we sink into the pipe (stream)
//    _documentData.sink.add(querySnapshot);
//  }

  //Trae de firebase los horarios
  getMarkerDetails(String documentID) async{
    QuerySnapshot querySnapshot = await _repository.getMarkerDetails(documentID);
    //After retrieve all documents, we sink into the pipe (stream)
    _documentSchedule.sink.add(querySnapshot);
  }

  void dispose() async {
//    await _documentData.drain();
//    _documentData.close();
//    await _documentSelected.drain();
//    _documentSelected.close();
    await _documentSchedule.drain();
    _documentSchedule.close();
    await _markerList.drain();
    _markerList.close();
    await _markerSelected.drain();
    _markerSelected.close();
  }
}

//Manejamos para traer los listados del cliente
final blocMarker = MarkerBloc();