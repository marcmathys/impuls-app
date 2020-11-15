import 'package:flutter/material.dart';
import 'package:impulsrefactor/Services/firebase_service.dart';
import 'package:impulsrefactor/Views/Components/components.dart';

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
  FirebaseHandler _handler;

  @override
  void initState() {
    super.initState();
    _handler = FirebaseHandler();
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
    //TODO: Implement
    return true;
  }

  Widget build(BuildContext context) {
    _handler.getCurrentUser().whenComplete(() => Navigator.of(context).pushNamed('/patient_select'));

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
                    validator: (value) => (value.isEmpty) ? "Please enter email" : null,
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
                    validator: (value) => (value.isEmpty) ? "Please enter password" : null,
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
                          if (await _handler.signIn(_email.text, _password.text)) {
                            String statusMessage = await _handler.loadTherapist();
                            if (statusMessage == 'OK') {
                              Navigator.of(context).pushNamed('/patient_select');
                            } else {
                              _key.currentState.showSnackBar(SnackBar(content: Text(statusMessage)));
                            }
                          } else {
                            _key.currentState.showSnackBar(
                              SnackBar(content: Text("User authentication failed."), duration: Duration(seconds: 5),),
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
