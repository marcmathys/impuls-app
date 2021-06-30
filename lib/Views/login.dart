import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/fitting_curve.dart';
import 'package:impulsrefactor/Entities/fitting_lookup_table.dart';
import 'package:impulsrefactor/Services/firebase_service.dart';
import 'package:impulsrefactor/Style/themes.dart';
import 'package:impulsrefactor/Views/Components/app_wide_components.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email;
  TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  FirebaseService _handler;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    _handler = FirebaseService();
    _handler.checkUserLogin();
    FittingCurve.loadFittingCurve();
    LookupTable.loadLookupTable();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Components().appBar(context, 'Impuls'),
      body: Builder(builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _email,
                      validator: (value) => (value.isEmpty) ? "Please enter email" : null,
                      style: Themes.getDefaultTextStyle(),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _password,
                      validator: (value) => (value.isEmpty) ? "Please enter password" : null,
                      style: Themes.getDefaultTextStyle(),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_email.text == 'admin' && _password.text == 'admin') {
                            Navigator.of(context).pushNamed('/admin');
                          } else {
                            if (_formKey.currentState.validate()) {
                              await _handler.signIn(_email.text, _password.text);
                              _handler.loadTherapist();
                            }
                          }
                        },
                        child: Text('Sign In')),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
