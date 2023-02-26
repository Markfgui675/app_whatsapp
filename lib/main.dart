import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cadastro.dart';
import 'home.dart';
import 'login.dart';

void main(){

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
      primaryColor: Color(0xff25d366),
      accentColor: Color(0xff25d366)
    ),
    debugShowCheckedModeBanner: false,
  ));
}
