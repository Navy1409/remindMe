import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remindme/model/reminder.dart';
import 'package:remindme/utility/appColor.dart';
import 'package:remindme/widgets/customfield.dart';

Future<void> addReminder(
    BuildContext context, String uid,) async {
  TimeOfDay time = TimeOfDay.now();
  add(String uid,TimeOfDay time, String title,  String desc) async {

    try {
      DateTime d = DateTime.now();
      DateTime dateTime =
      DateTime(d.year, d.month, d.day, time.hour, time.minute);
      Timestamp timestamp = Timestamp.fromDate(dateTime);

      ReminderModel reminderModel = ReminderModel(
        timestamp: timestamp,
        desc: desc,
        title: title,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('reminders')
          .doc()
          .set(reminderModel.toMap());
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  return showDialog(context: context, builder: (context){
    return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState){
      final TextEditingController _titleController= TextEditingController();
      final TextEditingController _descController= TextEditingController();
      
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        title: Text("Add Reminder"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text("Select Time"),
              SizedBox( height: 20),
              MaterialButton(onPressed: ()async{
                TimeOfDay? newTime= await showTimePicker(context: context, initialTime: TimeOfDay.now());
                if(newTime== null) return null;
                setState((){
                  time=newTime;
                });
              },
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.clock, color: appColors.primaryColor2,size: 40,),
                    SizedBox(width: 10,),
                    Text(time.format(context).toString(),
                    style: TextStyle(color: appColors.blackColor, fontSize: 30),)
                  ],
                ),
              ),
              Text("Add Title"),
              customField(textInputType: TextInputType.text, textEditingController: _titleController),
              SizedBox(
                height: 10,
              ),
              Text("Add Description"),
              customField(textInputType: TextInputType.text, textEditingController: _descController,)
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            add(uid, time, _titleController.text, _descController.text);
            Navigator.pop(context);
          }, child: Text("OK")),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel")),
        ],
      );
    }
    );
  });
}
