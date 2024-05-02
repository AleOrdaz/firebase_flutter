import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter/add.dart';
import 'package:firebase_flutter/firebase_options.dart';
import 'package:firebase_flutter/login.dart';
import 'package:flutter/material.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //inicia widgets
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp( //inicia firevase con los opcines agregadas
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  final FirebaseFirestore db = FirebaseFirestore.instance; //instancia de BD
  final CollectionReference users = db.collection('users'); //Referencia de la tabla
  print('');
  print('users');

  final Map<String, dynamic> userFields = {
    'name': 'alejandro2',
    'last_name': 'ordaz',
    'age': '28'
  };
  await users.doc().set(userFields);

  /*final Map<String, dynamic> userFields = {
    'name': 'oscar alejandro',
  };
  await users.doc('newUser').update(userFields);

  await users.doc('newUser').delete;*/

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}
