import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_minyan/menu/bloc/marker_details_bloc.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/resources/images.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:go_minyan/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkerDetailScreen extends StatefulWidget {

  final String documentId;

  const MarkerDetailScreen({Key key, this.documentId}) : super(key: key);

  @override
  _MarkerDetailScreenState createState() => _MarkerDetailScreenState();
}

class _MarkerDetailScreenState extends State<MarkerDetailScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //Trae de firebase los horarios
    blocMarker.getMarkerDetails(widget.documentId);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrain) {
        var max = constrain.maxWidth;
        return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomPadding: false,
          appBar: CustomAppBar(documentId: widget.documentId, scaffoldKey: _scaffoldKey, max: max,),
          body: _buildBody(context),
        );
      }
    );
  }

  Widget _buildBody(BuildContext context){
    return Container(
      padding: EdgeInsets.all(15),
      child: _infoTable(),
    );
  }

  Widget _infoTable(){
    return StreamBuilder<QuerySnapshot>(
        stream: blocMarker.documentSchedule,
      builder: (context, snapshot) {
        if(!snapshot.hasData){return Container();}
        else{
          if(snapshot.data.documents.length == 0){
            return Center(child: TextModel(text: Translations.of(context).connectionError, size: 20, color: Theme.Colors.blackColor,));
          }
          var documents = snapshot.data.documents;
          return ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Table(
                  children: [
                    TableRow(
                      children: [
                        _getTableTitleName(Translations.of(context).day),
                        _getTableTitleName(Translations.of(context).shajaritTitle),
                        _getTableTitleName(Translations.of(context).minjaTitle),
                        _getTableTitleName(Translations.of(context).arvitTitle),
                      ]
                    ),
                  ],
              ),
              _getRowTime(FS.sunday, Translations.of(context).sunday, documents),
              _getRowTime(FS.monday, Translations.of(context).monday, documents),
              _getRowTime(FS.tuesday, Translations.of(context).tuesday, documents),
              _getRowTime(FS.wednesday, Translations.of(context).wednesday, documents),
              _getRowTime(FS.thursday, Translations.of(context).thursday, documents),
              _getRowTime(FS.friday, Translations.of(context).friday, documents),
              _getRowTime(FS.shabat, Translations.of(context).shabatTitle, documents),
            ],
          );
        }
      }
    );
  }

  Widget _getRowTime(String fsDay, String day, documents){
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //FS solo cuando el valor es para mandar al firestore
            Expanded(child: _getDayName(day)),
            Expanded(child: _getScheduleList(FS.shajarit, fsDay, documents)),
            Expanded(child: _getScheduleList(FS.minja, fsDay, documents)),
            Expanded(child: _getScheduleList(FS.arvit, fsDay, documents)),
          ],
        ),
      ],
    );
  }

  Widget _getTableTitleName(String title){
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: Text(
          title,
          style: TextStyle(color: Theme.Colors.primaryColor, fontSize: 18, fontFamily: Theme.Fonts.primaryFont)
      ),
    );
  }

  Widget _getDayName(String day){
    return Text(
        day,
        style: TextStyle(fontWeight: FontWeight.bold)
    );
  }

  Widget _getScheduleList(String pray, String day, documents){
          int document;
          ///Corroboro que sea del dia que viene por parametro
          for(var i=0; i<documents.length; i++){
            if(documents[i].documentID == day){
              document = i;
              break;
            }
          }
          //Ordenamos los horarios
          List timeList;
          if(documents[document][pray].length != 0) {
            timeList = documents[document][pray];
            timeList.sort();
          }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: documents[document][pray].length,
              itemBuilder: (BuildContext context, int index) {
                var time = convertData.timestampToString(timeList[index].millisecondsSinceEpoch);
                return Padding(
                  child: TextModel(text: time, size: 15),
                  padding: EdgeInsets.only(bottom: 5),
                );
              },
            );
          }
  }


class CustomAppBar extends StatefulWidget with PreferredSizeWidget{

