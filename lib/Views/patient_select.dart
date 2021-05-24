import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impulsrefactor/Entities/patient_list.dart';
import 'package:impulsrefactor/Entities/therapist.dart';
import 'package:impulsrefactor/Style/themes.dart';
import 'package:impulsrefactor/Views/Components/app_wide_components.dart';
import 'package:impulsrefactor/Entities/patient.dart';
import 'package:impulsrefactor/Views/Components/patient_tile_component.dart';

class PatientSelect extends StatefulWidget {
  @override
  _PatientSelectState createState() => _PatientSelectState();
}

class _PatientSelectState extends State<PatientSelect> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Components().appBar(context, 'Hello, ${Therapist().name}!'),
      floatingActionButton: FloatingActionButton(onPressed: () => Get.toNamed('/debug'), child: Text('Debug')),
      body: Builder(builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            Text('Please select a patient from the list', style: Themes.getDefaultTextStyle()),
            Flexible(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('patients').where('therapistUIDs', arrayContains: Therapist().uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text('Loading', style: Themes.getDefaultTextStyle()));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      Patient patient = PatientList().addPatientFromSnapshot(snapshot.data.docs[index]);
                      return PatientTile(patient);
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
