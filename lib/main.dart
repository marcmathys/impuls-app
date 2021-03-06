import 'package:flutter/material.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:impulsrefactor/States/message_state.dart';
import 'package:impulsrefactor/Views/debug.dart';
import 'package:impulsrefactor/Views/patient_details.dart';
import 'package:impulsrefactor/Views/patient_select.dart';
import 'package:impulsrefactor/Views/session.dart';
import 'package:provider/provider.dart';

import 'Views/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => BTState()),
    ChangeNotifierProvider(create: (_) => MessageState()),
  ], child: ImpulsMain()));
}

class ImpulsMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.indigo,
        buttonColor: Colors.blue,
      ),
      title: 'Impuls',
      debugShowCheckedModeBanner: false,
      initialRoute: '/patient_select',
      //TODO: Debug! Change to /login!
      routes: {
        '/login': (BuildContext context) => Login(),
        '/patient_select': (BuildContext context) => PatientSelect(),
        '/patient_details': (BuildContext context) => PatientDetail(),
        '/session': (BuildContext context) => Session(),
        '/debug': (BuildContext context) => Debug(),
      },
    );
  }
}