  final String documentId;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final max;
  CustomAppBar({Key key, this.documentId, this.scaffoldKey, this.max}) : super(key: key);
  @override
  _CustomAppBarState createState() => _CustomAppBarState(max);
  @override
  Size get preferredSize => Size(double.infinity, max < 400 ? 320 : 370);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final max;
  bool darkmode;

  _CustomAppBarState(this.max);
  @override
  Widget build(BuildContext context) {
    darkmode = Provider.of<AppModel>(context).darkmode;
      return Consumer<AppModel>(
              builder: (context, model, child) {
              return ClipPath(
                clipper: MyClipper(),
                child: StreamBuilder<MarkerData>(
//                stream: blocMarker.documentSelected,
                    stream: blocMarker.markerSelected,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text(Translations
                            .of(context)
                            .dataLoading));
                      }
                      else
                        return Container(
                          padding: EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                              color: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.red,
                                    blurRadius: 20,
                                    offset: Offset(0, 0)
                                )
                              ]
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back, color: Colors.white,),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset(
                                          Images.starImg,
                                          color: Theme.Colors.secondaryColor,
                                          height: max < 400 ? 80 : 100,
                                          width: max < 400 ? 90 : 110,
                                        ),
                                        SizedBox(height: 16),
                                        _getText(snapshot.data.title, 22),
                                        SizedBox(height: 10),
                                        Container(
                                          width: 150,
//                                        child: _getText(snapshot.data[FS.address], 15)),
                                            child: _getText(snapshot.data.address, 15)),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      _getText(Translations
                                          .of(context)
                                          .notification, 20),
                                      Switch(
                                        value: model.isSwitch,
                                        activeColor: Colors.white,
                                        onChanged: (value) {
                                          model.onSwitchChanged(value, widget.documentId);
                                          setState((){});
                                          },
                                      ),
                                      FlatButton.icon(
                                          onPressed: () => openMap(snapshot.data.latitude, snapshot.data.longitude),
                                          icon: Icon(Icons.map, size: 30, color: Theme.Colors.secondaryColor),
                                        label: TextModel(text: Translations().map, color: Theme.Colors.secondaryColor,)),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  GestureDetector(
                                      onTap: () => _showNusach(max),
                                      child: _buttonModel(Translations.of(context).nusachTitle)),
                                  GestureDetector(
                                    onTap: () {
                                      var number = snapshot.data.contact;
                                      launch("tel:$number");
                                    },
                                    child: _buttonModel(Translations.of(context).callButton),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                    }
                ),
              );
            }
          );
        }

  ///Navegar desde la app de Google Map
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Widget _buttonModel(String text){
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          0, 24, 16, 0),
      child: Container(
        width: 100,
        height: 32,
        child: Center(child: TextModel(text: text, color: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor)),
        decoration: BoxDecoration(
            color: Theme.Colors.whiteColor,
            borderRadius: BorderRadius.all(
                Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20
              )
            ]
        ),
      ),
    );
  }

  void _showNusach(max) {
    widget.scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      return Container(
        height: max < 400 ? 50 : 100,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
        ),
        child: _buildNusach(),
      );
    });
  }


  Widget _buildNusach(){
    return StreamBuilder<MarkerData>(
//        stream: blocMarker.documentSelected,
        stream: blocMarker.markerSelected,
        builder: (context, snapshot) {
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.nusach.length,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _getText(snapshot.data.nusach[index], 20),
                );
              }
          );
        }
    );
  }

  Widget _getText(String text, double size){
    return TextModel(text: text,
            color: Theme.Colors.whiteColor,
            size: size,
            fontWeight: FontWeight.normal);
  }
}

class MyClipper extends CustomClipper<Path>{

  @override
  Path getClip(Size size) {
    Path p = Path();

    p.lineTo(0, size.height-40);
    p.lineTo(size.width, size.height);

    p.lineTo(size.width, 0);

    p.close();

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}