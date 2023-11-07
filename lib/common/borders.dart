import 'package:flutter/material.dart';
import 'dimens.dart';

inputBorderAll(
    {width = 1.0, radius = Dimens.cornorRadius, color = Colors.grey}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    borderSide: BorderSide(color: color, width: width),
  );
}

outlineBorderAll(
    {width = 1.0, radius = Dimens.cornorRadius, color = Colors.black}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    borderSide: BorderSide(color: color, width: width),
  );
}

roundedBorder(
    {radius = Dimens.cornorRadius, borderColor = Colors.black, borderWidth = 1.0}) {
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: borderColor, width: borderWidth));
}

boxDecorationCustom(
    {radius = Dimens.cornorRadius, borderColor = Colors.black, borderWidth = 1.0}) {
  return BoxDecoration(
    border: Border.all(color: borderColor, width: borderWidth),
    borderRadius: BorderRadius.all(
      Radius.circular(radius),),
  );
}

