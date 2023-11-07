
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dimens.dart';


semiBoldTextStyle({ color = Colors.black, fontSize = Dimens.dp14}){
  return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w600
  );
}
boldTextStyle({color = Colors.black, fontSize = Dimens.dp14}){
  return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w700
  );
}
regular_TextStyle({ color = Colors.black, fontSize = Dimens.dp14}){
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w400,

  );
}