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
      required this.isObsecureText,
     });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.primaryColor2,
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
