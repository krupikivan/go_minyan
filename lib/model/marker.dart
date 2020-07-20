import 'dart:convert';

List<MarkerData> listadoMarkerFromJson(String str) {
  final jsonData = json.decode(str);
  var js = json.decode(jsonData);
  List getList = js;
  return new List<MarkerData>.from(getList.map((x) => MarkerData.fromJJson(x)));
}

List<Nusach> listadoNusachFromJson(List str) {
//  final jsonData = json.decode(str);
  List getList = str;
//  List getList = jsonData;
  return new List<Nusach>.from(getList.map((x) => Nusach.fromJJson(x)));
}

String listadoMarkerToJson(List<MarkerData> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson(x.nusach)));
  return json.encode(dyn);
}

//String listadoNusachToJson(List<Nusach> data) {
//  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
//  return json.encode(dyn);
//}
class MarkerData {
  List nusach;
  String address;
  String contact;
  double latitude;
  double longitude;
  String title;
  String userUID;
  String email;
  String documentID;
  bool isAuthenticated;

  Map schedule;

  MarkerData({
    this.nusach,
    this.address,
    this.contact,
    this.latitude,
    this.longitude,
    this.title,
    this.userUID,
    this.email,
    this.documentID,
    this.isAuthenticated,
    this.schedule,
  });

  factory MarkerData.fromJJson(Map<dynamic, dynamic> json) {
    MarkerData sch = new MarkerData(
        address: json['address'],
        contact: json['contact'],
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
        title: json['title'],
        userUID: json['userUID'],
        email: json['email'],
        documentID: json['documentID'],
        isAuthenticated: json['isAuthenticated'] as bool,
        nusach: listadoNusachFromJson(json['nusach']),
        schedule: json['schedule']);
    return sch;
  }

  factory MarkerData.fromFirebase(Map<dynamic, dynamic> data, id) {
    MarkerData sch = new MarkerData(
        address: data['address'],
        contact: data['contact'],
        latitude: data['location'].latitude as double,
        longitude: data['location'].longitude as double,
        title: data['title'],
        email: data['email'],
        documentID: id,
        isAuthenticated: data['isAuthenticated'] as bool,
        nusach: data['nusach'],
        schedule: data['schedule']);
    return sch;
  }

  Map<dynamic, dynamic> toJson(List listNusach) => {
        'address': this.address,
        'contact': this.contact,
        'latitude': this.latitude,
        'longitude': this.longitude,
        'title': this.title,
        'userUID': this.userUID,
        'email': this.email,
        'documentID': this.documentID,
        'isAuthenticated': this.isAuthenticated,
        'nusach': listNusach,
      };
}

class Nusach {
  String nusach;

  Nusach({
    this.nusach,
  });

  Map<dynamic, dynamic> toJson() => {
        'nusach': nusach,
      };

  factory Nusach.fromJJson(Map<dynamic, dynamic> json) {
    Nusach nusach = new Nusach(
      nusach: json['nusach'],
    );
    return nusach;
  }
}
