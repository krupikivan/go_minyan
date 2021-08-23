import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Schedule> listadoScheduleFromJson(String str) {
  final jsonData = json.decode(str);
  var js = json.decode(jsonData);
  List getList = js;
  return new List<Schedule>.from(getList.map((x) => Schedule.fromJJson(x)));
}

List<Pray> listadoPrayFromJson(String str) {
  final jsonData = json.decode(str);
//  var js = json.decode(jsonData);
  List getList = jsonData;
  return new List<Pray>.from(getList.map((x) => Pray.fromJJson(x)));
}

String listadoScheduleToJson(List<Schedule> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson(listadoPrayToJson(x.pray))));
  return json.encode(dyn);
}

String listadoPrayToJson(List<Pray> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class Schedule{

  List<Pray> pray;
  String name;
  int value;

  Schedule({
    this.pray,
    this.name,
    this.value,
  });

//  Schedule.froamJson(Map<dynamic, dynamic> json)
//      : this.name = json['name'],
//        this.value = json['value'] as int,
//        this.pray = listadoPrayFromJson(json['pray']);

  factory Schedule.fromJJson(Map<dynamic, dynamic> json) {
    Schedule sch = new Schedule(
      name: json['name'],
      value: json['value'] as int,
      pray: listadoPrayFromJson(json['pray']),
    );
    print(sch.pray);
    return sch;
  }

  Map<dynamic, dynamic> toJson(String listPray) => {
    'name': this.name,
    'value': this.value,
    'pray': listPray,
  };

}

class Pray{
  String name;
  List type;

  Pray({
    this.name,
    this.type,
  });

  Map<dynamic, dynamic> toJson() => {
    'name': name,
    'value': type,
  };

//  Pray.fromJson(Map<dynamic, dynamic> json)
//      : this.name = json['name'],
//        this.type = _getTimestamp(json['value']) as List<int>;

  factory Pray.fromJJson(Map<dynamic, dynamic> json) {
    Pray pr = new Pray(
      name: json['name'],
      type: _getTimestamp(json['value']),
    );
    print(pr);
    return pr;
  }

  static _getTimestamp(json){
    List<int> list = List();
    for(var j=0; j< json.length; j++){
      Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(json[j]);
      list.add(timestamp.millisecondsSinceEpoch);
    }
    return list;
  }

}