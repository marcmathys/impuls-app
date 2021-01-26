import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/patient.dart';
import 'package:impulsrefactor/Entities/session.dart';
import 'package:impulsrefactor/States/session_state.dart';
import 'package:impulsrefactor/Views/Components/app_wide_components.dart';
import 'package:impulsrefactor/Views/Components/pain_level_chart_component.dart';
import 'package:impulsrefactor/Views/Components/threshold_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PatientDetail extends StatefulWidget {
  @override
  _PatientDetailState createState() => _PatientDetailState();
}

class _PatientDetailState extends State<PatientDetail> {
  Session _currentSession;
  Patient _patient;

  @override
  void initState() {
    super.initState();
    _patient = Provider.of<SessionState>(context, listen: false).currentPatient;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _patient = Provider.of<SessionState>(context, listen: false).currentPatient;
    if (_patient.sessions.isNotEmpty) {
      _currentSession = _patient.sessions.last;
    }
  }

  List<DropdownMenuItem<Session>> buildDropdownMenuList() {
    if (_patient.sessions.isEmpty) {
      return [DropdownMenuItem(value: null, child: Text('No sessions'))];
    } else {
      return _patient.sessions.map((Session session) {
        return DropdownMenuItem(value: session, child: Text(DateFormat.yMMMd().format(session.date)));
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
      appBar: Components.appBar(context, 'Sessions of ${_patient.moodleID}'),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                    flex: 1,
                    child: DropdownButton(
                      value: _currentSession,
                      items: buildDropdownMenuList(),
                      onChanged: (newValue) {
                        setState(() {
                          _currentSession = newValue;
                        });
                      },
                    )),
                Flexible(
                    flex: 1,
                    child: RaisedButton(onPressed: () => Navigator.of(context).pushNamed('/session_guide'), child: Text('Start new session'))),
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  child: ThresholdChart(
                    prepareThresholdData(_currentSession.sensoryThreshold),
                    prepareThresholdData(_currentSession.painThreshold),
                    prepareThresholdData(_currentSession.toleranceThreshold),
                  ),
                ),
                Flexible(
                  child: PainLevelChart(_currentSession.prePainRating, _currentSession.postPainRating),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
