import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remindme/Pages/Login/login.dart';
import 'package:remindme/services/notificationLogic.dart';
import 'package:remindme/utility/appColor.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user;
  @override
  void initState(){
    super.initState();
    user=FirebaseAuth.instance.currentUser;
    Notificationlogic.init(context, user!.uid);
    listenNotification();
  }

  void listenNotification(){
    Notificationlogic.onNotification.listen((value){});
  }

  void onClickedNotification(String? payload){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors.secondaryColor2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Hii User",
              style: TextStyle(
                color: appColors.blackColor
              ),
            ),
            InkWell(
                onTap: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (BuildContext context)=> loginScreen())
                  );
                },
                child: Icon(Icons.logout)
            )
          ],
        ),
      ),
    );
  }
}
