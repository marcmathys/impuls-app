import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:impulsrefactor/Views/debug_view.dart';
import 'package:impulsrefactor/Views/patient_select.dart';
import 'package:provider/provider.dart';

import 'Views/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BTState()),
      ],
      child: ImpulsMain()));
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
      initialRoute: '/patient_select', //TODO: Debug! Change to /login!
      routes: {
        '/login': (BuildContext context) => Login(),
        '/patient_select': (BuildContext context) => PatientSelect(),
        '/debug': (BuildContext context) => Debug(),
      },
    );
  }
}

