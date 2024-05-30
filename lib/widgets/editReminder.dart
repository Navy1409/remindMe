import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remindme/utility/appColor.dart';

class EditReminder extends StatefulWidget {
  final String uid;
  final String reminderId;

  const EditReminder({required this.uid, required this.reminderId, Key? key}) : super(key: key);

  @override
  _EditReminderState createState() => _EditReminderState();
}

class _EditReminderState extends State<EditReminder> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _desc = '';
  DateTime? _selectedDateTime;

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

      if (doc.exists) {
        setState(() {
          _title = doc['title'] ?? '';
          _desc = doc['desc'] ?? '';
          _selectedDateTime = (doc['timestamp'] as Timestamp).toDate();
        });
      }
    } catch (e) {
      debugPrint('Error fetching reminder data: $e');
    }
  }

  Future<void> _updateReminder() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .collection('reminders')
            .doc(widget.reminderId)
            .update({
          'title': _title,
          'desc': _desc,
          'timestamp': _selectedDateTime,
        });

        Navigator.of(context).pop();
      } catch (e) {
        debugPrint('Error updating reminder: $e');
      }
    }
  }

  Future<void> _selectDateTime() async {
    DateTime initialDate = _selectedDateTime ?? DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Reminder'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _title,
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (value) => setState(() => _title = value),
              validator: (value) => value!.isEmpty ? 'Title cannot be empty' : null,
            ),
            TextFormField(
              initialValue: _desc,
              decoration: InputDecoration(labelText: 'Description'),
              onChanged: (value) => setState(() => _desc = value),
              validator: (value) => value!.isEmpty ? 'Description cannot be empty' : null,
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: _selectDateTime,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Reminder Time',
                  border: OutlineInputBorder(),
                ),
                baseStyle: TextStyle(fontSize: 16),
                child: Text(
                  _selectedDateTime != null
                      ? DateFormat('yyyy-MM-dd – kk:mm').format(_selectedDateTime!)
                      : 'Select Date & Time',
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: appColors.primaryColor1)),
        ),
        TextButton(
          onPressed: _updateReminder,
          child: Text('Save', style: TextStyle(color: appColors.primaryColor1)),
        ),
      ],
    );
  }
}
