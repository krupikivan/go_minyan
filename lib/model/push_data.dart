import 'package:cloud_firestore/cloud_firestore.dart';

class PushData{

  Timestamp timeToPush;
  String pray;
  String place;
  String timeString;
  bool wasPushed;

  PushData({this.timeToPush, this.pray, this.place, this.timeString, this.wasPushed});

}