import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_minyan/menu/bloc/google_map_bloc.dart';
import 'package:go_minyan/menu/bloc/marker_details_bloc.dart';
import 'package:go_minyan/menu/marker_detail_screen.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/widget/widget.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

class GoogleMapWidget extends StatefulWidget {

  final BuildContext context;
  final Completer<GoogleMapController> controller;
  final MapType currentMapType;
  final BitmapDescriptor myIcon;
  final Map<MarkerId, Marker> markers;
  final List<MarkerId> markIdList;
  final LatLng initialPosition;
  GoogleMapWidget({Key key, this.context, this.controller, this.currentMapType, this.myIcon, this.markers, this.markIdList, this.initialPosition}) : super(key: key);

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();

  static final CameraPosition _center = CameraPosition(
    target: LatLng(-34.584084,-58.4326866),
    zoom: 12,
  );
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {

  Connectivity connectivity;
  var _connectionStatus;
  StreamSubscription<ConnectivityResult> suscription;

  @override
  void initState() {
    super.initState();
    connectivity = new Connectivity();
    suscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result){
      _connectionStatus = result.toString();
    });
  }



  @override
  void dispose() {
    suscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, model, child) =>
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
//            child: StreamBuilder<QuerySnapshot>(
            child: StreamBuilder<List<MarkerData>>(
              //Escucho los markers cargados en google_map_screen.dart
//                stream: blocMarker.documentData,
                stream: blocMarker.getMarkerList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: TextModel(text: Translations.of(context).mapLoading, color: model.darkmode ? Theme.Colors.secondaryColor : Theme.Colors.blackColor,));
                  }
                  else if(snapshot.data.length == 0){
                    return Center(child: TextModel(text: Translations.of(context).errorDialog, color: model.darkmode ? Theme.Colors.secondaryColor : Theme.Colors.blackColor,));
                  }
                  else {
                    //Reseteamos los marker sino se van sumando cada vez que se actualiza el estado
                    widget.markIdList.clear();
//                    for (int i = 0; i < snapshot.data.documents.length; i++) {
                    for (int i = 0; i < snapshot.data.length; i++) {
                      final MarkerId docID = MarkerId(
//                          snapshot.data.documents[i].documentID);
                          snapshot.data[i].documentID);
                      widget.markIdList.add(docID);
                      final Marker marker = Marker(
                        icon: widget.myIcon,
//                        infoWindow: InfoWindow(title: snapshot.data.documents[i].data[FS.title]),
                        infoWindow: InfoWindow(title: snapshot.data[i].title),
                        markerId: docID,
                        position: LatLng(
//                            snapshot.data.documents[i].data[FS.location]
                            snapshot.data[i].latitude,
//                            snapshot.data.documents[i].data[FS.location]
                            snapshot.data[i].longitude),
                        onTap: () {
                          ///Con esto cargo el switch antes de entrar al marker
//                          model.getSwitch(snapshot.data.documents[i].documentID);
                          model.getSwitch(snapshot.data[i].documentID);
                          ///Cargo en bloc el documentId del marker seleccionado
//                          blocMarker.addDocumentSelected(snapshot.data.documents[i]);
                          blocMarker.addmarkerSelected(snapshot.data[i]);
                          Navigator.push(context, MaterialPageRoute(
//                              builder: (context) => MarkerDetailScreen(documentId: snapshot.data.documents[i].documentID,)));
                              builder: (context) => MarkerDetailScreen(documentId: snapshot.data[i].documentID,)));
                        },
                      );
                      widget.markers[docID] = marker;
                    }
                    blocMap.addMarkers(widget.markers);
                    return _googleMap();
                  }
                }
            ),
          ),
    );
  }

  Widget _googleMap(){
    return StreamBuilder<Map<MarkerId, Marker>>(
        stream: blocMap.getMarkes,
        builder: (context, snapshot) {
          if(!snapshot.hasData){return Center(child: Text(Translations.of(context).mapLoading));}
          else if(_connectionStatus == 'ConnectivityResult.none'){
            return _errorMsg();
          }
          else{
            return _mapWidget(snapshot);
          }
        }
    );
  }

  Widget _errorMsg(){
   return Center(child: TextModel(text: Translations.of(widget.context).connectionError, size: 20, color: Theme.Colors.blackColor,));
  }

  Widget _mapWidget(snapshot){
    return GoogleMap(
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: false,
      compassEnabled: true,
      mapType: widget.currentMapType,
      initialCameraPosition: CameraPosition(
        target: widget.initialPosition != null ? widget.initialPosition : LatLng(-34.584084,-58.4326866),
        zoom: widget.initialPosition != null ? 14.4746 : 12,
      ),//blocMap.takeLocation(widget.controller),//GoogleMapWidget._center,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(snapshot.data.values),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    this.widget.controller.complete(controller);
  }
}
