import 'package:flutter/material.dart';

//This Package contains the widgets for all the Form related widgets
typedef CallBackString(String val);

TextFormField getTextFormFieldLogin({
  @required BuildContext context,
  @required TextEditingController controller,
  @required String strHintText,
  @required String strLabelText,
  Color textColor,
  Color fillColor,
  int maxLines,
  TextInputType keyboardType,
  CallBackString validator,
  CallBackString onChanged,
}) {
  return TextFormField(
      controller: controller,
      decoration: new InputDecoration(
        hintText: strHintText,
        fillColor: fillColor == null ? Colors.white : fillColor,
        hintStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04, color: textColor == null ? Colors.white : textColor),
        labelText: strLabelText,
        labelStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04, color: textColor == null ? Colors.white : textColor),
        enabledBorder: const UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
        ),
      ),
      keyboardType: keyboardType == null ? TextInputType.phone : keyboardType,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05, color: textColor == null ? Colors.white : textColor),
      maxLines: maxLines == null ? 1 : maxLines,
      validator: (val) => validator(val),
      onChanged: (val) => onChanged(val));
}
