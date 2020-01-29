import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_minyan/menu/bloc/google_map_bloc.dart';
import 'package:go_minyan/menu/bloc/marker_details_bloc.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/widget/widget.dart';

class SearchResults extends StatelessWidget {

  final String searchFilter;
  final Completer<GoogleMapController> controller;
  final bool darkmode;
  final TextEditingController searchController;
  SearchResults({Key key, this.searchFilter, this.darkmode, this.searchController, this.controller}) : super(key: key);

  List<MarkerData> _filter = List();

  @override
  Widget build(BuildContext context) {
    return searchFilter != '' && searchFilter != null
//        ? StreamBuilder<QuerySnapshot>(
        ? StreamBuilder<List<MarkerData>>(
//        stream: blocMarker.documentData,
        stream: blocMarker.getMarkerList,
        builder: (context, snapshot) {
          if(!snapshot.hasData){return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.Colors.primaryColor)));}
          else{
            _filter.clear();
            for(var i=0; i<snapshot.data.length; i++){
              if(snapshot.data[i].title.toLowerCase().contains(searchFilter.toLowerCase())){
                _filter.add(snapshot.data[i]);
              }
            }
            return _searchBox(_filter, context);
          }
        }
    )
        : const Padding(
      padding: const EdgeInsets.all(0),
    );
  }

  Widget _searchBox(List<MarkerData> data, context){
    return data.length != 0 ? Container(
        height: data.length >= 0 && data.length < 2 ? 120 : data.length >= 2 && data.length < 4 ? 250 : 300,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        margin: EdgeInsets.only(
          left: 16,
          top: 100,
          right: 50,
        ),
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: TextModel(text: data[index].title, size: 16, color: darkmode ? Theme.Colors.secondaryColor :Theme.Colors.blackColor),
                subtitle: TextModel(text: data[index].address, size: 12, color: darkmode ? Theme.Colors.secondaryColor :Theme.Colors.blackColor),
                trailing: Icon(Icons.arrow_forward, color:  darkmode ? Theme.Colors.secondaryColor :Theme.Colors.primaryColor),
                onTap: (){
                  searchController.clear();
                  blocMap.goToLocation(data[index].latitude, data[index].longitude, controller, 18);
                  FocusScope.of(context).requestFocus(new FocusNode()); //Hide the Keyboard
                },
              );
            }
        ),
        decoration: BoxDecoration(
            color: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(36)),
            boxShadow: [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 36),
            ]),
      ): Container();
  }


}


class SearchingResults extends StatelessWidget {

  final String searchFilter;
  final Completer<GoogleMapController> controller;
  final bool darkmode;
  final TextEditingController searchController;
  SearchingResults({Key key, this.searchFilter, this.darkmode, this.searchController, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return searchFilter != '' && searchFilter != null
//        ? StreamBuilder<QuerySnapshot>(
        ? StreamBuilder<List<MarkerData>>(
//        stream: blocMarker.documentData,
        stream: blocMarker.getMarkerList,
        builder: (context, snapshot) {
          if(!snapshot.hasData){return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.Colors.primaryColor)));}
          else{
            return Container(
//              height: snapshot.data.documents.length == 1 || snapshot.data.documents.length == 2 ? 100 : 300,
              height: snapshot.data.length >= 0 && snapshot.data.length < 2 ? 100 : snapshot.data.length >= 2 && snapshot.data.length < 4 ? 250 : 300,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              margin: EdgeInsets.only(
                left: 16,
                top: 100,
                right: 50,
              ),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15),
                    child: TextModel(text: Translations.of(context).searchResults, size: 25, color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: snapshot.data.length != 0 ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
//                      itemCount: snapshot.data.documents.length,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
//                        if(snapshot.data.documents[index].data[FS.title].toLowerCase().contains(searchFilter.toLowerCase())){
                        if(snapshot.data[index].title.toLowerCase().contains(searchFilter.toLowerCase())){
                          return ListTile(
//                            title: TextModel(text: snapshot.data.documents[index].data[FS.title], size: 16, color: darkmode ? Theme.Colors.secondaryColor :Theme.Colors.blackColor),
                            title: TextModel(text: snapshot.data[index].title, size: 16, color: darkmode ? Theme.Colors.secondaryColor :Theme.Colors.blackColor),
//                            subtitle: TextModel(text: snapshot.data.documents[index].data[FS.address], size: 12, color: darkmode ? Theme.Colors.secondaryColor :Theme.Colors.blackColor),
                            subtitle: TextModel(text: snapshot.data[index].address, size: 12, color: darkmode ? Theme.Colors.secondaryColor :Theme.Colors.blackColor),
                            trailing: Icon(Icons.arrow_forward, color:  darkmode ? Theme.Colors.secondaryColor :Theme.Colors.primaryColor),
                            onTap: (){
                              searchController.clear();
                              blocMap.goToLocation(snapshot.data[index].latitude, snapshot.data[index].longitude, controller, 18);
                              FocusScope.of(context).requestFocus(new FocusNode()); //Hide the Keyboard
                            },
                          );
                        }
                        else{
//                          return ListTile(title: TextModel(text: Translations.of(context).lblNoData, size: 16, color: darkmode ? Theme.Colors.secondaryColor :Theme.Colors.blackColor));
                          return Container();
                        }
                      },
//                    ) : ListTile(title: TextModel(text: Translations.of(context).lblNoData, size: 16, color: darkmode ? Theme.Colors.secondaryColor :Theme.Colors.blackColor)),
                    ) : Container(),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.secondaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(36)),
                  boxShadow: [
                    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 36),
                  ]),
            );
          }
        }
    )
        : const Padding(
      padding: const EdgeInsets.all(0),
    );
  }
}

