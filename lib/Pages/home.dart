import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remindme/Pages/Login/login.dart';
import 'package:remindme/services/notificationLogic.dart';
import 'package:remindme/utility/appColor.dart';
import 'package:remindme/widgets/addReminder.dart';
import 'package:remindme/widgets/deleteReminder.dart';
import 'package:remindme/widgets/editReminder.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user;
  String userName = "";

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Notificationlogic.init(context, user!.uid);
      listenNotification();
      _fetchUserData();
    }
    // _checkAndDeleteExpiredReminders();
  }

  void listenNotification() {
    Notificationlogic.onNotification.listen((value) {
      debugPrint('Notification received with payload: $value');
      onClickedNotification(value);
    });
  }

  // Future<void> _deleteExpiredReminders(String uid) async {
  //   try {
  //     QuerySnapshot snapshot = await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(uid)
  //         .collection("reminders")
  //         .where("timestamp", isLessThan: DateTime.now())
  //         .get();
  //
  //     for (DocumentSnapshot doc in snapshot.docs) {
  //       await doc.reference.delete();
  //     }
  //   } catch (e) {
  //     print("Error deleting expired reminders: $e");
  //   }
  // }
  //
  // void _checkAndDeleteExpiredReminders() {
  //   // Get current user UID
  //   String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  //
  //   // Check and delete expired reminders
  //   if (uid.isNotEmpty) {
  //     _deleteExpiredReminders(uid);
  //   }
  // }

  void onClickedNotification(String? payload) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            userName = userDoc['name'];
          });
        }
      } catch (e) {
        debugPrint('Error fetching user data: $e');
      }
    }
  }

  Future<void> _editReminder(String uid, String reminderId) async {
    await showDialog(
      context: context,
      builder: (context) {
        return EditReminder(uid: uid, reminderId: reminderId);
      },
    );
  }

  Future<void> _deleteReminder(String uid, String reminderId) async {
    await showDialog(
      context: context,
      builder: (context) {
        return DeleteReminder(uid: uid, reminderId: reminderId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors.secondaryColor2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Hii $userName,",
              style: TextStyle(color: appColors.blackColor),
            ),
            InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => loginScreen()),
                );
              },
              child: Icon(Icons.logout),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user?.uid)
            .collection("reminders")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(appColors.primaryColor1),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error fetching reminders: ${snapshot.error}"),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No reminders added"),
            );
          }
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = data.docs[index];
              String reminderId = doc.id;
              Timestamp t = doc['timestamp'];
              String title = doc['title'];
              String desc = doc['desc'];
              DateTime date = t.toDate();
              String formattedTime = DateFormat.jm().format(date);

              // Schedule the notification only once and ensure it's done correctly
              if (DateTime.now().isBefore(date)) {
                Notificationlogic.showNotification(
                  dateTime: date,
                  id: index,
                  title: "Reminder",
                  body: title,
                );
              }

              return Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  child: ListTile(
                    title: Text(
                      formattedTime,
                      style: TextStyle(
                        color: appColors.blackColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: appColors.blackColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          desc,
                          style: TextStyle(
                            color: appColors.blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: appColors.blackColor),
                          onPressed: () async {
                            await _editReminder(user!.uid, reminderId);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: appColors.blackColor),
                          onPressed: () async {
                            await _deleteReminder(user!.uid, reminderId);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () async {
          if (user != null) {
            await addReminder(context, user!.uid);
          }
        },
        child: Center(
          child: Icon(
            Icons.add,
            color: appColors.blackColor,
          ),
        ),
      ),
    );
  }
}
