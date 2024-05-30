import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remindme/utility/appColor.dart';

class DeleteReminder extends StatelessWidget {
  final String uid;
  final String reminderId;

  const DeleteReminder({required this.uid, required this.reminderId, Key? key}) : super(key: key);

  Future<void> _deleteReminder(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('reminders')
          .doc(reminderId)
          .delete();

      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Error deleting reminder: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Reminder'),
      content: Text('Are you sure you want to delete this reminder?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: appColors.primaryColor1)),
        ),
        TextButton(
          onPressed: () => _deleteReminder(context),
          child: Text('Delete', style: TextStyle(color: appColors.primaryColor1)),
        ),
      ],
    );
  }
}
