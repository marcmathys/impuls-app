import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impulsrefactor/Entities/patient.dart';
import 'package:impulsrefactor/Entities/session.dart';
import 'package:impulsrefactor/States/current_patient.dart';
import 'package:impulsrefactor/Views/Components/app_wide_components.dart';
import 'package:impulsrefactor/Views/Components/pain_level_chart_component.dart';
import 'package:impulsrefactor/Views/Components/threshold_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientDetail extends StatefulWidget {
  @override
  _PatientDetailState createState() => _PatientDetailState();
}

class _PatientDetailState extends State<PatientDetail> {
  Session _displaySession;
  Patient _patient;

  @override
  void initState() {
    super.initState();
    _patient = context.read(currentPatientProvider);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _patient = context.read(currentPatientProvider);
    if (_patient.sessions.isNotEmpty) {
      _displaySession = _patient.sessions.last;
    }
  }

  List<DropdownMenuItem<Session>> buildDropdownMenuList() {
    if (_patient.sessions.isEmpty) {
      return [DropdownMenuItem(value: null, child: Text('No sessions', style: Theme.of(context).textTheme.bodyText1))];
    } else {
      return _patient.sessions.map((Session session) {
        return DropdownMenuItem(value: session, child: Text(DateFormat.yMMMd().format(session.date), style: Theme.of(context).textTheme.bodyText1));
      }).toList();
    }
  }

  List<int> prepareThresholdData(List<int> patientRatings) {
    List<int> thresholds = [];
    if (patientRatings.length == 5) {
      thresholds.add((patientRatings[0] + patientRatings[1]) ~/ 2);
      thresholds.add((patientRatings[2] + patientRatings[3]) ~/ 2);
      thresholds.add(patientRatings[4]);
    }
    return thresholds;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Components().appBar(context, 'Sessions of ${_patient.moodleID}'),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                    flex: 1,
                    child: DropdownButton(
                      value: _displaySession,
                      items: buildDropdownMenuList(),
                      onChanged: (newValue) {
                        setState(() {
                          _displaySession = newValue;
                        });
                      },
                    )),
                Flexible(
                    flex: 1, child: ElevatedButton(onPressed: () => Get.toNamed('session_guide'), child: Text('Start new session', style: Theme.of(context).textTheme.bodyText1))),
              ],
            ),
            Divider(
              thickness: 2,
            ),
            _displaySession != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(
                        child: ThresholdChart(
                          prepareThresholdData(_displaySession.sensoryThreshold),
                          prepareThresholdData(_displaySession.painThreshold),
                          prepareThresholdData(_displaySession.toleranceThreshold),
                        ),
                      ),
                      Flexible(
                        child: PainLevelChart(_displaySession.prePainRating, _displaySession.postPainRating),
                      ),
                    ],
                  )
                : Center(child: Text('No previous sessions found.')),
          ],
        ),
      ),
    );
  }
}
