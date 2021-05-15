import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/patient.dart';
import 'package:impulsrefactor/Services/firebase_service.dart';
import 'package:impulsrefactor/States/current_patient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientTile extends StatelessWidget {
  PatientTile(this.patient);

  final Patient patient;
  final FirebaseHandler _handler = FirebaseHandler();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _handler.addSessionsToPatient(patient);
        context.read(currentPatientProvider.notifier).setPatient(patient);
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
            Flexible(flex: 2, child: Text(patient.moodleID, style: Theme.of(context).textTheme.bodyText1)),
            Flexible(flex: 1, child: Icon(Icons.keyboard_arrow_right)),
          ],
        ),
      ),
    );
  }
}
