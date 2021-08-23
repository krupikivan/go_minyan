import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/resources/repository.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class TimesBloc{
  final _repository = Repository();

  final _docTimes = BehaviorSubject<QuerySnapshot>();
  final _scheduleList = BehaviorSubject<List<Schedule>>();

  Observable<QuerySnapshot> get listenDoc => _docTimes.stream;
  Function(QuerySnapshot) get addDoc => _docTimes.sink.add;

  Observable<List<Schedule>> get getScheduleList => _scheduleList.stream;
  Function(List<Schedule>) get addScheduleList => _scheduleList.sink.add;

  void saveNewTime(String documentID, String day, String pray, DateTime time, AppModel appModel) {
    String dayDocumentId = '';
    List<Schedule> listSchedule = _scheduleList.stream.value;
    for(var i=0; i<listSchedule.length; i++){
      if (listSchedule[i].name == day){
        for(var j=0; j<listSchedule[i].pray.length; j++){
          if(listSchedule[i].pray[j].name == pray){
            listSchedule[i].pray[j].type.add(time.millisecondsSinceEpoch);
            _scheduleList.add(listSchedule);
          }
        }

      }
    }
    _savedTimesSharedPrefs(appModel, listSchedule);
    _repository.saveNewTime(documentID, day, pray, time, dayDocumentId);
  }

  void createSchedule(AppModel appModel){
    List<Schedule> scheduleList = new List();
    //Documents es null porque ejecuta primero este metodo y despues lo carga
    for(var i = 0; i < _docTimes.value.documents.length; i++){
      String day = _docTimes.value.documents[i].data['name'];
      DocumentSnapshot doc = _docTimes.value.documents[i];
      //Fill the schedule list
      scheduleList.add(_fillDayData(day, doc, appModel));
    }
    addScheduleList(scheduleList);
    _savedTimesSharedPrefs(appModel, scheduleList);
  }

  _savedTimesSharedPrefs(AppModel appModel, scheduleList){
    //Create json string from schedule list
    String jsonString = json.encode(listadoScheduleToJson(scheduleList));
    print(jsonString);
    //Save on shared preferences
    appModel.saveScheduleData(jsonString, scheduleList);
  }

  Schedule _fillDayData(String day, DocumentSnapshot doc, AppModel appModel){
    Schedule day = new Schedule();
    day.name = doc.data[FS.name];
    day.value = doc.data[FS.value];
    List<Pray> listPray = new List();
    for (var i=0; i<3; i++){
      switch(i){
        case 0:   Pray pray = new Pray();
                  pray = _fillListPray(FS.shajarit, pray, doc);
                  listPray.add(pray);
                  break;
        case 1:   Pray pray = new Pray();
                  pray = _fillListPray(FS.minja, pray, doc);
                  listPray.add(pray);
                  break;
        case 2:
                  Pray pray = new Pray();
                  pray = _fillListPray(FS.arvit, pray, doc);
                  listPray.add(pray);
                  break;
      }
    }
    day.pray = listPray;
    return day;
  }

  _fillListPray(String name, Pray pray, doc) {
    pray.name = name;
    pray.type = convertTimestamp(doc.data[name]);
    return pray;
  }
  convertTimestamp(List list){
    List newList = List();
    for(Timestamp timestamp in list){
      newList.add(timestamp.millisecondsSinceEpoch);
    }
    return newList;
  }

  void deteleTime(String documentId, String day, String pray, Timestamp time, String dayDocumentId, AppModel appModel) {
    List<Schedule> listSchedule = _scheduleList.stream.value;
      for(var i=0; i<listSchedule.length; i++){
        if (listSchedule[i].name == day){
          for(var j=0; j<listSchedule[i].pray.length; j++){
            if(listSchedule[i].pray[j].name == pray){
              listSchedule[i].pray[j].type.remove(time.millisecondsSinceEpoch);
              _scheduleList.add(listSchedule);
            }
          }

        }
      }
    _savedTimesSharedPrefs(appModel, listSchedule);
    _repository.deleteTime(documentId, day, pray, time, dayDocumentId);
  }


  void dispose() async {
    await _docTimes.drain();
    _docTimes.close();
    await _scheduleList.drain();
    _scheduleList.close();
  }

}

final blocTimes = TimesBloc();