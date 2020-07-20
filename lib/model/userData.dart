class UserData {
  String title;
  String address;
  String contact;
  List nusach;
  double latitude;
  double longitude;
  String documentId;

  UserData({
    this.title,
    this.address,
    this.contact,
    this.nusach,
    this.latitude,
    this.longitude,
    this.documentId,
  });

//  Map<String, double> toJson() => {
//    FS.latitude: this.latitude,
//    FS.longitude: this.longitude,
//  };
//
//  UserData.fromJson(Map<String, double> json)
//      : this.latitude = json[FS.latitude],
//        this.longitude = json[FS.longitude];
}
