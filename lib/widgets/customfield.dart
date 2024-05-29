import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remindme/utility/appColor.dart';

class customField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType textInputType;
  final bool isObsecureText;

  const customField(
      {super.key,
      this.textEditingController,
      this.validator,
      this.onChanged,
      required this.textInputType,
      this.isObsecureText=false,
     });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: CupertinoColors.extraLightBackgroundGray,
        borderRadius: BorderRadius.circular(10)
      ),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: isObsecureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          enabledBorder: InputBorder.none,
        ),
        validator: validator,
      ),
    );
  }
}
