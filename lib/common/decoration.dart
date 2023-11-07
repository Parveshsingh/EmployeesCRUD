import 'package:demoapp/common/text_styles.dart';
import 'package:flutter/material.dart';
import 'borders.dart';
import 'dimens.dart';

inputfieldDecoration(String labeltext,
    {isMandate = false,
      padding =
      const EdgeInsets.only(top: 0, bottom: 10, left: 16, right: 16), suffixIcon,suffixText,prefixIcon}) {
  return InputDecoration(
    isDense: true,
    alignLabelWithHint: true,
    contentPadding: padding,
    suffixText: suffixText,
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
    suffixStyle: regular_TextStyle(color: Colors.black),
    hintText: labeltext,
    counterText: "",
    hintStyle: regular_TextStyle(color: Colors.grey, fontSize: Dimens.dp14),
    filled: true,
    fillColor: Colors.white,
    border: inputBorderAll(radius: Dimens.cornorRadius),
  );
}

dropDownDecoration(String labeltext,
    {padding =
    const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 10),suffixIcon,enabled = true}) {
  return InputDecoration(
    suffixIcon: suffixIcon,
    isDense: true,
    alignLabelWithHint: true,
    contentPadding: padding,
    hintText: labeltext,
    counterText: "",
    hintStyle: regular_TextStyle(color: Colors.grey),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: inputBorderAll(color: enabled ? Colors.black : Colors.grey),
    focusedBorder: inputBorderAll(width: 2.0, color: Colors.black),
  );
}

searchBoxDecoration(String labeltext,
    {padding =
    const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16)}) {
  return InputDecoration(
      isDense: true,
      alignLabelWithHint: true,
      contentPadding: padding,
      labelText: labeltext,
      counterText: "",
      labelStyle: regular_TextStyle(color: Colors.grey, fontSize: Dimens.dp14),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: inputBorderAll(),
      focusedBorder: inputBorderAll(width: 2.0, color: Colors.blue)
  );
}


dateFieldDecoration(String labeltext,
    {padding =
    const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),enabled = true,suffixIcon}) {
  return InputDecoration(
      suffixIcon: suffixIcon,
      isDense: true,
      alignLabelWithHint: true,
      contentPadding: padding,
      hintText: labeltext,
      counterText: "",
      hintStyle: regular_TextStyle(color: Colors.grey, fontSize: Dimens.dp12),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: inputBorderAll(color: enabled ? Colors.black : Colors.grey),
      focusedBorder: inputBorderAll(width: 2.0, color: Colors.lightBlue)
  );
}
boxDecoration({color = Colors.grey,boxcolor = Colors.white}) {
  return BoxDecoration(
    color: boxcolor,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(color: color, style: BorderStyle.solid),
  );
}

