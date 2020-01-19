import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/resources/repository.dart';
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

class GoogleMapBloc{

  final _repository = Repository();

  //All markers
  final _marker = BehaviorSubject<Map<MarkerId, Marker>>();
  Observable<Map<MarkerId, Marker>> get getMarkes => _marker.stream;
  Function(Map<MarkerId, Marker>) get addMarkers => _marker.sink.add;

  loc.Location location = loc.Location();
  GeolocationStatus geolocationStatus;

  Position position;

  String tfilaName;

  BuildContext screenContext;

  List<MarkerNow> listNow = List();
  MarkerNow markerNow = new MarkerNow();

  //Get minyan now
  final _nowMark = BehaviorSubject<List<MarkerNow>>();
  Observable<List<MarkerNow>> get getNowMarkes => _nowMark.stream;
  Function(List<MarkerNow>) get addNowMarkers => _nowMark.sink.add;




  Future<void> goToLocation(latitude, longitude, _controller, double zoom) async{
    try {
      geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: zoom),
        ),
      );
    } catch (e) {
      position = null;
    }
  }

  getNow(List<MarkerId> markIdList, Map<MarkerId, Marker> markers, context) async{
    screenContext = context;
    listNow.clear();
    try{
      await requestLocationPermission();
      Position _myPos = await _getUserLocation();
      //Recorro los markers
      for(var i=0; i<markIdList.length; i++){
        //Obtengo los horarios
        ///TODO no deberia estar aca porque llama mucho a firestore
        final data = await _repository.getMarkerDetails(markIdList[i].value);
        await Geolocator().distanceBetween(_myPos.latitude, _myPos.longitude, markers[markIdList[i]].position.latitude, markers[markIdList[i]].position.longitude)
            .then((calDist) {
              //Chequeo si el marker esta a menos de 500 metros
          if((calDist / 1000) < (500 * 0.001)) {
            _createMarkerNow(markIdList[i].value, markers[markIdList[i]], data);
          }
        });
      }
      Future.delayed(Duration(seconds: 3));
      if(listNow.isNotEmpty){
        //Agrego el listado en el stream
        addNowMarkers(listNow);
      }
      else{
        listNow.clear();
        addNowMarkers(listNow);
        tfilaName = '';
      }
      return tfilaName;
    }catch(e){
      print(e);
    }
  }

   _createMarkerNow(String id, Marker mark, data) async{
    try{
      //Obtengo el horario formato string
      final time = _getNowTime(data.documents);
      if(time != null && time != ''){
        markerNow.id = id;
        markerNow.title = mark.infoWindow.title;
        markerNow.latitude = mark.position.latitude;
        markerNow.longitude = mark.position.longitude;
        markerNow.times = time;
        //Lo agrego en el listado
        listNow.add(markerNow);
      }
    }catch (e){
      print(e);
    }
  }

  //Devuelve la hora de la tefila
  String _getNowTime(doc) {
    String time;
    for(var i=0; i<doc.length; i++) {
      //Convierte el weekday de numero a nombre del dia
      if(doc[i].documentID == convertData.getWeekDayToString(DateTime.now().weekday)) {
        if(doc[i].data[FS.shajarit].isNotEmpty && (time == '' || time == null)){
          time = _addTimeList(doc[i].data[FS.shajarit]);
          tfilaName = Translations.of(screenContext).shajaritTitle;
        }
        if(doc[i].data[FS.minja].isNotEmpty && (time == '' || time == null)){
          time = _addTimeList(doc[i].data[FS.minja]);
          tfilaName = Translations.of(screenContext).minjaTitle;
        }
        if(doc[i].data[FS.arvit].isNotEmpty && (time == '' || time == null)){
          time = _addTimeList(doc[i].data[FS.arvit]);
          tfilaName = Translations.of(screenContext).arvitTitle;
        }
      }
    }
    return time;
  }

  //Metodo que controla la diferencia de horario y se fija cual es el proximo minian, sino encuentra devuelve vacio al streambuilder
  _addTimeList(List doc){
    for(var time in doc){
      final timeServer = DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);

      var serverParsed = NotificationLogic().getParsedTime(time, 1);
      var nowParsed = NotificationLogic().getParsedTime(time, 2);

      //Controlo que la diferencia sea de 30 minutos
      if(nowParsed.difference(serverParsed).inMinutes < 30 && nowParsed.difference(serverParsed).inMinutes > -30){
        return DateFormat('hh:mm').format(timeServer);
      }
      return '';
    }
  }

  _getUserLocation() async{
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }


  Future requestLocationPermission() async{
    location.requestPermission().then((granted){
      location.onLocationChanged().listen((data){
      });
    });
  }

  void dispose() async {
    await _marker.drain();
    _marker.close();
    await _nowMark.drain();
    _nowMark.close();
  }
}

final blocMap = GoogleMapBloc();