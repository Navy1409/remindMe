import 'package:flutter/material.dart';
import 'package:remindme/utility/appColor.dart';

class customButton extends StatelessWidget {
  final String title;
  final Function() onPressed;

  const customButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: appColors.primaryColor1,
          borderRadius: BorderRadius.circular(20)
        ),
        child: MaterialButton(onPressed: onPressed,
        height: 50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textColor: appColors.whiteColor,
          child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        ),
      ),
    );
  }
}
