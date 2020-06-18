import 'package:flutter/material.dart';
import 'package:impulsrefactor/Views/Components/components.dart';

import '../firebase_handler.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _email;
  TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  final FirebaseHandler _firebaseHandler = FirebaseHandler();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  bool validate() {
    return true;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: Components.appBar('Impuls'),
      body: Form(
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
                    validator: (value) => (value.isEmpty) ? "Please Enter Email" : null,
                    style: style,
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
                    validator: (value) => (value.isEmpty) ? "Please Enter Password" : null,
                    style: style,
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
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.indigo,
                    child: MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (await _firebaseHandler.signIn(_email.text, _password.text)) {
                            _firebaseHandler.retrievePatientData();
                            Navigator.of(context).pushNamed('/patient_select');
                          } else {
                            _key.currentState.showSnackBar(
                              SnackBar(content: Text("Could not authenticate user.")),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Sign In',
                        style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
