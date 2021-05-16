import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:impulsrefactor/Adminpanel/admin_screen.dart';
import 'package:impulsrefactor/Views/Debug/debug.dart';
import 'package:impulsrefactor/Views/login.dart';
import 'package:impulsrefactor/Views/patient_details.dart';
import 'package:impulsrefactor/Views/patient_select.dart';
import 'package:impulsrefactor/Views/session_guide.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: ImpulsMain()));
}

class ImpulsMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Colors.indigo,
        buttonColor: Colors.blue,
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
            bodyText1: TextStyle(fontSize: 20), // Standard Text
            bodyText2: TextStyle(fontSize: 30, color: Colors.red, fontWeight: FontWeight.bold) // Error messages
            ),
      ),
      title: 'Impuls',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => Login(),
        '/patient_select': (BuildContext context) => PatientSelect(),
        '/patient_details': (BuildContext context) => PatientDetail(),
        '/session_guide': (BuildContext context) => SessionGuide(),
        '/debug': (BuildContext context) => Debug(),
        '/admin': (BuildContext context) => AdminScreen(),
      },
    );
  }
}
