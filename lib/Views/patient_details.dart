import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/patient.dart';
import 'package:impulsrefactor/Entities/session.dart';
import 'package:impulsrefactor/Services/firebase_handler.dart';
import 'package:impulsrefactor/Views/Components/components.dart';
import 'package:impulsrefactor/Views/Components/pain_level_chart_component.dart';
import 'package:impulsrefactor/Views/Components/threshold_chart.dart';
import 'package:intl/intl.dart';

class PatientDetail extends StatefulWidget {
  Patient _patient;
  Session _currentSession;

  @override
  _PatientDetailState createState() => _PatientDetailState();
}

class _PatientDetailState extends State<PatientDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget._patient = ModalRoute.of(context).settings.arguments;

    if (widget._patient.sessions.isNotEmpty) {
      widget._currentSession = widget._patient.sessions.last;
    }
  }

  List<DropdownMenuItem<Session>> buildDropdownMenuList() {
    if (widget._patient.sessions.isEmpty) {
      return [DropdownMenuItem(value: null, child: Text('No sessions'))];
    } else {
      return widget._patient.sessions.map((Session session) {
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
      appBar: Components.appBar('Sessions of ${widget._patient.moodleID}'),
      body: SingleChildScrollView(
        child : Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                    flex: 1,
                    child: DropdownButton(
                      value: widget._currentSession,
                      items: buildDropdownMenuList(),
                      onChanged: (newValue) {
                        setState(() {
                          widget._currentSession = newValue;
                        });
                      },
                    )),
                Flexible(
                    flex: 1,
                    child: RaisedButton(onPressed: () => Navigator.of(context).pushNamed('/session_guide'), child: Text('Start new session'))),
              ],
            ),
            Divider(thickness: 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  child: ThresholdChart(
                    prepareThresholdData(widget._currentSession.sensoryThreshold),
                    prepareThresholdData(widget._currentSession.painThreshold),
                    prepareThresholdData(widget._currentSession.toleranceThreshold),
                  ),
                ),
                Flexible(
                  child: PainLevelChart(widget._currentSession.prePainRating, widget._currentSession.postPainRating),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
