import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRequest {
  bool isReady;
  String request;
  String userId;
  String userName;
  String faculty;
  String roll;
  int year;
  DateTime requestDate;
  String docId;

  toMap() {
    return {
      'request': request,
      'userId': userId,
      'userName': userName,
      'faculty': faculty,
      'roll': roll,
      'year': year,
      'requestDate': requestDate,
      'docId': docId,
      'isReady': isReady
    };
  }

  static AdminRequest fromMap(Map<String, dynamic> json) {
    return AdminRequest()
      ..request = json['request']
      ..docId = json["docId"]
      ..userId = json['userId']
      ..userName = json['userName']
      ..faculty = json['faculty']
      ..roll = json['roll']
      ..year = json['year']
      ..requestDate = (json['requestDate'] as Timestamp).toDate()
      ..isReady = json["isReady"];
  }
}
