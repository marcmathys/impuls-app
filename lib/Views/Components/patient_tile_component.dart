import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/patient.dart';
import 'package:impulsrefactor/Services/firebase_service.dart';
import 'package:impulsrefactor/States/session_state.dart';
import 'package:provider/provider.dart';

class PatientTile extends StatelessWidget {
  PatientTile(this.patient);

  final Patient patient;
  final FirebaseHandler _handler = FirebaseHandler();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _handler.addSessionsToPatient(patient);
        Provider.of<SessionState>(context, listen: false).currentPatient = patient;
        Navigator.of(context).pushNamed('/patient_details');
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        color: Color(0xD4D4D4FF),
        height: MediaQuery.of(context).size.height / 15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(flex: 1, child: Icon(patient.icon)),
            Flexible(flex: 2, child: Text(patient.moodleID)),
            Flexible(flex: 1, child: Icon(Icons.keyboard_arrow_right)),
          ],
        ),
      ),
    );
  }
}
