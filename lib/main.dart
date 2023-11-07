import 'package:demoapp/pages/home/homePage.dart';
import 'package:flutter/material.dart';
import 'common/sizeConfig.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return  MaterialApp(
      title: 'Employee',
      debugShowCheckedModeBanner: false,
      home:  HomePage(),
    );
  }
}