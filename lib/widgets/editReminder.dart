import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remindme/model/reminder.dart';
import 'package:remindme/utility/appColor.dart';
import 'package:remindme/widgets/customfield.dart';

class EditReminder extends StatefulWidget {
  final String uid;
  final String reminderId;

  EditReminder({required this.uid, required this.reminderId});

  @override
  _EditReminderState createState() => _EditReminderState();
}

class _EditReminderState extends State<EditReminder> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TimeOfDay? _time;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchReminderData();
  }

  Future<void> _fetchReminderData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('reminders')
          .doc(widget.reminderId)
          .get();
      ReminderModel reminder = ReminderModel.fromMap(doc.data() as Map<String, dynamic>);
      DateTime dateTime = reminder.timestamp!.toDate();
      setState(() {
        _titleController.text = reminder.title ?? '';
        _descController.text = reminder.desc ?? '';
        _time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
        _loading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      Navigator.pop(context);
    }
  }

  Future<void> _updateReminder() async {
    try {
      DateTime now = DateTime.now();
      DateTime dateTime = DateTime(now.year, now.month, now.day, _time!.hour, _time!.minute);
      Timestamp timestamp = Timestamp.fromDate(dateTime);

      ReminderModel reminderModel = ReminderModel(
        timestamp: timestamp,
        desc: _descController.text.trim(),
        title: _titleController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('reminders')
          .doc(widget.reminderId)
          .update(reminderModel.toMap());

      Fluttertoast.showToast(msg: "Reminder updated successfully");
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Reminder"),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("Select Time"),
              SizedBox(height: 20),
              MaterialButton(
                onPressed: () async {
                  TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: _time ?? TimeOfDay.now(),
                  );
                  if (newTime == null) return;
                  setState(() {
                    _time = newTime;
                  });
                },
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.clock,
                      color: appColors.primaryColor2,
                      size: 40,
                    ),
                    SizedBox(width: 10),
                    Text(
                      _time?.format(context) ?? '',
                      style: TextStyle(color: appColors.blackColor, fontSize: 30),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text("Add Title"),
              customField(
                textInputType: TextInputType.text,
                textEditingController: _titleController,
              ),
              SizedBox(height: 10),
              Text("Add Description"),
              customField(
                textInputType: TextInputType.text,
                textEditingController: _descController,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_titleController.text.trim().isEmpty || _descController.text.trim().isEmpty) {
                    Fluttertoast.showToast(msg: "Title and description cannot be empty");
                    return;
                  }
                  _updateReminder();
                },
                child: Text("Update Reminder"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
