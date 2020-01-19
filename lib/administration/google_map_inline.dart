import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_minyan/widget/widget.dart';
import 'package:go_minyan/style/theme.dart' as Theme;

class GoogleMapScreen extends StatefulWidget {
  final double lat, long;
  final String address;
  final bool darkmode;
  final size;

  GoogleMapScreen({Key key, this.lat, this.long, this.address, this.darkmode, this.size})
      : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  // ignore: sdk_version_set_literal
  Set<Marker> markers = {};

  CameraPosition get _camera => CameraPosition(
      target: LatLng(widget.lat, widget.long),
      zoom: 16.0);

  @override
  void initState() {
    _addMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _setData();
    return Container(
      child: Stack(
        children: <Widget>[
          _buildGoogleMap(),
          SizedBox(height: 15),
          _buildText(),
        ],
      ),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      rotateGesturesEnabled: true,
      compassEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: false,
      markers: markers,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      initialCameraPosition: _camera,
    );
  }

  Widget _buildText() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: TextModel(text: widget.address, size: widget.size < 400 ? 12 : 16, color: widget.darkmode ? Theme.Colors.blackColor : Theme.Colors.blackColor),
      ),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(36)),
          boxShadow: [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 36),
          ]),
    );
  }

  void _addMarker() {
    final MarkerId unique = MarkerId('unique');
    Marker marker = Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: unique,
      position: LatLng(widget.lat, widget.long),
    );
    markers.add(marker);
  }

  void _setData() async{
    await _goToLocation(widget.lat, widget.long);
    markers.clear();
    _addMarker();
  }

  Future<void> _goToLocation(latitude, longitude) async{
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(_camera),
      );
  }
}
