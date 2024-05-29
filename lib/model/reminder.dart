import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel{
  Timestamp? timestamp;
  String? desc;
  String? title;

  ReminderModel({this.timestamp, this.desc, this.title});

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'desc': desc,
      'title': title,
    };
  }
  factory ReminderModel.fromMap(map){
    return ReminderModel(
      timestamp: map['timestamp'],
      desc: map['desc'],
      title: map['title']
    );
  }
}
