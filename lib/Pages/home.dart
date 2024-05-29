import 'package:flutter/material.dart';
import 'package:remindme/utility/appColor.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            IconButton(
                onPressed: (){},
                icon: Icon(
                    Icons.logout
                )
            )
          ],
        ),
      ),
    );
  }
}
