import 'package:flutter/material.dart';
import 'package:impulsrefactor/Services/firebase_service.dart';

class Components {
  bool showLogoutButton(BuildContext context) {
    return ModalRoute.of(context).settings.name != '/login' && ModalRoute.of(context).settings.name != '/session_guide';
  }

  AppBar appBar(BuildContext context, String title) {
    FirebaseHandler _firebaseHandler = FirebaseHandler();

    return AppBar(
      leading: Container(),
      centerTitle: true,
      title: Text(title),
      actions: [
        Visibility(
          visible: showLogoutButton(context),
          child: TextButton(
            onPressed: () async {
              await _firebaseHandler.signOut();
              Navigator.of(context).popUntil(ModalRoute.withName('/login'));
            },
            child: Icon(Icons.power_settings_new, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
