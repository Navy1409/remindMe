import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remindme/Pages/Login/login.dart';
import 'package:remindme/services/notificationLogic.dart';
import 'package:remindme/utility/appColor.dart';
import 'package:remindme/widgets/addReminder.dart';

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
  }

  void listenNotification() {
    Notificationlogic.onNotification.listen((value) {
      debugPrint('Notification received with payload: $value');
      onClickedNotification(value);
    });
  }

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
            .collection("reminder")
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
              Timestamp t = doc['time'];
              String title = doc['title'];
              String desc = doc['desc'];
              DateTime date = t.toDate();
              String formattedTime = DateFormat.jm().format(date);

              Notificationlogic.showNotification(
                dateTime: date,
                id: 0,
                title: "Reminder",
                body: title,
              );

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
