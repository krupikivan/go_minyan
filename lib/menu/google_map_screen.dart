import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_minyan/menu/bloc/google_map_bloc.dart';
import 'package:go_minyan/menu/bloc/marker_details_bloc.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:geolocator/geolocator.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/widget/widget.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class MinianScreen extends StatefulWidget {
  @override
  _MinianScreenState createState() => _MinianScreenState();
}

class _MinianScreenState extends State<MinianScreen> with TickerProviderStateMixin {
  Position position;
  Completer<GoogleMapController> _controller = Completer();
  AnimationController animationControllerSearch;
  TextEditingController searchController = new TextEditingController();
  String searchFilter;

  ///Solo para cambiar el Marker del mapa
  BitmapDescriptor myIcon;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  ///Para el filtrado de los markers
  List<MarkerId> markIdList = new List();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool darkmode;
  static LatLng _initialPosition;
  MapType _currentMapType = MapType.normal;



  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(20, 20)), 'assets/img/pinMap.png').then((onValue){
      //Set marker icon on google map start
      setState(() {
        myIcon = onValue;
      });
    });
    searchController.addListener((){
      setState(() {
        searchFilter = searchController.text;
      });
    });
    _getUserLocation();
  }

  _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    blocMarker.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //Agrego en bloc los markers - se escuchan en google_map.dart
    //Hacerlo en app.dart llamando al shared prefs
//    blocMarker.getAllMarkers();
    blocMarker.getMarkerDataFromFirebase(Provider.of<AppModel>(context));
    darkmode = Provider.of<AppModel>(context).darkmode;
    //Controlamos si esta en hebreo
    var lang = Provider.of<AppModel>(context).isReverse;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
        title: Text(Translations.of(context).minianFinder),
        actions: <Widget>[
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMapWidget(context: context, controller: _controller, currentMapType: _currentMapType, myIcon: myIcon, markers: markers, markIdList: markIdList, initialPosition: _initialPosition,),
          _btnLocationMap(),
          SearchMap(searchController: searchController, darkmode: darkmode),
          SearchResults(controller: _controller, darkmode: darkmode, searchFilter: searchFilter, searchController: searchController),
        ],
      ),
      floatingActionButton: _bntExpanded(lang),
    );
  }

  Widget _bntExpanded(lang){
    return SpeedDial(
      marginRight: lang == true ? 40 : 10,
      overlayOpacity: lang == true ? 0 : 0.3,
      overlayColor: Theme.Colors.secondaryDarkColor,
      heroTag: 'bntExpand',
      backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
      child: Icon(Icons.add, color: Theme.Colors.secondaryColor,),
      children: [
        SpeedDialChild(
          child: Icon(Icons.near_me, size: 36.0, color: Theme.Colors.secondaryColor),
          backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
          label: Translations.of(context).btnNearMe,
          labelStyle: TextStyle(fontFamily: Theme.Fonts.primaryFont, color: Theme.Colors.blackColor),
          onTap: _inputDialog,
        ),
        SpeedDialChild(
          child: Icon(Icons.map, color: Theme.Colors.secondaryColor),
          backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
          label: Translations.of(context).btnMapView,
          labelStyle: TextStyle(fontFamily: Theme.Fonts.primaryFont, color: Theme.Colors.blackColor),
          onTap: _onMapTypeButtonPressed,
        ),
        SpeedDialChild(
          child: Icon(Icons.watch_later, color: Theme.Colors.secondaryColor),
          backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
          label: Translations.of(context).btnNow,
          labelStyle: TextStyle(fontFamily: Theme.Fonts.primaryFont, color: Theme.Colors.blackColor),
          onTap: _onNowPressed,
        )
      ],
    );
  }

  ///Location Button
  Widget _btnLocationMap(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: FloatingActionButton(
          heroTag: 'btnLocate',
          onPressed: _takeLocation,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
          child: const Icon(Icons.my_location, size: 36.0, color: Theme.Colors.secondaryColor),
        ),
      ),
    );
  }

  //Get minyan now
  _onNowPressed() async{
    ShowToast().show(Translations().searching, 10);
    String title = await blocMap.getNow(markIdList, markers, _scaffoldKey.currentContext);
    Future.delayed(Duration(seconds: 2));
    return showDialog(
      context: _scaffoldKey.currentContext,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return StreamBuilder<List<MarkerNow>>(
          stream: blocMap.getNowMarkes,
          builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Container();
          }else
            if (title == '') {
            return _alertIfNoData();
          }
          else{
            return AlertDialog(
              title: Text(title),
              content: Container(
                height: snapshot.data.length == 1 ? 60 : snapshot.data.length == 2 ? 150 : 200,
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 2,
                child: ListView.builder(
                  physics: snapshot.data.length == 1 ? NeverScrollableScrollPhysics() : null,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(snapshot.data[index].title),
                        subtitle: Text(snapshot.data[index].times),
                        trailing: Icon(Icons.location_on),
                        onTap: () {
                          blocMap.goToLocation(snapshot.data[index].latitude,
                              snapshot.data[index].longitude, _controller, 18);
                          Navigator.pop(context);
                        },
                      );
                    }),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(Translations
                      .of(context)
                      .btnBack),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
        }
          }
        );
      },
    );
  }

  _alertIfNoData() {
        return AlertDialog(
          title: Text(Translations.of(context).errorDialog),
          content: Text(Translations.of(context).contentNotFindNow),
          actions: <Widget>[
            FlatButton(
              child: Text(Translations.of(context).btnBack),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );

  }

  //Change map view
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  //Input filter meters
 _inputDialog() {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return InputMeters(darkmode: darkmode, markers: markers, markIdList: markIdList, context: _scaffoldKey.currentContext, controller: _controller,);
      },
    );
  }

  //btnLocation
  _takeLocation() async{
    ShowToast().show(Translations().searching, 10);
    if(await Geolocator().isLocationServiceEnabled()) {
      position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      blocMap.goToLocation(position.latitude, position.longitude, _controller, 18);
    }else{
      blocMap.requestLocationPermission();
    }
  }


}