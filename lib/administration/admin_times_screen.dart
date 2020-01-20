import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_minyan/administration_bloc/bloc.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:go_minyan/widget/drop_model_widget.dart';
import 'package:go_minyan/widget/radio_model_widget.dart';
import 'package:go_minyan/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AdminTimesScreen extends StatelessWidget {

  final bool darkmode;

  int _radioPray = 0;
  int _dropDay;

  ///Just to send parameter to firestore from bloc
  TimeOfDay _timeOfDay;

  AdminTimesScreen({Key key, this.darkmode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
        title: Text(Translations.of(context).prayTimeTitle),
      ),
      body: LayoutBuilder(
        builder: (context, constrain) {
          var size = constrain.maxWidth;
          return Stack(
            children: <Widget>[
              _buildBody(context),
              _btnNewTimes(context, size),
            ],
          );
        }
      ),
    );
  }

  Widget _buildBody(BuildContext context){
    return Container(
      padding: EdgeInsets.all(15),
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          _infoTable(context),
        ],
      ),
    );
  }

  Widget _btnNewTimes(context, size){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton.extended(
          heroTag: 'btnAdd',
          onPressed: (){_showAddTimePopup(context, size);},
          materialTapTargetSize: MaterialTapTargetSize.padded,
          backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
          label: TextModel(text: Translations.of(context).btnNew, color: Theme.Colors.secondaryColor,),
          icon: Icon(Icons.add, size: 30.0, color: Theme.Colors.secondaryColor,),
        ),
      ),
    );
  }


  Widget _infoTable(context){
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      padding: EdgeInsets.all(15),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          _getDescription(Translations.of(context).lblDescriptionPray),
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
          _getRowTime(FS.sunday, Translations.of(context).sunday),
          _getRowTime(FS.monday, Translations.of(context).monday),
          _getRowTime(FS.tuesday, Translations.of(context).tuesday),
          _getRowTime(FS.wednesday, Translations.of(context).wednesday),
          _getRowTime(FS.thursday, Translations.of(context).thursday),
          _getRowTime(FS.friday, Translations.of(context).friday),
          _getRowTime(FS.shabat, Translations.of(context).shabatTitle),
        ],
      ),
      decoration: BoxDecoration(
        color: darkmode ? Theme.Colors.secondaryDarkColor : Theme.Colors.secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          new BoxShadow(
            color: Colors.black45,
            blurRadius: 10.0
          )
        ],
      ),
    );
  }

  Widget _getRowTime(String fsDay, String day){
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ///FS solo cuando el valor es para mandar al firestore
            _getDayName(day),
            _getScheduleList(FS.shajarit, fsDay),
            _getScheduleList(FS.minja, fsDay),
            _getScheduleList(FS.arvit, fsDay),
          ],
        ),
      ],
    );
  }

  Widget _getTableTitleName(String title){
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: TextModel(text: title, size: 16, color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor,),
    );
  }

  Widget _getDayName(String day){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: TextModel(text: day, fontWeight: FontWeight.bold, color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor,),
      ),
    );
  }

  void removeTime(String documentID, String day, String pray, Timestamp value, String dayDocumentId, AppModel appModel) {
    blocTimes.deteleTime(documentID, day, pray, value, dayDocumentId, appModel);

  }


  ///Carga los horarios cargados en FIRESTORE
  Widget _getScheduleList(String pray, String day){
    return StreamBuilder<List<Schedule>>(
      stream: blocTimes.getScheduleList,
      builder: (context, snapshot) {
        if(!snapshot.hasData){return Container();}
        else {
          Schedule sch = new Schedule();
          for(var i=0; i<snapshot.data.length; i++){
            if(snapshot.data[i].name == day){
              sch = snapshot.data[i];
              for(var j=0; j<sch.pray.length; j++){
                if(sch.pray[j].name == pray){
                  return _listTime(day, pray, sch.pray[j]);
                }
              }
            }
          }
          return Container();
        }
      },
    );
  }

  Widget _listTime(String day, String pray, Pray prayItem){
    return Expanded(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: prayItem.type.length,
        itemBuilder: (BuildContext context, int index) {

          List timeList = prayItem.type;
          timeList.sort(); //Ordeno el listado de horarios
          var time = convertData.timestampToString(timeList[index]);
          //Cast timestamp to String
          //var time = convertData.timestampToString(prayItem.type[index]);
          return LayoutBuilder(
            builder: (context, constrain) {
              var size = constrain.maxWidth;
              return ListTile(
                title: TextModel(text: time, color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.secondaryDarkColor, size: size < 400 ? 12 : 15,),
                trailing: Icon(Icons.clear, size: size < 400 ? 15 : 18,),
                contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                dense: true,
                onTap: () {
                  removeTime(Provider.of<AppModel>(context).userData.documentId, day, pray, Timestamp.fromMillisecondsSinceEpoch(prayItem.type[index]), day, Provider.of<AppModel>(context));
                },
              );
            }
          );
        },
      ),
    );
  }

  Widget _getDescription (String desc){
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextModel(text: desc, size: 16, color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor,),
    );
  }

   _showAddTimePopup(BuildContext context, size) {
     blocTimePicker.addTime(null);
     _timeOfDay = null;
    Alert(
        context: context,
        ///Seteamos el bloc del drop down
        closeFunction: blocAddNew.changeDropDay(null),
        title: Translations.of(context).popupTitle,
        style: AlertStyle(
          titleStyle: TextStyle(color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor,),
        ),
        content: Container(
                width: double.maxFinite,
                height: size < 400 ? MediaQuery.of(context).size.height / 2.2 : MediaQuery.of(context).size.height / 3,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    StreamBuilder<int>(
                        stream: blocAddNew.dropDay,
                        builder: (context, snapshot) {
                          _dropDay = snapshot.data;
                          ///0- domingo 1-lunes, 2-martes, 3-miercoles, 4-jueves, 5-viernes, 6-sabado
                          return Align(alignment: Alignment.center,child: DropModelWidget(context: context));
                        }
                    ),
                    StreamBuilder<int>(
                        stream: blocAddNew.radioPray,
                        builder: (context, snapshot) {
                          _radioPray = snapshot.data;
                          return RadioModelWidget(darkmode: darkmode, sha: Translations.of(context).shajaritTitle, min: Translations.of(context).minjaTitle, arv: Translations.of(context).arvitTitle);
                        }
                    ),
                    RaisedButton(
                      color: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
                      onPressed: () {_selectTime(context);},
                      child: TextModel(text: Translations.of(context).btnPopupTime, color: Theme.Colors.secondaryColor,),

                    ),
                    StreamBuilder<DateTime>(
                      stream: blocTimePicker.getTime,
                      builder: (context, snapshot) {
                        if(!snapshot.hasData) return Container();
                        else return Text(Translations.of(context).lblSelectedTime+DateFormat("HH:mm").format(snapshot.data));
                      }
                    ),
                  ],
                ),
              ),
        buttons: [
          DialogButton(
            color: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
            onPressed: () {
              if(_timeOfDay == null || _dropDay == null){ShowToast().show(Translations().adminDialogContentError, 10);}
              else{
                ///Del time picker lo metemos en Firestore como DateTime, firestore lo guarda como TimesTamp
//                blocTimes.saveNewTime(AppModel.of(context).userData.documentId, blocAddNew.getStringDay(_dropDay), blocAddNew.getPrayFromInt(_radioPray), _getDateTime(), AppModel.of(context));
                blocTimes.saveNewTime(Provider.of<AppModel>(context).userData.documentId, convertData.getWeekDayToString(_dropDay), convertData.getPrayFromInt(_radioPray), convertData.getDateTime(_timeOfDay), Provider.of<AppModel>(context));
                ShowToast().show(Translations().saveMsg, 10);
                blocTimePicker.addTime(null);
                _timeOfDay = null;
              }
            },
            child: TextModel(text: Translations.of(context).btnAdd, size: 20, color: Theme.Colors.secondaryColor,),
          )
        ]).show();
  }

  Future<Null> _selectTime(BuildContext context) async{
    TimeOfDay _time = new TimeOfDay.now();
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if(picked != null){
      _timeOfDay = picked;
      var time = convertData.getDateTime(_timeOfDay);
      blocTimePicker.addTime(time);
    }
  }

}
