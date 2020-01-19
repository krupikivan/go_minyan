import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:go_minyan/menu/bloc/google_map_bloc.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/widget/text_model.dart';

class InputMeters extends StatefulWidget {

  final BuildContext context;
  final bool darkmode;
  final Map<MarkerId, Marker> markers;
  final List<MarkerId> markIdList;

  final Completer<GoogleMapController> controller;

  InputMeters({Key key, this.darkmode, this.markers, this.markIdList, this.context, this.controller}) : super(key: key);

  @override
  _InputMetersState createState() => _InputMetersState();
}

class _InputMetersState extends State<InputMeters> {

  loc.Location location;
  Position position;
  Map<MarkerId, Marker> filteredMark = <MarkerId, Marker>{};
  TextEditingController _meterController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _meterController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context = widget.context;
    return AlertDialog(
          title: TextModel(text: Translations.of(context).dialogNearByTitle, color: widget.darkmode ? Theme.Colors.secondaryColor : Theme.Colors.blackColor,),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    cursorColor: Theme.Colors.primaryColor,
                    autofocus: true,
                    controller: _meterController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(
                          new RegExp(r'^[\d ]{1,15}$')),
                    ],
                    decoration: new InputDecoration(
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.Colors.primaryColor)),
                      icon: Icon(Icons.directions_walk,color: Theme.Colors.primaryColor,),
                    ),
                  ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: TextModel(text: Translations.of(context).ok, color: Theme.Colors.primaryColor,),
              onPressed: () {
                if(_meterController.text.isEmpty){
                }
                else{
                  Navigator.of(context).pop();
                  filteredMark.clear();
                  _filterMarkers(context);
                }
              },
            ),
            FlatButton(
              child: TextModel(text: Translations.of(context).btnBack, color: Theme.Colors.primaryColor,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
  }

  _filterMarkers(context) async{
    Geolocator().isLocationServiceEnabled().then((value) {
      if(value){
        _filterMarkersNow(context);
      }else{
        blocMap.requestLocationPermission().then(_filterMarkersNow(context));
      }
    });
  }

  _getUserLocation() async{
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  _filterMarkersNow(context) async{
    var filterValue = int.parse(_meterController.text) * 0.001;
    _showToast(Translations.of(context).searching);
    Position _myPos = await _getUserLocation();
    for(MarkerId markID in widget.markIdList){
      ///El await permitio que primero cargue los markadores que cumplen la condicion y despues ejecuta el stream
      await Geolocator().distanceBetween(_myPos.latitude, _myPos.longitude, widget.markers[markID].position.latitude, widget.markers[markID].position.longitude)
          .then((calDist) {
        if((calDist / 1000) < filterValue) {
          _placeFilteredMarkers(widget.markers[markID], markID);
        }
      });
    }
    //Reseteamos el stream y cargamos los markers que cumplen con la condicion
    if(filteredMark.isNotEmpty){
      blocMap.addMarkers(null);
      blocMap.addMarkers(filteredMark);
      blocMap.goToLocation(_myPos.latitude, _myPos.longitude, widget.controller, 16.1);
      _showToast(Translations.of(context).contentFindNearBy + filteredMark.length.toString());
    }
    else{
      _alertNearBy(Translations.of(context).errorDialog, Translations.of(context).contentNotFindNearBy +_meterController.text+ ' mts', context);
    }
  }

  _showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 5
    );
  }

  _placeFilteredMarkers(mark, id) {
    filteredMark[id] = mark;
  }

  _alertNearBy(String title, String content, context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text(Translations.of(context).btnBack),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
