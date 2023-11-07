import 'package:demoapp/common/sizeConfig.dart';
import 'package:demoapp/common/text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dimens.dart';
import 'images.dart';

dynamic loader;

//create Common Function For Showing Loader
showLoader(BuildContext context) {
  loader ??= showDialog(
      useSafeArea: true,
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false,
      builder: (_) {
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  color: Colors.transparent,
                  height: getProportionateScreenHeight(125),
                  width: getProportionateScreenHeight(125),
                  child: Center(
                    child: Container(
                        color: Colors.transparent,
                        height: getProportionateScreenHeight(125),
                        width: getProportionateScreenWidth(125),
                        clipBehavior: Clip.none,
                        child: Image.asset(
                          Images.loader,
                        )),
                  ),
                ),
              ),
            ));
      });
}

//create Common Function For Cancel Loader
cancelLoader(BuildContext context) {
  if (loader != null) {
    Navigator.pop(context);
    loader = null;
  }
}

printText(text) {
  if (kDebugMode) {
    print(text.toString());
  }
}

//Create Common Function For Showing toast(message)
showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    fontSize: 16.0,
  );
}

dateFormatter(selecteddate) {
  DateTime date = DateTime.parse(selecteddate);
  String formattedDate = DateFormat('d MMM, y').format(date);
  return formattedDate;
}

checkNextMonday()
{
  DateTime currentDate = DateTime.now();
  if (currentDate.weekday == DateTime.monday) {
    currentDate = currentDate.add(const Duration(days: 7));
  } else {
    while (currentDate.weekday != DateTime.monday) {
      currentDate = currentDate.add(const Duration(days: 1));
    }
  }
  return currentDate;
}

checkNextTuesday()
{
  DateTime currentDate = DateTime.now();

  while (currentDate.weekday != DateTime.tuesday) {
    currentDate = currentDate.add(const Duration(days: 1));
  }

  return currentDate;
}

showAlertDialog(context,
    {String dialogTitle = "Title", textMsg, onPressed , isCancellable,okYesText = "OK"}) {
  showDialog(
      context: context,
      barrierDismissible: isCancellable,
      builder: (_) => AlertDialog(
        title: Text(dialogTitle),
        content: Text(textMsg),
        actions: <Widget>[
          // negativeButton('Cancel', onPress: () => Navigator.pop(context), elevation: 5.0, backColor: Colors.blue),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue[100]), // Change the color here
            ),
            child: Text(
              "Cancel",
              style: regular_TextStyle(
                  color: Colors.blue, fontSize: Dimens.dp20),
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue), // Change the color here
            ),
            onPressed: onPressed,
            child: Text(
              okYesText,
              style: regular_TextStyle(
                  color: Colors.white, fontSize: Dimens.dp20),
            ),
          )
          // positiveButton('Ok', onPress: onPressed, elevation: 5.0, backColor: ColorsDefault.colorPrimary),
        ],
      ));
}

