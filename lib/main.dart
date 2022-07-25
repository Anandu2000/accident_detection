//import 'dart:js';

//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:accident_detection/pages/home.dart';
import 'package:accident_detection/pages/warning.dart';
import 'package:accident_detection/pages/warningNew.dart';
import 'package:accident_detection/pages/send_Message.dart';
import 'package:accident_detection/pages/home.dart';
import 'package:accident_detection/pages/addContacts.dart';
//import 'package:accident_detection/pages/testPage.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/' : (context) => Home(),
      '/addContacts' : (context) => AddContacts(),
      '/warning' : (context) => CountDownTimer(),
      '/send' : (context) => SendMessage(),
      '/loading' : (context) => Loading(),
    },
  ));
}
