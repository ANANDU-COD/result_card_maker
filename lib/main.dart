import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/input_form_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eagles Result Card',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: InputFormView(),
    );
  }
}
